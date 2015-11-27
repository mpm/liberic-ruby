module Liberic

  # Provides an interface to ERiC's configuration parameters and logging.
  #
  # == Scope
  #
  # This class is not meant to be instantiated directly. An instance is created
  # the first time it is accessed in the Liberic namespace.
  #
  #   Liberic.config # will return an instance of Config
  #
  # == Configuration parameters
  #
  # Configuration parameters can be accessed with the hash notation.
  # Keys are passed to ERiC directly, so they must be in German (see ERiC
  # documentation for this).
  #
  # Example:
  #
  #   Liberic.config['validieren.fehler_max'] # 30
  #
  # +Config+ provides an english abstraction to these parameters with +attr_accessor+
  # like getter/setter methods:
  #
  #   Liberic.config.validation_error_limit = 30
  #
  # The most common settings are (german names in paranthesis)
  #
  # * +data_path+ (basis.data_dir) directory to store PDFs and certificates in
  # * +allow_test_id+ (basis.test_id_erlaubt) allow fake tax ids when processing tax filings
  # * +detailed_logs+ (log.detailed) set log level to debug. Also disables rolling logs (if +detailed_logs+ is +false+, ERiC will create a maximum of ten log files on disk, each with 1 MB of size. The oldest file will be deleted when rolling over). *WARNING*: Logging to disk is disabled after instantiating +Config+. See +:logger:+ for details.
  # * +validation_error_limit+ (validieren.fehler_max) limits the amount of errors that are returned when processing or checking tax filings. This means even though 50 fields inside the tax report are missing, only the first 30 are reported as part of the response.
  # * +online+ (transfer.netz.doi) allow connecting to the actual tax authority's production systems.
  #
  class Config
    attr_reader :logger

    def initialize
      install_logger
    end

    # Assign an instance of Logger that will be called whenever ERiC creates
    # log output.
    # Please note that ERiC's mechanism to write log files to disk is disabled
    # as soon as a +Config+ class is instantiated!
    #
    # ==== Attributes
    #
    # * +logger+ - A Ruby Logger instance or nil
    #
    # ==== Examples
    #
    # An instance of +Config+ is provided in the +Liberic+ namespace. A logger
    # can be assigned like this:
    #
    #    Liberic.config.logger = Logger.new(STDOUT)
    #    Liberic.config.logger.level = Logger::WARN
    #
    # ERiC does not send debug log messages by default. To do this, change ERiC's
    # configuration:
    #
    #    Liberic.config.detailed_logs = true
    #
    # and make sure +:level:+ of your +Logger+ is not filtering debug messages.
    #
    def logger=(logger)
      @logger = logger
    end

    {
      'basis.home_dir'            => :eric_home,
      'basis.log_dir'             => :log_path,
      'basis.data_dir'            => :data_path,
      'basis.test_id_erlaubt'     => :allow_test_id,
      'log.detailed'              => :detailed_logs,
      'transfer.connect_timeout'  => :connect_timeout,
      'transfer.response_timeout' => :response_timeout,
      'validieren.fehler_max'     => :validation_error_limit,
      'transfer.netz.doi'         => :online,
      'http.proxy_host'           => :proxy_host,
      'http.proxy_port'           => :proxy_port,
      'http.proxy_username'       => :proxy_username,
      'http.proxy_password'       => :proxy_password,
      'http.proxy_auth'           => :proxy_auth
    }.each do |setting_in_eric, setting_in_ruby|
      define_method setting_in_ruby do
        send(:[], setting_in_eric)
      end

      define_method "#{setting_in_ruby}=" do |value|
        send(:[]=, setting_in_eric, value)
      end
    end

    def [](key)
      convert_to_ruby(
        Helpers::Invocation.with_result_buffer do |handle|
          SDK::API.einstellung_lesen(key, handle)
        end
      )
    end

    def []=(key, value)
      Helpers::Invocation.raise_on_error(
        SDK::API.einstellung_setzen(
          key,
          convert_to_eric(value)
        )
      )
    end

    private

    def install_logger
      Helpers::Invocation.raise_on_error(
        SDK::API.registriere_log_callback(
          SDK::API.generate_log_callback do |category, level, message|
            if @logger.respond_to?(:add)
              @logger.add(SDK::Types::LOGGER_SEVERITY[level], message, category)
            end
          end,
        0, nil)
      )
    end

    def convert_to_ruby(value)
      if value.to_i.to_s == value
        value.to_i
      elsif ['ja', 'yes'].include?(value.downcase)
        true
      elsif ['nein', 'no'].include?(value.downcase)
        false
      else
        value.force_encoding(SDK::Configuration::ENCODING).encode(Encoding::default_external)
      end
    end

    def convert_to_eric(value)
      if [true, false].include?(value)
        value ? 'ja' : 'nein'
      else
        value
      end.to_s.encode(SDK::Configuration::ENCODING)
    end

    def get(key)
      Helpers::Invocation.with_result_buffer(true) do |handle|
        SDK::API.einstellung_lesen(key, handle)
      end
    end

    def set(key, value)
      Helpers::Invocation.raise_on_error(SDK::API.einstellung_setzen(key, value))
      true
    end
  end
end

module Liberic
  class Config
    attr_reader :logger

    def initialize
      install_logger
    end

    def logger=(logger)
      @logger = logger
    end

    {
      'basis.home_dir'            => :eric_home,
      'basis.log_dir'             => :log_path,
      'basis.data_dir'            => :data_path,
      'basis.test_id_erlaubt'     => :allow_test_id,
      'log.detailed'              => :keep_logs,
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

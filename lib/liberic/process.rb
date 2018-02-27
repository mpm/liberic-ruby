module Liberic
  # +Process+ encapsulates the main functionality of ERiC. (+eric_bearbeite_vorgang+).
  #
  # +Process+ must be initialized with an XML string containing the tax filing (or other data to be submitted) as well
  # as the type of case.
  #
  # +Process+ exposes the +check+ method to let ERiC check the validity of the supplied XML schema. An Exception is thrown if
  # validation fails.
  #
  # Calling +check+ is optional. See +execute+ to start the actual execution of the tax case. +execute+ will +check+ as well (not in this library,
  # but ERiC will do this
  class Process
    class ExecutionError < StandardError
    end

    def initialize(xml, type)
      @xml = xml
      @type = type
    end

    def check
      Helpers::Invocation.with_result_buffer do |handle|
        SDK::API.check_xml(@xml, @type, handle)
      end
    end

    # Executes the actual call to +EricBearbeiteVorgang()+
    #
    # Taken an optional hash with an +:action+ parameter, which can be one of the following:
    #
    #   * +:validate+ validate the tax filing and return errors (local processing only)
    #   * +:print+ validate the tax filing and create summary PDF
    #   * +:print_and_submit+ validate the tax filing, create summary PDF and submit filing to ELSTER (server).
    #
    # Options for controlling the PDF output (printing)
    #
    #   * +:filename+     (set a filename including path where to store the PDF file)
    #   * +:draft+        (set to +false+ to remove the the text "*** ENTWURF ***" on every page)
    #   * +:footer+       (set a string that will be printed on ever page footer)
    #   * +:cover_page+   (set to +true+ to include a cover page)
    #   * +:duplex+       (set to +true+ to generate pages for duplex printing (alternating margin left and right)
    #
    # Other options
    #   * +:encryption+  An instance of +SDK::Types::VerschluesselungsParameter+ (Leave this empty when requesting BescheidRueckuebermittlung with CEZ (locally generated certificate))
    #                    No use case tested yet.
    #
    # TODO: Please note that some parameter combinations might result in errors and will return empty strings for the XML
    # (these errors are currently not checked). One example is using +draft: false+ with test data
    #
    # Set +Liberic.config.data_path+ to the location where the PDF should be stored, if +:filename+ is not provided.
    #
    # Example:
    #
    #   filing = Liberic::Process.new(xml_tax_filing, 'ESt_2011')
    #   filing.execute(action: :print)
    #
    # Will generate a PDF in the current directory if not specified otherwise.
    # *WARNING* method signature and parameters are WIP and subject to change
    def execute(options = {})
      action = options[:action] ||= :validate
      eric_action = ACTIONS[action] || (raise ExecutionError.new("Invalid action: #{action}. Valid actions are #{ACTIONS.keys.join(', ')}"))
      print_params = create_print_params(options)
      server_buffer = SDK::API.rueckgabepuffer_erzeugen
      result = Helpers::Invocation.with_result_buffer(false) do |local_buffer|
        SDK::API.bearbeite_vorgang(@xml, @type,
          eric_action,
          (action == :submit ? nil : print_params),
          options[:encryption],
          (action == :submit ? FFI::MemoryPointer.new(:uint32, 1) : nil), # transferHandle
          local_buffer,
          server_buffer)
      end
      server_result = SDK::API.rueckgabepuffer_inhalt(server_buffer)
      SDK::API.rueckgabepuffer_freigeben(server_buffer)
      print_params.pointer.free
      {
        result: result,
        server_result: server_result
      }
    end

    private

    ACTIONS = {
      validate: :validiere,
      print: :drucke,
      print_and_submit: :sende,
      submit: :sende,
      print_and_submit_auth: :sende_auth
    }

    def create_print_params(options)
      params = SDK::Types::DruckParameter.new
      params[:version]     = 2
      params[:ersteSeite]  = options[:cover_page] ? 1 : 0
      params[:duplexDruck] = options[:duplex] ? 1 : 0
      params[:vorschau]    = options.has_key?(:draft) ? (options[:draft] ? 1 : 0) : 1
      {pdfName: :filename,
       fussText: :footer}.each do |eric_param, ruby_param|
        if options[ruby_param]
          params[eric_param] = FFI::MemoryPointer.from_string(options[ruby_param]).address
        end
      end
      params
    end
  end
end

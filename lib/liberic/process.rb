module Liberic
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
    # Set +Liberic.config.data_path+ to the location where the PDF should be stored.
    #
    # Example:
    #
    #   filing = Liberic::Process.new(xml_tax_filing, 'ESt_2011')
    #   filing.execute(action: :print)
    #
    # Will generate a PDF in the current directory if not specified otherwise.
    # *WARNING* method signature and parameters are WIP and subject to change
    def execute(action: :validate)
      eric_action = ACTIONS[action] || (raise ExecutionError.new("Invalid action: #{action}. Valid actions are #{ACTIONS.keys.join(', ')}"))
      server_buffer = SDK::API.rueckgabepuffer_erzeugen
      result = Helpers::Invocation.with_result_buffer(false) do |local_buffer|
        SDK::API.bearbeite_vorgang(@xml, @type,
          eric_action,
          nil, #druck_params,
          nil,
          nil,
          local_buffer,
          server_buffer)
      end
      server_result = Liberic::SDK::API.rueckgabepuffer_inhalt(server_buffer)
      SDK::API.rueckgabepuffer_freigeben(server_buffer)
      {
        result: result,
        server_result: server_result
      }
    end

    private

    ACTIONS = {
      validate: :validiere,
      print: :drucke,
      print_and_submit: :sende
    }
  end
end

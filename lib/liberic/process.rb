module Liberic
  class Process
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
    # The optional +action+ parameter can be set to +print+ to generate a PDF from this case.
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
      #druck_params = SDK::Types::DruckParameter.new
      Helpers::Invocation.with_result_buffer(false) do |handle|
        SDK::API.bearbeite_vorgang(@xml, @type,
          action == :print ? :drucke : :validiere,
          nil, #druck_params,
          nil,
          nil,
          handle,
          nil)
      end
    end
  end
end

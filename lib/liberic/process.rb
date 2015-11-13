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

    def execute
      #druck_params = SDK::Types::DruckParameter.new
      Helpers::Invocation.with_result_buffer(false) do |handle|
        SDK::API.bearbeite_vorgang(@xml, @type,
          :validiere,
          nil, #druck_params,
          nil,
          nil,
          handle,
          nil)
      end
    end
  end
end

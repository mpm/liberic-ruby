module Liberic
  module Helpers
    module Invocation
      extend self

      def raise_on_error(value)
        return value if value == SDK::Fehlercodes::OK
        raise StandardError.new(SDK::Fehlercodes::CODES[value])
      end

      def with_result_buffer(&block)
        handle = SDK::API.rueckgabepuffer_erzeugen
        raise_on_error(yield(handle))
        result = Liberic::SDK::API.rueckgabepuffer_inhalt(handle)
        SDK::API.rueckgabepuffer_freigeben(handle)
        result
      end
    end
  end
end

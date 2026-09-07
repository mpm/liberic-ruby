module Liberic
  module Helpers
    module Invocation
      class Error < StandardError
      end

      extend self

      def raise_on_error(value)
        return value if value == SDK::Fehlercodes::ERIC_OK
        raise Error.new(SDK::Fehlercodes::CODES[value])
      end

      def with_result_buffer(raise_on_error = true, &block)
        handle = SDK::API.rueckgabepuffer_erzeugen
        if raise_on_error
          raise_on_error(yield(handle))
        else
          yield(handle)
        end
        result = Liberic::SDK::API.rueckgabepuffer_inhalt(handle)
        SDK::API.rueckgabepuffer_freigeben(handle)
        result
      end

      def with_local_and_server_result_buffers(&block)
        local_handle = SDK::API.rueckgabepuffer_erzeugen
        server_handle = SDK::API.rueckgabepuffer_erzeugen

        error_code = yield(local_handle, server_handle)

        local_result = Liberic::SDK::API.rueckgabepuffer_inhalt(local_handle)
        server_result = Liberic::SDK::API.rueckgabepuffer_inhalt(server_handle)

        return {
          error_code: error_code,
          error_message: SDK::Fehlercodes::CODES[error_code],
          local_result: local_result,
          server_result: server_result
        }
      end
    end
  end
end

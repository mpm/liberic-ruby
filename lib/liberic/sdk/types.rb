module Liberic
  module SDK
    module Types
      extend FFI::Library

      class DruckParameter < FFI::ManagedStruct
        layout :version,     :uint,
               :vorschau,    :uint,
               :ersteSeite,  :uint,
               :duplexDruck, :uint,
               :pdfName,     :string,
               :fussText,    :string,
               :ersteSeite,  :uint

        def self.release(ptr)
          Types.free_object(ptr)
        end
      end

      BearbeitungFlag = enum(
        :validiere, (1 << 1),
        :sende,     (1 << 2),
        :drucke,    (1 << 5)
      )

      ERIC_LOG_ERROR = 4
      ERIC_LOG_WARN  = 3
      ERIC_LOG_INFO  = 2
      ERIC_LOG_DEBUG = 1
      ERIC_LOG_TRACE = 0

      LOGGER_SEVERITY = {
        ERIC_LOG_ERROR => Logger::ERROR,
        ERIC_LOG_WARN  => Logger::WARN,
        ERIC_LOG_INFO  => Logger::INFO,
        ERIC_LOG_DEBUG => Logger::DEBUG,
        ERIC_LOG_TRACE => Logger::DEBUG
      }
    end
  end
end

module Liberic
  module SDK
    module Types
      extend FFI::Library

      class DruckParameter < FFI::Struct
        layout :version,     :uint, # Set version to 2
               :vorschau,    :uint,
               :ersteSeite,  :uint,
               :duplexDruck, :uint,
               :pdfName,     :pointer,
               :fussText,    :pointer,
               :ersteSeite,  :uint
      end

      class VerschluesselungsParameter < FFI::Struct
        layout :version,     :uint, # Set version to 2
               :zertifikatHandle, :uint,
               :pin,         :pointer,
               :abrufCode,   :pointer
      end

      class ZertifikatParameter < FFI::Struct
        layout :version,     :uint, # Set version to 1
               :name,        :pointer,
               :land,        :pointer, # "DE" (optional)
               :ort,         :pointer, # Prefixed with zip code, i.e. "D-10179 Berlin"
               :address,     :pointer, # Street and number
               :email,       :pointer, # (optional)
               :organization,:pointer,
               :unit,        :pointer,
               :description, :pointer
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

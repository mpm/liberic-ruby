module Liberic
  module SDK
    module Types
      extend FFI::Library

      class DruckParameter < FFI::Struct
        layout :version,     :uint, # Set version to 4
               :vorschau,    :uint,
               :duplexDruck, :uint,
               :pdfName,     :pointer,
               :fussText,    :pointer,
               :ersteSeite,  :uint
      end

      class VerschluesselungsParameter < FFI::Struct
        layout :version,     :uint, # Set version to 3
               :zertifikatHandle, :uint,
               :pin,         :pointer
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
        :validiere,                       (1 << 1),
        :sende,                           (1 << 2),
        :drucke,                          (1 << 5),
        :pruefe_hinweise,                 (1 << 7),
        :validiere_ohne_freigabedatum,    (1 << 8),
        :sende_auth,  ('00100110'.to_i(2)) # triggers all three: valiediere, sende and drucke
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

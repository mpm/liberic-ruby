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
    end
  end
end

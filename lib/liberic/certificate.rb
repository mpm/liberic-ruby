module Liberic
  # +Certificate+ encapsulates functionality regarding certificates (for signing).
  # An instance of Certificate is passed on to +EricBearbeiteVorgang()+ where necessary.
  class Certificate
    attr_reader :features, :handle

    # +cert_file+ path to a pfx file (Portal-Zertifikat)
    # +pin+ the pin for the certificate (if applicable, string)
    def initialize(cert_file, pin)
      @pin = pin
      ch = FFI::MemoryPointer.new(:uint32, 1)
      cert_feature_flag_pointer = FFI::MemoryPointer.new(:uint32, 1)

      Liberic::Helpers::Invocation.raise_on_error(
        Liberic::SDK::API.get_handle_to_certificate(ch, cert_feature_flag_pointer, cert_file)
      )

      @handle = ch.get_uint32(0)

      flags = cert_feature_flag_pointer.get_uint32(0)
      @features = PinFeatures.new(
        (flags & 0x00) != 0,
        (flags & 0x01) != 0,
        (flags & 0x02) != 0,
        (flags & 0x04) != 0,
        (flags & 0x10) != 0,
        (flags & 0x20) != 0,
        (flags & 0x40) != 0,
        (flags & 0x80) != 0
      )
    end

    # Returns the result of +EricHoleZertifikatEigenschaften()+
    # This will be XML describing fields and properties associated with the certificate.
    def properties
      Helpers::Invocation.with_result_buffer do |buffer_handle|
        SDK::API.hole_zertifikat_eigenschaften(@handle, @pin, buffer_handle)
      end
    end

    # Returns a +SDK::Types::VerschluesselungsParameter+ data structure that can be passed on to
    # Process.execute
    def encryption_params
      params = SDK::Types::VerschluesselungsParameter.new

      params[:version] = 3
      params[:zertifikatHandle] = @handle
      params[:pin] = FFI::MemoryPointer.from_string(@pin).address

      params
    end

    def release_handle!
      SDK::API.close_handle_to_certificate(@handle)
    end
  end

  PinFeatures = Struct.new(
    :no_pin,
    :requires_pin_for_signature,
    :requires_pin_for_decryption,
    :requires_pin_for_cert_decryption,
    :supports_pin_check,
    :supports_last_attempt_failed,
    :supports_pin_lock_on_next_fail,
    :supports_pin_is_locked
  )
end

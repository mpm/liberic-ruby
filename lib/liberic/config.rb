module Liberic
  class Config
    def initialize

    end

    private

    def convert_to_ruby(value)
      if value.to_i.to_s == value
        value.to_i
      elsif ['ja', 'yes'].include?(value.downcase)
        true
      elsif ['nein', 'no'].include?(value.downcase)
        false
      else
        value.force_encoding(SDK::Configuration::ENCODING).encode(Encoding::default_external)
      end
    end

    def convert_to_eric(value)
      if [true, false].include?(value)
        value ? 'ja' : 'nein'
      else
        value
      end.to_s.encode(SDK::Configuration::ENCODING)
    end

    def get(key)
      Helpers::Invocation.with_result_buffer(true) do |handle|
        SDK::API.einstellung_lesen(key, handle)
      end
    end

    def set(key, value)
      Helpers::Invocation.raise_on_error(SDK::API.einstellung_setzen(key, value))
      true
    end
  end
end

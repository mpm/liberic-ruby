module Liberic
  class InitializationError < StandardError
  end

  extend self

  def eric_home
    ERIC_HOME
  end

  def library_path
    suffix = if RUBY_PLATFORM =~ /linux/
      'so'
    elsif RUBY_PLATFORM =~ /darwin/
      'dylib'
    else
      'dll'
    end
    File.expand_path("libericapi.#{suffix}", ERIC_LIB_FOLDER)
  end

  ERIC_HOME = ENV['ERIC_HOME'] || raise(InitializationError.new('ERIC_HOME environment variable not found (set it to the path to the ERiC libraries)'))
  ERIC_LIB_FOLDER = File.expand_path('lib', ERIC_HOME)

  def check_eric_version!
    version_response = Response::Version.new(
      Helpers::Invocation.with_result_buffer do |handle|
        SDK::API::version(handle)
      end
    )

    eric_version = version_response.for_library('libericapi')
    if eric_version != REQUIRED_LIBERICAPI_VERSION
      raise InitializationError.new("ERiC #{REQUIRED_LIBERICAPI_VERSION} required, but #{eric_version} found.")
    end
  end
end

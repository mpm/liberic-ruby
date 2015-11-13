module Liberic
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

  ERIC_HOME = ENV['ERIC_HOME'] || raise('ERIC_HOME environment variable not found (set it to the path to the ERiC libraries)')
  ERIC_LIB_FOLDER = File.expand_path('lib', ERIC_HOME)
end

require 'ffi'
require 'nokogiri'
require 'liberic/version'
require 'liberic/boot'
require 'liberic/helpers'
require 'liberic/response'
require 'liberic/sdk'
require 'liberic/process'
require 'liberic/config'

module Liberic
  check_eric_version!

  def config
    @config ||= Config.new
  end
end

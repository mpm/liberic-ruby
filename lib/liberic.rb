require 'ffi'
require 'nokogiri'
require 'logger'
require 'liberic/version'
require 'liberic/boot'
require 'liberic/helpers'
require 'liberic/response'
require 'liberic/sdk'
require 'liberic/process'
require 'liberic/config'

module Liberic
  SDK::API::initialisiere(nil, nil)

  check_eric_version!

  def config
    @config ||= Config.new
  end
end

#!/usr/bin/env ruby

require "bundler/setup"
require "liberic"

tax_filing = File.read(File.expand_path('steuersatz.xml', File.dirname(__FILE__)))

submission = Liberic::Process.new(tax_filing, 'ESt_2011')

submission.check

result = submission.execute(action: :print_and_submit)
puts result

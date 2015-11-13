# Liberic

Liberic is a ruby wrapper for ERiC, a C library to interact with German
Tax Authority's ELSTER service.

This gem is at a very early stage and not able to do much useful stuff.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'liberic', git: 'https://github.com/mpm/liberic-ruby.git'
```

And then execute:

    $ bundle

Or install it yourself (not possible yet) as:

    $ gem install liberic

The ERiC library files are not distributed with this gem. They must be
obtained from the [ELSTER Downloads Page](https://www.elster.de/ssl/secure/eric.php).

Follow the installation instructions from the ERiC documentation.
After extracting the downloaded files, there should be a folder
containing

```
bin/
include/
lib/
```

subfolders.

Currently, the environment variable `ERIC_HOME` needs to be set to this
folder or the gem will not find the library files.

For example:

```sh
$ export ERIC_HOME=/opt/ERiC-22.3.4.0/Linux-x86_64
```

## Usage

The gem exposes an interface to the ERiC C native functions inside the
`Liberic::SDK::API` namespace.

Function namens have been converted from camel case and stripped of the
'Eric' prefix.

For example:

```c
EricSystemCheck();
```

becomes

```ruby
Liberic::SDK::API.system_check
```

in Ruby.

A more Ruby friendly encapsulation of the ERiC functionality is in the
making (check out Liberic::Process).

## Examples

The following code will load an example tax filing (from the SDK) to
validate it with ERiC.

```ruby
require 'liberic'

# Use a convenience wrapper that deals with creating a buffer for the
# native function's results. This will also raise a Ruby exception if
# the native function returns anything else then 0 (= OK).
version_info = Liberic::Helpers::Invocation.with_result_buffer do |handle|

  # Call ERiC function EricVersion()
  Liberic::SDK::API::version(handle)
end

# version info contains XML with all ERiC libraries and their versions.
puts version_info

# Read example file that declares income tax for 2011. Assumes you have extraced
# the 'Beispiel' folder that comes with the ERiC libraries.
tax_filing = File.read(File.expand_path('Beispiel/ericdemo-java/steuersatz.xml', Liberic.eric_home))

# Liberic::Process is a high level wrapper around ERiC's EricBearbeiteVorgang() function.
submission = Liberic::Process.new(tax_filing, 'ESt_2011')

# Check for validity of the XML schema
submission.check

# Submit tax filing for a dry run (validity of the fields will be checked).
result = submission.execute

# Will be empty if everything was ok. Otherwise, result contains XML with a list of offending fields.
# Try editing the example file to see this in action- for example change the year of birth to a future year, etc.
puts result
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpm/liberic. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


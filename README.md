# Liberic

Liberic is a ruby wrapper for ERiC, a C library to interact with German
Tax Authority's ELSTER service.

**WARNING:** This gem is at a very early stage and not able to do much useful stuff.

## Documentation

This README can only give a brief overview. You can look up the complete
[documentation on RubyDoc.info](http://www.rubydoc.info/github/mpm/liberic-ruby).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'liberic'
```

And then execute:

    $ bundle

Or install it yourself (not possible yet) as:

    $ gem install liberic

The ERiC library files are not distributed with this gem. They must be
obtained from the [ELSTER Downloads Page](https://www.elster.de/elsterweb/entwickler/infoseite/eric). (Requires your personal credentials which have to be requested from ELSTER).

Follow the installation instructions from the ERiC documentation.

After extracting the downloaded library files to a location of your choice, there should be a folder
containing at least three subfolders:

```
bin/
include/
lib/
```

Currently, the environment variable `ERIC_HOME_39` needs to be set to this
folder or the gem will not find the library files.

For example:

```sh
$ export ERIC_HOME_39=/opt/ERiC-39.3.2.0/Linux-x86_64
```

The gem will raise an `Liberic::InitializationError` if the environment variable is not set.
In a Rails project this can interfere with running rake (for example
when building the app in Docker). In this case, use `gem 'liberic', require: false` in your `Gemfile`.
And require the gem later in your Rails code (for example a model) by
calling `require 'liberic'`.

### Additional steps on OS X

The following OS X specific information dates back to the first version of this
library (from 2016). Might be outdated or incorrect by now.

On *Mac OS X* you need to process the libraries to fix the interal paths
(credits to @deviantbits):

```
libs=`ls $ERIC_HOME_27/lib/*.dylib`
plugins=`ls $ERIC_HOME_27/lib/plugins2/*.dylib`

for target in $libs
do
  for lib in $libs
  do
    install_name_tool -change "@rpath/"`basename $lib` "$ERIC_HOME_27/lib/"`basename $lib` $target
  done

  for plugin in $plugins
  do
    install_name_tool -change "@rpath/plugins2/"`basename $plugin` "$ERIC_HOME_27/lib/plugins2/"`basename $plugin` $target
  done
done

for target in $plugins
do
  for lib in $libs
  do
    install_name_tool -change "@rpath/"`basename $lib` "$ERIC_HOME_27/lib/"`basename $lib` $target
  done
done
```

Check your settings by running:

```sh
$ ls $ERIC_HOME_27/lib/libericapi.*
```
This should list you one file with an operating system dependend suffix.

## Usage

The gem exposes an interface to ERiC's native functions inside the
`Liberic::SDK::API` namespace.

Function names have been converted from camel case and stripped of the
'Eric' prefix, otherwise the original (German) names have been kept.

For example:

```c
EricSystemCheck();
```
is in Ruby:

```ruby
Liberic::SDK::API.system_check
```

A more Ruby friendly encapsulation of the ERiC functionality is in the
making (check out `Liberic::Process`).

## Examples

The following script will load an example tax filing (from the SDK) to
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

## Features

This gem is rather early stage. It does not implement all ERiC features
yet. It does support submitting various tax filings via
`Liberic::Process` which should be sufficient for the majority of use
cases. Dealing with certificates (necessary for retrieving the tax
assessment or cryptographically signing a tax filing) is possible, but
no Ruby style wrapper exists yet.

Please refer to `Liberic::SDK::API` and the official docs for this.

## Bugs

This library is used in production for submitting tax filings. Not all
of the methods implemented in `Liberic::SDK::API` have been tested
though, so the data types defined there might be wrong.

Please consider this if you encounter problems and are looking for bugs
in your code.

Pull requests, improvements and examples are welcome, we are all in this
together :)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpm/liberic. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


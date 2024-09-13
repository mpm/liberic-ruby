# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0]

Add support to sign a submission with a POZ (Portalzertifikat)

Usage:

```ruby
# Uses the example Einkommensteuer & Zertifikat that comes with the ERIC SDK
tax_filing = File.read(File.expand_path('Beispiel/ericdemo-java/ESt_2020.xml', Liberic.eric_home))
cert_path = File.expand_path('Beispiel/ericdemo-java/test-softidnr-pse.pfx', Liberic.eric_home)
cert = Liberic::Certificate.new(cert_path, '123456')

submission = Liberic::Process.new(tax_filing, 'ESt_2020')
result = submission.execute({action: :submit, encryption: cert.encryption_params})
cert.release_handle!
```

### Added

- Added `Liberic::Certificate` class

## [1.1.0]

Eric now requires a call to an initialization function. This happens
when the gem is required. However, this is possibly not thread safe
(no research was done on this).

In a single thread context, the gem should be backwards compatible.

Names of the error codes (see `Liberic::SDK::Fehlercodes`) have been
updated according to the constant names used in `eric_fehlercodes.h`
from the ERiC sources from ERIC 39.

So technically this update is not 100% backwards compatible. However, I
find a bump to 2.0.0 excessive for this release.

### Added

- Updated documentation and added a changelog.
- Added `Liberic::SDK::hole_zertifikat_eigenschaften`
- Added `Liberic::SDK::initialisiere` and `Liberic::SDK::beende`

### Changed

- Updated dependencies of this gem. Since it has been a couple of years
  since the last update, minimum required versions haven't been tested.
  The gem probably also works with Ruby 2.x and older versions of ffi
  and nokogiri.
- Updated API for ERIC 39 (2023).
  image that will render properly (although in English for all languages)

## [1.0.2] - Prior 2024

This gem was originally developed for a company that became later
wundertax. A [fork of the gem](https://github.com/wundertax/liberic-ruby)
was maintained by them for a while but has been archived in 2019.

Development of [the original version](https://github.com/mpm/liberic-ruby) of
this gem (where this changelog belongs to) was picked up by me in 2024
for a different project.

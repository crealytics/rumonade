# HISTORY

## v0.4.0 (Nov 11, 2012)

  - added scala-like extensions to Hash
  - See full list @ https://github.com/ms-ati/rumonade/compare/v0.3.0...v0.4.0

## v0.3.0 (Apr 29, 2012)

  - added Either#lift_to_a (and #lift)
  - See full list @ https://github.com/ms-ati/rumonade/compare/v0.2.2...v0.3.0

## v0.2.2 (Apr 26, 2012)

  - added Either#+ to allow combining validations
  - See full list @ https://github.com/ms-ati/rumonade/compare/v0.2.1...v0.2.2

## v0.2.1 (Oct 22, 2011)

  - fixed Option#map to disallow becoming None on a nil result
  - other fixes and documentation updates
  - See full list @ https://github.com/ms-ati/rumonade/compare/v0.2.0...v0.2.1

## v0.2.0 (Oct 18, 2011)

  - added a scala-like Either class w/ LeftProjection and RightProjection monads

## v0.1.2 (Oct 12, 2011)

  - progress towards Either class
  - changed documentation to yard from rdoc

## v0.1.1 (Sep 19, 2011)

  - added a first stab at documentation for Option
  - fixed certain errors with #map
  - added #select

## v0.1.0 (Sep 17, 2011)

  - Initial Feature Set
    - general implementation and testing of monadic laws based on `unit` and `bind`
    - scala-like Option class w/ Some & None
    - scala-like extensions to Array

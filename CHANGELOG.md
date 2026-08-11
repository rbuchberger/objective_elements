# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Will be released as 2.0.0.

### Changed

- **Breaking:** `required_ruby_version` is now `>= 3.0`, with no upper bound.
  See [ADR 0001](docs/adr/0001-ruby-version-support-policy.md) for the support
  policy and the April 2027 expiry of the 3.0 floor.
- All source files now declare `# frozen_string_literal: true`.
- `ShelfTag#initialize` calls `super`, so a ShelfTag now has a `nil` element and
  an empty `HTMLAttributes` rather than no attributes at all.

### Fixed

- `HTMLAttributes#to_s` no longer mutates the attribute hash. Previously an
  empty attribute gained an empty string on every render, so repeated calls
  accumulated trailing spaces.
- `HTMLAttributes#to_s`, `SingleTag#opening_tag`, and `DoubleTag#to_a` built
  their output by mutating string literals, which raised `FrozenError` under
  frozen string literals.
- `bin/console` required the gem's pre-rename name and could not start.

### Added

- GitHub Actions CI: rspec on Ruby 3.0, 3.2, 3.3, 3.4, and 4.0, plus a
  `ruby-head` leg that is allowed to fail, and rubocop on 3.4.
- Gemspec metadata URIs, and `rubygems_mfa_required`.
- `mise.toml`, pinning Ruby 3.4 for development.
- This changelog. Earlier entries are transcribed from the README's old
  "Changes" section.

### Removed

- `bundler`, `pry`, and `solargraph` as declared development dependencies, and
  `.solargraph.yml`. Install those locally instead.
- `Gemfile.lock`, which is now gitignored — one lockfile can't serve a Ruby
  3.0 through 4.0 matrix.

## [1.1.2] - 2020-01-16

### Changed

- Gemspec and dependency housekeeping. No functional changes.

## [1.1.1] - 2019-11-14

### Fixed

- Duplicate attribute keys passed at the same time no longer overwrite each
  other's values.

## [1.1.0] - 2019-02-08

### Added

- `ShelfTag`, for creating siblings without a parent element.

## [1.0.0] - 2018-10-23

### Changed

- **Breaking:** attributes syntax changed significantly. `.add_attributes`
  became `.attributes <<`; see the README's usage section.

[unreleased]: https://github.com/rbuchberger/objective_elements/compare/v1.1.2...HEAD
[1.1.2]: https://github.com/rbuchberger/objective_elements/compare/v1.1.1...v1.1.2
[1.1.1]: https://github.com/rbuchberger/objective_elements/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/rbuchberger/objective_elements/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/rbuchberger/objective_elements/releases/tag/v1.0.0

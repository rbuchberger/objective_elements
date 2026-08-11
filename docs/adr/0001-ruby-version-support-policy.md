# 1. Ruby version support policy

Date: 2026-08-11

## Status

Accepted. The Ruby 3.0 floor expires April 2027 — see "Consequences".

## Context

The gem sat dormant long enough that its tooling and its implicit Ruby support
window had both drifted. Reviving it meant answering a question that had never
been written down: which Rubies does this gem promise to work on?

Two failure modes were on the table. Setting the floor too high strands users on
distro-packaged Rubies they don't control. Setting an upper bound strands
everyone the moment a new Ruby ships — which is exactly the state
`jekyll_picture_tag` is in, uninstallable on Ruby 4.0 because of its own
`< 4.0` cap.

This gem is ~100 lines, has no runtime dependencies, and uses no recent syntax.
The cost of supporting an old Ruby is close to zero; the cost of an upper bound
is a broken install.

## Decision

`required_ruby_version = '>= 3.0'`, with no upper bound.

The rule behind that number: **support every non-EOL Ruby, plus EOL versions
still shipped in a supported Ubuntu LTS.**

| Ruby | Status (Aug 2026) | Ubuntu LTS            |
| ---- | ----------------- | --------------------- |
| 4.0  | supported         | —                     |
| 3.4  | supported         | —                     |
| 3.3  | supported         | 26.04                 |
| 3.2  | EOL 2026-03       | 24.04 (to Apr 2029)   |
| 3.0  | EOL 2024-04       | 22.04 (to Apr 2027)   |

No upper bound. A dependency-free library has nothing to break against a new
Ruby that a cap would protect against, and a cap guarantees breakage the day
that Ruby ships.

CI tests the full supported range — 3.0, 3.2, 3.3, 3.4, 4.0 — plus a
`continue-on-error` `ruby-head` leg for early warning. The 3.0 leg pins
`ubuntu-22.04`, because `setup-ruby` publishes no 3.0 build for newer images.
Rubocop runs once, on 3.4, matching the version `mise.toml` pins so local lint
and CI lint cannot disagree. No JRuby or TruffleRuby: no runtime dependencies
and no C extensions means nothing platform-specific to catch.

## Consequences

The floor is user-visible metadata, so raising it is a breaking change. That is
what makes this release 2.0.0.

Ruby 3.0 is here **only** because Ubuntu 22.04 ships it. **Revisit in April
2027**, when 22.04 leaves standard support: at that point the floor should rise
to 3.2 (Ubuntu 24.04's Ruby, supported until April 2029) in the next major
version.

Applying the rule mechanically means the floor moves on Ubuntu LTS's schedule
rather than upstream Ruby's, which is slower than most gems — deliberately.
That is the point: the users least able to upgrade Ruby are the ones on a
distro-packaged one.

Out of scope, and tracked separately in that repo: `jekyll_picture_tag`'s own
`< 4.0` cap, and its `objective_elements ~> 1.1` constraint. Both need their own
support decision.

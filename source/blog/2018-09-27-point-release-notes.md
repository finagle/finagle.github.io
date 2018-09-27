---
layout: post
title: ⛱️ September 2018 Point Release Notes 🐚 — Version 18.9.1
published: true
post_author:
  display_name: Ryan O'Neill
  twitter: ryanoneill
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

September is beach season here in the Bay Area, and it looks like our release earlier
this month got caught in a wash cycle. So, we've made a point release.

_See below for details on the `util-slf4j-api` dependency fix for the reason
why we decided to do a point release._

[Finagle 18.9.1](https://github.com/twitter/finagle/releases/tag/finagle-18.9.1),
[Finatra 18.9.1](https://github.com/twitter/finatra/releases/tag/finatra-18.9.1),
[Scrooge 18.9.1](https://github.com/twitter/scrooge/releases/tag/scrooge-18.9.1),
[TwitterServer 18.9.1](https://github.com/twitter/twitter-server/releases/tag/twitter-server-18.9.1),
and [Util 18.9.1](https://github.com/twitter/util/releases/tag/util-18.9.1).

### [Finagle](https://github.com/twitter/finagle/) ###

#### Breaking API Changes
* finagle-base-http: `DefaultHeaderMap` now validates HTTP Header names and
  values in `add` and `set`. `addUnsafe` and `setUnsafe` have been created to
  allow adding and setting headers without validation. [3454f95d](https://github.com/twitter/finagle/commit/3454f95dd3623b44e8de725fed7e29d4b84da45d)

* finagle-core: Remove slow host detection from `ThresholdFailureDetector`.
  [c05f5832](https://github.com/twitter/finagle/commit/c05f583224d570f92afe0b1520e3769b80b0e61b)

#### Runtime Behavior Changes

* finagle-core: When Finagle would exhaust a retry budget with an exception that was
  not a `FailureFlags`, previously it would wrap that exception with a non-retryable
  failure. This lead to surprising behavior for users. Those exceptions will no longer
  be wrapped. [4ece3d2a](https://github.com/twitter/finagle/commit/4ece3d2aa5e893ad11969c93e981294d6a6ed754)

* finagle-http: The finagle HTTP clients and servers now consider a `Retry-After: 0`
  header to be a retryable nack. Servers will set this header when the response is
  a retryable failure, and clients will interpret responses with this header as a
  Failure.RetryableNackFailure. [3c3fedc6](https://github.com/twitter/finagle/commit/3c3fedc620cd010bfe524b27c54d7c91279a2200)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed

* http/thrift: Update Library registry route information to include controller class name.
  [ffb644e5](https://github.com/twitter/finatra/commit/ffb644e5612b81602f7c653e69a8bf99b5c3eaa3)

### [Scrooge](https://github.com/twitter/scrooge/) ###

* scrooge: Finally remove maven.twttr.com as a dependency or plugin repository. With
  the update to a more recent libthrift dependency, this should no longer be necessary.
  [44db8e16](https://github.com/twitter/scrooge/commit/44db8e16d0afbc90018a968f268d209068bf2bfc)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

No Changes

### [Util](https://github.com/twitter/util/) ###

#### Breaking API Changes

* util-core: c.t.io.Writer now extends c.t.util.Closable. c.t.io.Writer.ClosableWriter
  is no longer exist. [9cc7025c](https://github.com/twitter/util/commit/9cc7025c52f8d52acc0ccc7f3f713103bf8fcd6a)

#### Bug Fixes

* util-slf4j-api: Moved slf4j-simple dependency to be a 'test' dependency, instead of a
  compile dependency, which was inaccurate. [3d6d7457](https://github.com/twitter/util/commit/3d6d7457d34055a9e9c86ffd112cc477fd557e0f)

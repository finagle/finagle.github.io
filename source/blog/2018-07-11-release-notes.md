---
layout: post
title: ☀️ July 2018 Release Notes - Version 18.7.0
published: true
post_author:
  display_name: Daniel Schobel
  twitter: dschobel
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Hot off the presses, the July releases are here!

[Finagle 18.7.0](https://github.com/twitter/finagle/releases/tag/finagle-18.7.0),
[Finatra 18.7.0](https://github.com/twitter/finatra/releases/tag/finatra-18.7.0),
[Scrooge 18.7.0](https://github.com/twitter/scrooge/releases/tag/scrooge-18.7.0),
[TwitterServer 18.7.0](https://github.com/twitter/twitter-server/releases/tag/twitter-server-18.7.0),
and [Util 18.7.0](https://github.com/twitter/util/releases/tag/util-18.7.0).

### [Finagle](https://github.com/twitter/finagle/) ###

Runtime Behavior Changes:

  * finagle-core: Server-side rejections from `c.t.f.filter.RequestSempahoreFilter.module` are now
captured by `c.t.f.service.StatsFilter`. They will roll up under `"/failures"`,
`"/failures/rejected"`, and `"/failures/restartable"` in stats. [3b755c8a](https://github.com/twitter/finagle/commit/3b755c8a)

  * finagle-core: `c.t.f.tracing.Trace.tracers` now returns only distinct tracers stored in
the local context (returned all tracers before). [b96bb137](https://github.com/twitter/finagle/commit/b96bb137)

  * finagle-http: HTTP param decoding is no longer truncated to 1024 params. [24662bea](https://github.com/twitter/finagle/commit/24662bea)
  
  * finagle-mux: When mux propagates an interrupt started by `BackupRequestFilter` over the
network, the `FailureFlags.Ignorable` status is propagated with it. [fe8c6496](https://github.com/twitter/finagle/commit/fe8c6496)

New Features:

  * finagle-core: There is now an implicit instance for Finagle's default timer:
`DefaultTimer.Implicit`. [64963bd8](https://github.com/twitter/finagle/commit/64963bd8)

  * finagle-core: Introduce new command-line flag `c.t.f.tracing.enabled` to entirely
disable/enable tracing for a given process (default: true). [5a5ceb63](https://github.com/twitter/finagle/commit/5a5ceb63)

  * finagle-mysql: `com.twitter.util.Time` can now be used with
`PreparedStatements` without converting the `ctu.Time` to a `java.sql.Timestamp`. [bbca48c7](https://github.com/twitter/finagle/commit/bbca48c7)

  * finagle-stats: Adds a lint rule to detect when metrics with colliding names are used. [26a2c3bd](https://github.com/twitter/finagle/commit/26a2c3bd)

Breaking API Changes:

  * finagle-core: `c.t.f.dispatch.ClientDispatcher.wrapWriteException` has been turned from a
partial function instance into a static total function. [9a3c9070](https://github.com/twitter/finagle/commit/9a3c9070)

  * finagle-mux: `ClientDiscardedRequestException` now extends `FailureFlags` and is no longer
a case class. [fe8c6496](https://github.com/twitter/finagle/commit/fe8c6496)

### [Finatra](https://github.com/twitter/finatra/) ###

Added:

* inject-utils: Add 'toLoggable' implicit from `Array[Byte]` to `String`. [0eece86a](https://github.com/twitter/finatra/commit/0eece86a)

Fixed:

* finatra-http: Fix infinite loop introduced by [8521d980](https://github.com/twitter/finatra/commit/8521d980). Fix underlying issue of the
`ResponseBuilder` requiring a stored `RouteInfo` for classifying exceptions for stating. [57a02570](https://github.com/twitter/finatra/commit/57a02570)

* finatra-http: Fix `FailureExceptionMapper` handling of wrapped exceptions. Unwrap cause for all
`c.t.finagle.Failure` exceptions, regardless of flags and add a try-catch to ExceptionManager
to remap exceptions thrown by `ExceptionMappers`. [8521d980](https://github.com/twitter/finatra/commit/8521d980)

### [Util](https://github.com/twitter/util/) ###

API Changes:

  * util-app: util-core: `Local.Context` used to be a type alias for `Array[Option[_]]`, now it is
a new key-value liked structure. [faaf0f2f](https://github.com/twitter/util/commit/faaf0f2f)

### [Scrooge](https://github.com/twitter/scrooge/) ###

  * scrooge-adaptive: Turn scrooge-adaptive on as the default in `ScroogeRunner`. [633e0f2668d](https://github.com/twitter/scrooge/commit/633e0f2668d92404beca77fa5d3c8d1d52181756)

### Changelogs ###

 * [Finagle 18.7.0][finagle]
 * [Util 18.7.0][util]
 * [Scrooge 18.7.0][scrooge]
 * [TwitterServer 18.7.0][twitterserver]
 * [Finatra 18.7.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-18.7.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-18.7.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-18.7.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-18.7.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-18.7.0/CHANGELOG.md

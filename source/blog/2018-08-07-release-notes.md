---
layout: post
title: 🌫 August 2018 Release Notes — Version 18.8.0
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

[Fogust](https://twitter.com/KarlTheFog/status/1024685092629868545) is upon us
and brings the August releases.

[Finagle 18.8.0](https://github.com/twitter/finagle/releases/tag/finagle-18.8.0),
[Finatra 18.8.0](https://github.com/twitter/finatra/releases/tag/finatra-18.8.0),
[Scrooge 18.8.0](https://github.com/twitter/scrooge/releases/tag/scrooge-18.8.0),
[TwitterServer 18.8.0](https://github.com/twitter/twitter-server/releases/tag/twitter-server-18.8.0),
and [Util 18.8.0](https://github.com/twitter/util/releases/tag/util-18.8.0).

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

  * finagle-core: Introducing the new `c.t.f.tracing.Tracing` API for more efficient tracing
    (dramatically reduces the number of context lookups; see scaladoc for `c.t.f.tracing.Trace`).
    [547cd864](https://github.com/twitter/finagle/commit/547cd86465109e6777d2afb98a7560d6a053b7b4)

  * finagle-core: `c.t.f.tracing.Trace` facade API now provides forwarding `record` methods for
    all kinds of annotations and is a preffered way of recording traces. [50c00d88](https://github.com/twitter/finagle/commit/50c00d8847e0e5f3ade029ee3a51b5e2e795f115)

  * finagle-thriftmux: Promote the push-based ThriftMux implementation out of experimental
    status. [eedd1fd8](https://github.com/twitter/finagle/commit/eedd1fd890da85c6efcdc0ff597e22055967d811)

#### Breaking API Changes

  * finagle-base-http: `c.t.f.http.cookie.exp.supportSameSiteCodec` has been moved out of the
    exp package to `c.t.f.http.cookie.supportSameSiteCodec`. [5e5ea390](https://github.com/twitter/finagle/commit/5e5ea39079f0445fc8823f5947ea2e504574c564)

  * finagle-core: `c.t.f.tracing.Trace.record(Record)` now accepts the record argument by
    value (previously by name). [33841d21](https://github.com/twitter/finagle/commit/33841d214af7506750d6106fdeb0d95fbd95cc42)

  * finagle-mysql: `c.t.f.mysql.CanBeParameter`'s implicit conversions `timestampCanBeParameter`,
    `sqlDateCanBeParameter`, and `javaDateCanBeParameter` have been consolidated into a single
    implicit, `dateCanBeParameter`. [b486772d](https://github.com/twitter/finagle/commit/b486772d4a9471a33b151ae4f5bf8a05bb04fc30)

#### Bug Fixes

  * finagle-http2: Fixed a race condition caused by `c.t.f.http.transport.StreamTransports` being
    closed, but that status not being reflected right away, causing a second request to fail.
    [68f1035f](https://github.com/twitter/finagle/commit/68f1035fabd0a644c51b21a740e693fe2f518c20)

#### Runtime Behavior Changes

  * finagle-core: `c.t.f.tracing.Trace` API is no longer guarding `Trace.record` calls behind
    `Trace.isActivelyTracing`. Add `Trace.isActivelyTracing` guards on the call sites if
    materializing tracing annotations is a performance concern.  [33841d21](https://github.com/twitter/finagle/commit/33841d214af7506750d6106fdeb0d95fbd95cc42)

  * finagle-mysql: Clients will now issue a ROLLBACK each time a service is checked back
    into the connection pool. This can be disabled via `Mysql.Client.withNoRollback`.
    [e3221597](https://github.com/twitter/finagle/commit/e3221597377dafa6dfc7739b644d05622fdef923)

  * finagle-thriftmux: The push-based server muxer is now the default. In both synthetic tests
    and production it has shown signifcant performance benefits and is simpler to maintain.
    [735a6bae](https://github.com/twitter/finagle/commit/735a6bae3f8352b569ff153ec47d97a54914eee2)

#### Deprecations

  * finagle-mux: The pull based mux implementation, `c.t.f.Mux`, has been deprecated in favor of
    the push-based mux implementation, `c.t.f.pushsession.MuxPush`. [735a6bae](https://github.com/twitter/finagle/commit/735a6bae3f8352b569ff153ec47d97a54914eee2)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed

* finatra-http: (BREAKING API CHANGE) Typical TLS Configuration for an HTTPS server has been moved
  into a trait, `c.t.finatra.http.Tls` which also defines the relevant flags (and overridable
  defaults) for specifying the SSL cert and key paths. Users can choose to mix this trait into their
  `c.t.finatra.http.HttpServer` classes in order to specify an HTTPS server. Users who wish to maintain
  the current HTTPS functionality SHOULD mix in the Tls trait to their HttpServer: e.g.,
  ```
  class FooService extends HttpServer with Tls {
    ...
  }
  ```
  Additionally, TLS transport configuration for the underlying Finagle `c.t.finagle.Http.Server` is
  no longer done by default when creating and running an HTTPS server. This is to allow for more
  flexible configuration on the underlying `c.t.finagle.Http.Server` when setting up TLS. Thus it is
  recommended that users ensure to either mix in the provided Tls trait or provide the correct
  `c.t.finagle.Http.Server` transport configuration via the `configureHttpsServer` method.
  [3c19b2df](https://github.com/twitter/finatra/commit/3c19b2df303a30fda254822dc97cb2372d2220b3)

* finatra-http: Rename `defaultFinatraHttpPort` to `defaultHttpPort`. [6fe4a3bf](https://github.com/twitter/finatra/commit/6fe4a3bfb540f74b89ceedd17fcc27686fa42881)

* finatra-utils: Remove deprecated `c.t.f.utils.Handler`. [1088ca4b](https://github.com/twitter/finatra/commit/1088ca4bf3891130694f680a4303f1f64e019182)

### [Util](https://github.com/twitter/util/) ###

#### Bug Fixes

  * util-core: Fixed an issue with `Future.joinWith` where it waits for
    completion of both futures even if one has failed. This also affects
    the `join` method, which is implemented in terms of `joinWith`. [9b598f3f](https://github.com/twitter/util/commit/9b598f3f7db2d1e3ef81deb6a223dc7872cb7d52)

### [TwitterServer](https://github.com/twitter/twitter-server/) ###

#### New Features

  * Add `onExit` lifecycle callback to `c.t.server.Hook` (which is now an abstract class) to allow
    implemented hooks to execute functions in the `App#onExit` lifecycle phase. Note:
    `c.t.server.Hook#premain` now has a default implementation and requires the `override` modifier.
    [06836d39](https://github.com/twitter/twitter-server//commit/06836d399d8f6596fe001b64597d421633bfb0a4)

### [Scrooge](https://github.com/twitter/scrooge/) ###

  * scrooge-core: Add an interface for Scala generated Enum objects. [c27d13ef](https://github.com/twitter/scrooge/commit/c27d13efaa450c012a8e9a316640c9951c2e907d)

  * scrooge-core: Trait `c.t.scrooge.ThriftService` is now `c.t.finagle.thrift.ThriftServiceMarker`.
    Scrooge generated service objects now all inherit from `c.t.finagle.thrift.ThriftService`. Also,
    the `AsClosableMethodName` string was formerly part of `c.t.finagle.thrift.ThriftService`, but
    now is defined in the c.t.scrooge package object.
    [125e955e](https://github.com/twitter/scrooge/commit/125e955e0c35c4e30a60d217a92eedb42ee22070)

  * scrooge-generator: Thrift service objects now contain `unsafeBuildFromMethods`, which constructs
    a `ReqRepServicePerEndpoint` from a map of
    `ThriftMethod -> ThriftMethod.ReqRepServicePerEndpointServiceType`. It is unsafe because the
    types are not checked upon service construction, only when a request is attempted.
    [125e955e](https://github.com/twitter/scrooge/commit/125e955e0c35c4e30a60d217a92eedb42ee22070)

### Changelogs ###

 * [Finagle 18.8.0][finagle]
 * [Util 18.8.0][util]
 * [Scrooge 18.8.0][scrooge]
 * [TwitterServer 18.8.0][twitterserver]
 * [Finatra 18.8.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-18.8.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-18.8.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-18.8.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-18.8.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-18.8.0/CHANGELOG.md

---
layout: post
title: 🏮 February 2018 Release Notes - Version 18.2.0
published: true
post_author:
  display_name: Yufan Gong
  twitter: @yufangong
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Happy Lunar New Year! The February release is here.

[Finagle 18.2.0][finagle], [Finatra 18.2.0][finatra], [Scrooge 18.2.0][scrooge], [TwitterServer 18.2.0][twitterserver], and [Util 18.2.0][util].

### [Finagle](https://github.com/twitter/finagle/) ###

New Features

  * finagle-core: Add orElse to allow composition of `FailureAccrualPolicy`s.
    [8c1e718e](https://github.com/twitter/finagle/commit/8c1e718e9b724afbe07e7ecf995eb72b7f6650d1)

  * finagle-core: `c.t.f.http.MethodBuilder` now exposes a method `newService` without a
    `methodName` to create a client. `c.t.f.thriftmux.MethodBuilder` now exposes a
    method `servicePerEndpoint` without a `methodName` to create a client. [d8e010d6](https://github.com/twitter/finagle/commit/d8e010d6f0d4c0bc64e5628b4832ca148212e8b8)

  * finagle-thriftmux: Expose the underlying configured client `label` in the
    `c.t.finagle.thriftmux.MethodBuilder`. [653e2696](https://github.com/twitter/finagle/commit/653e2696b424adc27c5fe67d0479cb896b31fdbd)

Bug Fixes

  * finagle-http2: http2 servers no longer leak ping bodies. [02841dfd](https://github.com/twitter/finagle/commit/02841dfd3022470f0a0c7b5866cfa1c2efcbc61c)

Deprecations

  * finagle-core: `c.t.finagle.ssl.Ssl` and related classes have been
    deprecated. They were replaced as the primary way of using SSL/TLS
    within Finagle in release 6.44.0 (April 2017). Please migrate to using
    `c.t.f.ssl.client.SslClientEngineFactory` or
    `c.t.f.ssl.server.SslServerEngineFactory` instead. [0b8a2890](https://github.com/twitter/finagle/commit/0b8a2890a175d7ab5983683953c25db6038a0698)

Breaking API Changes

  * finagle-base-http: `c.t.f.h.codec.HttpCodec` has been moved to the `finagle-http`
    project. [350953ae](https://github.com/twitter/finagle/commit/350953aee0c6cae3a550cdf34bc1a30c4bfc5beb)

  * finagle base-http: `c.t.f.h.Request.multipart` has been removed.
    Use `c.t.f.h.exp.MultipartDecoder` instead. [b9d71e36](https://github.com/twitter/finagle/commit/b9d71e36b64eaced148a5da48eb200b0a5725c88)

  * finagle-http: Split the toggle 'c.t.f.h.UseH2C' into a client-side toggle and a
    server-side toggle, named 'c.t.f.h.UseH2CClients', and 'c.t.f.h.UseH2CServers',
    respectively.  [0d960398](https://github.com/twitter/finagle/commit/0d960398d63e362c0296798a59a6c7854ba1ac70)

Runtime Behavior Changes

  * finagle-core: Finagle clients with retry budgets or backoffs should no
    longer have infinite hash codes. [88e7bea9](https://github.com/twitter/finagle/commit/88e7bea9bf29bc5fed3207782bf82b25bf869c4a)


### [Finatra](https://github.com/twitter/finatra/) ###

Added

* inject-thrift-client: Add methods to `c.t.inject.thrift.filters.ThriftClientFilterChain` to allow
  Tunable timeouts and request timeouts. [72664be4](https://github.com/twitter/finatra/commit/72664be4439da4425dfe63fa325f4c1ebbc5bf4b)

* inject-thrift-client: Add `idempotent` and `nonIdempotent` methods to
  `c.t.inject.thrift.ThriftMethodBuilder`, which can be used to configure retries and the sending of
  backup requests. [7868964d](https://github.com/twitter/finatra/commit/7868964d223656f4e2b2ab738c835f45e30add76)

* inject-thrift-client: Add `c.t.inject.thrift.modules.ServicePerEndpointModule` for
  building ThriftMux clients using the `thriftmux.MethodBuilder`. [42ef3bcc](https://github.com/twitter/finatra/commit/42ef3bcc1ad8fcda877245554ceb4c3ffcd348c8)

Changed

* inject-thrift: Update `c.t.inject.thrift.PossibleRetryable` to specify a ResponseClassifier
  and update usages in inject-thrift-client to use it. [582d46bc](https://github.com/twitter/finatra/commit/582d46bc3d79a12789c208974ab197c02748615b)

* inject-thrift-client: Un-deprecate `c.t.inject.thrift.modules.ThriftClientModule`
  and update for parity with `ServicePerEndpointModule` in regards to ThriftMux
  client configuration. Update documentation. Rename `ServicePerEndpointModule` to
  the more descriptive and consistently named `ThriftMethodBuilderClientModule`.
  [c4dc773e](https://github.com/twitter/finatra/commit/c4dc773e401d5e8d4d2bd3d7259ee86d47020d32)

### [Scrooge](https://github.com/twitter/scrooge/) ###

- scrooge-generator: Add `asClosable` method to `ServicePerEndpoint` and
  `ReqRepServicePerEndpoint` interfaces as well. [597864ac](https://github.com/twitter/scrooge/commit/597864aca641419b43cb4c32201a063439c5991c)

- scrooge-generator: Remove unused `functionToService` and `serviceToFunction`
  methods along with `ServiceType` and `ReqRepServiceType` type aliases in
  order to simplify code generation.

  NOTE: This functionality can be manually replicated by users if/when needed
  to convert between a Function1 and a Finagle `Service`. [2d25eb25](https://github.com/twitter/scrooge/commit/2d25eb25fc91d7ad3688377dd86330a42799c8c3)

- scrooge-generator: Scala generated client now has a asClosable method returns c.t.u.Closable,
  client now can be closed by calling `client.asClosable.close`. Note that `asClosable` won't be
  generated if it is also defined by the user. [1fa4f0c6](https://github.com/twitter/scrooge/commit/1fa4f0c6df334b1bcca71fe53683ee15f4aa5cc5)

- scrooge-generator: Renamed subclasses of `com.twitter.scrooge.RichResponse`:
  `ProtocolExceptionResponse`, `SuccessfulResponse`, and `ThriftExceptionResponse`.
  These case classes are for representing different response types and should be only
  used by the generated code. [2194e77d](https://github.com/twitter/scrooge/commit/2194e77d733d464d835073a5ca03fb368d59cbcf)


### [TwitterServer](https://github.com/twitter/twitter-server/) ###

Dependencies

  * Removed 'finagle-zipkin-core' as a depdendency since there was no
    code in twitter-server which used it. [9f5b8858](https://github.com/twitter/twitter-server/commit/9f5b885852e1afee978af55ce3aa74231d27a8f7)


### [Util](https://github.com/twitter/util/) ###

New Features:

  * util-core: Added implicit conversion for percentage specified as "x.percent"
    to a fractional Double in `c.t.conversions.percent`. [e573d263](https://github.com/twitter/util/commit/e573d263788271d3ab6094361f7c2fe4528d66a2)

  * util-tunable: Add deserializer for `c.t.u.StorageUnit` to JsonTunableMapper
    [d320545a](https://github.com/twitter/util/commit/d320545a8537d59050a7db988d54b589dcdf701c)

Runtime Behavior Changes:

  * util-app: When `c.t.a.App.exitOnError` is called, it now gives `close`
    an opportunity to clean up resources before exiting with an error.
    [aa32eb16](https://github.com/twitter/util/commit/aa32eb16f03635dbdc9540366a880d648aa58949)

### Changelogs ###

* [Finagle 18.2.0][finagle]
* [Util 18.2.0][util]
* [Scrooge 18.2.0][scrooge]
* [TwitterServer 18.2.0][twitterserver]
* [Finatra 18.2.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-18.2.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-18.2.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-18.2.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-18.2.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-18.2.0/CHANGELOG.md

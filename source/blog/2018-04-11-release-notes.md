---
layout: post
title: April 2018 Release Notes - Version 18.4.0
published: true
post_author:
  display_name: Bryce Anderson
  twitter: BryceAnderson22
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Our April releases have arrived!

[Finagle 18.4.0][finagle], [Finatra 18.4.0][finatra], [Scrooge 18.4.0][scrooge], [TwitterServer 18.4.0][twitterserver], and [Util 18.4.0][util].

### [Finagle](https://github.com/twitter/finagle/) ###

New Features

  * finagle-core: `c.t.f.filter.NackAdmissionFilter` can now be disabled via a `with`-method.
    `$Protocol.client.withAdmissionControl.noNackAdmissionControl` [323a20f4](https://github.com/twitter/finagle/commit/323a20f406d44f009df7cf39aa09f0fadcb1b8c5)

  * finagle-mysql: Exceptions now include the SQL that was being executed when possible.
    [5a54f45d](https://github.com/twitter/finagle/commit/5a54f45da4b78f22ccc001164f7c3df5314b34ce)

  * finagle-mysql: Address `PreparedStatement` usability from Java via
    `PreparedStatement.asJava()`. Through this, you can use the API with
    varargs and Java 8 lambdas. [c5bd6b97](https://github.com/twitter/finagle/commit/c5bd6b975657782607ad33b73ea414661a54f544)

  * finagle-mysql: Added support for `Option`\s to `Parameter` implicits. This
    allows for the natural represention of nullable columns with an `Option`
    where a `None` is treated as a `null`. [48f688d1](https://github.com/twitter/finagle/commit/48f688d1b52ed51499eb3c693a4fe253a5b67100)

  * finagle-netty4: Add 'tls/connections' gauge for Finagle on Netty 4 which tracks the number
    of open SSL/TLS connections per Finagle client or server.
    [911a01ce](https://github.com/twitter/finagle/commit/911a01cee08852f47385ac7b9d709cf3fc5422a9)

  * finagle-redis: Support has been added for a number of new cluster commands
    introduced in Redis 3.0.0. [86b151bf](https://github.com/twitter/finagle/commit/86b151bf641534304c9c9102d93e1e8e3ea9348a)

Bug Fixes

  * finagle-mysql: Fix handling of interrupts during transactions. [1b9111eb](https://github.com/twitter/finagle/commit/1b9111eb3e8576c41977b05447a3f17ef1c1a5f9)

Breaking API Changes

  * finagle-core: `c.t.f.ssl.client.HostnameVerifier` has been removed since it was using
    `sun.security.util.HostnameChecker` which is no longer accessible in JDK 9.
    [1313d9ba](https://github.com/twitter/finagle/commit/1313d9ba77b35da0a9a6fce3599dfc7c4c5e137d)

  * finagle-thrift: Upgraded libthrift to 0.10.0, `c.t.f.thrift.Protocols.TFinagleBinaryProtocol`
    constructor now takes `stringLengthLimit` and `containerLengthLimit`, `NO_LENGTH_LIMIT` value
    changed from 0 to -1. [61c7a711](https://github.com/twitter/finagle/commit/61c7a71182866250e53f9731c46f31dde28d464c)

  * finagle-thrift: Move "stateless" methods in `c.t.finagle.thrift.ThriftRichClient`
    to `c.t.finagle.thrift.ThriftClient`. Then mix the `ThriftClient` trait into the
    ThriftMux and Thrift Client companions to make it clearer that these stateless methods
    are not affected by the changing state of the configured client instance but are instead
    simply utility methods which convert or wrap the incoming argument. [7a175a98](https://github.com/twitter/finagle/commit/7a175a9875cb3f897a17f18e6dcb6dfb0da1974a)

  * finagle-base-http: Removed deprecated `c.t.f.Cookie.value_=`; use `c.t.f.Cookie.value`
    instead. [4bdd261b](https://github.com/twitter/finagle/commit/4bdd261b4249bc59547f31310b97505e144118d5)

  * finagle-base-http: Removed deprecated `c.t.f.Cookie.domain_=`; use `c.t.f.Cookie.domain`
    instead. [4bdd261b](https://github.com/twitter/finagle/commit/4bdd261b4249bc59547f31310b97505e144118d5)

  * finagle-base-http: Removed deprecated `c.t.f.Cookie.path_=`; use `c.t.f.Cookie.path`
    instead. [4bdd261b](https://github.com/twitter/finagle/commit/4bdd261b4249bc59547f31310b97505e144118d5)

Runtime Behavior Changes

  * finagle-core: Add minimum request threshold for `successRateWithinDuration` failure accrual.
    [b6caf3dd](https://github.com/twitter/finagle/commit/b6caf3ddd0edd92541263d74950f71684f7fa955)

  * finagle-core: `c.t.f.filter.NackAdmissionFilter` no longer takes effect when
    the client's request rate is too low to accurately update the EMA value or
    drop requests. [387d87d4](https://github.com/twitter/finagle/commit/387d87d45d7cd334c121ba43b8d6a43f3d97f8e4)

  * finagle-core: SSL/TLS client hostname verification is no longer performed by
    `c.t.f.ssl.client.HostnameVerifier`. The same underlying library
    `sun.security.util.HostnameChecker` is used to perform the hostname verification.
    However it now occurs before the SSL/TLS handshake has been completed, and the
    exception on failure has changes from a `c.t.f.SslHostVerificationException` to a
    `javax.net.ssl.CertificateException`. [1313d9ba](https://github.com/twitter/finagle/commit/1313d9ba77b35da0a9a6fce3599dfc7c4c5e137d)

  * finagle-core: Closing `c.t.f.NullServer` is now a no-op. [36aac62c](https://github.com/twitter/finagle/commit/36aac62c70b50e4de0f0c2598c7783d8e64b8bd4)

  * finagle-netty4: Netty ByteBuf leak tracking is enabled by default. [24690b13](https://github.com/twitter/finagle/commit/24690b137dc147e436fee42807502d1c24189621)

Deprecations

  * finagle-thrift: System property "-Dorg.apache.thrift.readLength" is deprecated. Use
    constructors to set read length limit for TBinaryProtocol.Factory and TCompactProtocol.Factory.
    [61c7a711](https://github.com/twitter/finagle/commit/61c7a71182866250e53f9731c46f31dde28d464c)


### [Finatra](https://github.com/twitter/finatra/) ###

Added

* finatra-http: Added the ability for requests to have a maximum forward depth to
  `c.t.finatra.http.routing.HttpRouter`, which prevents requests from being forwarded
  an infinite number of times. By default the maximum forward depth is 5.
  [cb236294](https://github.com/twitter/finatra/commit/cb2362943963759967bf233d828c1c61835475f5)

* inject-thrift-client: Update `configureServicePerEndpoint` and
  `configureMethodBuilder` in `ThriftMethodBuilderClientModule` to also pass a
  `c.t.inject.Injector` instance which allows users to use bound instances from
  the object graph when providing further `thriftmux.MethodBuilder` or
  `ThriftMethodBuilderFactory` configuration.
  [ee16c1c6](https://github.com/twitter/finatra/commit/ee16c1c655af6bc061202f0bf7b190d0756e9143)

* inject-thrift-client: Update `configureThriftMuxClient` in `ThriftClientModuleTrait` to
  also pass a `c.t.inject.Injector` instance which allows users to use bound instances
  from the object graph when providing further `ThriftMux.client` configuration.
  [e3047fe3](https://github.com/twitter/finatra/commit/e3047fe379bc7c9636517717ce462aea16aec6b5)

* inject-server: Capture errors on close of the underlying TwitterServer. The embedded
  testing utilities can now capture and report on an exception that occurs during close
  of the underlying TwitterServer. `EmbeddedTwitterServer#assertCleanShutdown` inspects
  for any Throwable captured from closing the underlying server which it will then throw.
  [0e304bbc](https://github.com/twitter/finatra/commit/0e304bbc14980c7d1f0c9c74ab368e56acdb5566)

* finatra-http: Created a new API into `c.t.f.h.response.StreamingResponse` which permits passing
  a `transformer` which is an `AsynStream[T] => AsyncStream[(U, Buf)]` for serialization purposes,
  as well as two callbacks -- `onDisconnect`, called when the stream is disconnected, and `onWrite`,
  which is a `respond` side-effecting callback to every individual write to the stream.
  [ab44378c](https://github.com/twitter/finatra/commit/ab44378c426419e53c639bb6a2c29ce146f01bbe)

Changed

* inject-app: Update and improve the test `#bind[T]` DSL. The testing `#bind[T]` DSL is lacking in
  its ability to be used from Java and we would like to revise the API to be more expressive such
  that it also includes binding from a Type to a Type. Due to wanting to also support the ability
  to bind a Type to a Type, the DSL has been re-worked to more closely match the actual Guice
  binding DSL.

  For Scala users the `#bind[T]` DSL now looks as follows:

  ```
    bind[T].to[U <: T]
    bind[T].to[Class[U <: T]]
    bind[T].toInstance(T)

    bind[T].annotatedWith[Ann].to[U <: T]
    bind[T].annotatedWith[Ann].to[Class[U <: T]]
    bind[T].annotatedWith[Ann].toInstance(T)

    bind[T].annotatedWith[Class[Ann]].to[U <: T]
    bind[T].annotatedWith[Class[Ann]].to[Class[U <: T]]
    bind[T].annotatedWith[Class[Ann]].toInstance(T)

    bind[T].annotatedWith(Annotation).to[U <: T]
    bind[T].annotatedWith(Annotation).to[Class[U <: T]]
    bind[T].annotatedWith(Annotation).toInstance(T)

    bindClass(Class[T]).to[T]
    bindClass(Class[T]).to[Class[U <: T]]
    bindClass(Class[T]).toInstance(T)

    bindClass(Class[T]).annotatedWith[Class[Ann]].to[T]
    bindClass(Class[T]).annotatedWith[Class[Ann]].[Class[U <: T]]
    bindClass(Class[T]).annotatedWith[Class[Ann]].toInstance(T)

    bindClass(Class[T]).annotatedWith(Annotation).to[T]
    bindClass(Class[T]).annotatedWith(Annotation).[Class[U <: T]]
    bindClass(Class[T]).annotatedWith(Annotation).toInstance(T)
  ```

  For Java users, there are more Java-friendly methods:

  ```
    bindClass(Class[T], T)
    bindClass(Class[T], Annotation, T)
    bindClass(Class[T], Class[Annotation], T)

    bindClass(Class[T], Class[U <: T])
    bindClass(Class[T],  Annotation, Class[U <: T])
    bindClass(Class[T], Class[Annotation], Class[U <: T])
  ```

  Additionally, these changes highlighted the lack of Java-support in the `TwitterModule` for
  creating injectable Flags. Thus `c.t.inject.TwitterModuleFlags` has been updated to also provide
  Java-friendly flag creation methods:

  ```
    protected def createFlag[T](name: String, default: T, help: String, flggble: Flaggable[T]): Flag[T]
    protected def createMandatoryFlag[T](name: String, help: String, usage: String, flggble: Flaggable[T]): Flag[T]
  ```
  [0d532084](https://github.com/twitter/finatra/commit/0d5320848cbd48e103047c3267b73c9dff92c027)

* inject-thrift-client: The "retryBudget" in the `c.t.inject.thrift.modules.ThriftMethodBuilderClientModule`
  should be a `RetryBudget` and not the generic `Budget` configuration Param. Updated the type.
  [8feea4bb](https://github.com/twitter/finatra/commit/8feea4bb5bd0a0bb54464143cade82e870e926b7)

* inject-server: Move HTTP-related concerns out of the embedded testing utilities into
  specific HTTP "clients". The exposed `httpAdminClient` in the `EmbeddedTwitterServer`
  and the `httpClient` and `httpsClient` in the `EmbeddedHttpServer` are no longer just
  Finagle Services from Request to Response, but actual objects. The underlying Finagle
  `Service[Request, Response]` can be accessed via `Client.service`. [0e304bbc](https://github.com/twitter/finatra/commit/0e304bbc14980c7d1f0c9c74ab368e56acdb5566)

### [Scrooge](https://github.com/twitter/scrooge/) ###

* scrooge-generator: Add support for construction_required fields. Add a validateNewInstance method
  to all generated scala companion objects. [cbde3312](https://github.com/twitter/scrooge/commit/cbde33122c768b54d00b77b32aeed09041b95ca0)

* scrooge-core: Check for corruption in size meta field of container and throw
  an exception if size is found corrupted. [75392161](https://github.com/twitter/scrooge/commit/753921613a1488b04302d5c8b336d3070b5d26ac)
* scrooge: Upgrade libthrift to 0.10.0. [997f2464](https://github.com/twitter/scrooge/commit/997f2464ca04998ce5b7a73c56c7667d1754a01b)

### [TwitterServer](https://github.com/twitter/twitter-server/) ###

No Changes

### [Util](https://github.com/twitter/util/) ###

New Features

  * util-app: Add the ability to bind specific implementations for `LoadService.apply`
    via `App.loadServiceBindings`. [74058678](https://github.com/twitter/util/commit/740586781d2822a7ddca1cee04b54987c36ec016)

  * util-core: Introduce the `ClosableOnce` trait which extends the guarantees of
    `Closable` to include idempotency of the `close` method. [ccd1c697](https://github.com/twitter/util/commit/ccd1c697057cc4893630dd8aac419fb07b903512)

Runtime Behavior Changes

  * util-app: Add visibility for NonFatal exceptions during exiting of `c.t.app.App`.
    Added visibility into any NonFatal exceptions which occur during the closing of
    resources during `App#close`. [b152745e](https://github.com/twitter/util/commit/b152745ef5d06d9b688d330fb7d30cbd7a0fd2cc)

  * util-core: Ensure the `Awaitable.CloseAwaitably0.closeAwaitably` Future returns.
    Because the `closed` AtomicBoolean is flipped, we want to make sure that executing
    the passed in `f` function satisfies the `onClose` Promise even the cases of thrown
    exceptions. [0c793f97](https://github.com/twitter/util/commit/0c793f97f1a9d481295137d7603e407c4a4a780c)

  * util-stats: Alphabetically sort stats printed to the given `PrintStream` in the
    `c.t.finagle.stats.InMemoryStatsReceiver#print(PrintStream)` function.

    To include stats headers which provide better visual separation for the different
    types of stats being printedm, set `includeHeaders` to true. E.g.,

    ```
    InMemoryStatsReceiver#print(PrintStream, includeHeaders = true)
    ```
    [a60a311c](https://github.com/twitter/util/commit/a60a311c141fc21ecb4da4cc23712e1722cb18fe)


### Changelogs ###

* [Finagle 18.4.0][finagle]
* [Util 18.4.0][util]
* [Scrooge 18.4.0][scrooge]
* [TwitterServer 18.4.0][twitterserver]
* [Finatra 18.4.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-18.4.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-18.4.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-18.4.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-18.4.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-18.4.0/CHANGELOG.md

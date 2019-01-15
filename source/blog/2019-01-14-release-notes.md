---
layout: post
title: January 2019 Release Notes - Version 19.1.0 🎉
published: true
post_author:
  display_name: Ryan O'Neill
  twitter: ryanoneill
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Happy New Year folks! Hopefully new years resolutions are still on pace. In
the meantime, let's kick off 2019 with a fresh new release of libraries.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

*   finagle-core: `c.t.f.s.StackBasedServer` has been changed to extend the
    `c.t.f.Stack.Transformable` trait. This brings `StackBasedServer` into parity
    with `c.t.f.c.StackBasedClient`, which already extends the
    `Stack.Transformable` trait. [9f637b5e](https://github.com/twitter/finagle/commit/9f637b5e41b9ea77129c4a48f4327e3b51787526)

*   finagle-http: HttpMuxer propagates the close signal to the underlying handlers.
    [6475680d](https://github.com/twitter/finagle/commit/6475680d241f3e9b026b3c3aa6eb94da8c1c37d4)

*   finagle-stats-core: introduce flag to allow logging metrics on service shutdown.
    [4588bc1f](https://github.com/twitter/finagle/commit/4588bc1f0a64f3ff6ab1e241bb0726a79f72ca14)

#### Breaking API Changes

*   finagle-core: The deprecated `c.t.f.b.ServerBuilder.stack` method which takes a function
    has been removed. Uses of this method should be changed to use the c.t.f.b.ServerBuilder.stack
    method which takes a `c.t.f.s.StackBasedServer` instead. [a05e5e7b](https://github.com/twitter/finagle/commit/a05e5e7b69d1b8237d8a6360d00c031172a2db0f)

*   finagle-core: The type of `c.t.f.b.ServerConfig.nilServer` has been changed from
    `Server\[Req, Rep\]` to `StackBasedServer\[Req, Rep\]`. [4be953d4](https://github.com/twitter/finagle/commit/4be953d433899b0dc4d4a6155283699c8cd8c06d)

*   finagle-core: The access level of the `c.t.f.b.ServerBuilder.copy` method has changed
    from protected to private. [4be953d4](https://github.com/twitter/finagle/commit/4be953d433899b0dc4d4a6155283699c8cd8c06d)

*   finagle-core: The bridge type `c.t.f.b.Server` has been removed. Users should
    change to use `c.t.f.ListeningServer` instead. Uses of the previously
    deprecated `Server.localAddress` should use `ListeningServer.boundAddress`
    instead. [eb66ee71](https://github.com/twitter/finagle/commit/eb66ee71b7054112ab6f4618e3e985d56aaa1f44)

*   finagle-core: The deprecated `c.t.f.t.Transport.localAddress` and
    `c.t.f.t.Transport.remoteAddress` methods are now final and can no longer
    be extended. Users should migrate to the respective `c.t.f.t.TransportContext`
    methods. [b85f43a0](https://github.com/twitter/finagle/commit/b85f43a0a80d53766eef22c16c5f7c3497b34e87)

*   finagle-thrift: The `c.t.f.t.ThriftRichClient.protocolFactory` and
    `c.t.f.t.ThriftRichServer.protocolFactory` methods have been removed. Users should
    switch to using `ThriftRichClient.clientParam.protocolFactory` and
    `ThriftRichServer.serverParam.protocolFactory` instead. In addition, implementations
    of the `protocolFactory` method have been removed from the concrete `c.t.f.Thrift`
    and `c.t.f.ThriftMux` client and server. [e33baf82](https://github.com/twitter/finagle/commit/e33baf8210d0acd4f2fab9877acd1ceea287ab40)

#### Bug Fixes

*   finagle-core: Failed writes on Linux due to a remote peer disconnecting should now
    be properly seen as a `c.t.f.ChannelClosedException` instead of a
    `c.t.f.UnknownChannelException`. [8f5774cb](https://github.com/twitter/finagle/commit/8f5774cbb8d8342ae5785f1bbeb66f5a07420810)

*   finagle-http: Compression level of 0 was failing on the server-side when speaking h2c.
    Updated so that it can handle a request properly. [5f96fcb2](https://github.com/twitter/finagle/commit/5f96fcb2b042f641de7db10428981b8bcb2a4e0a)

*   finagle-thriftmux: A Java compatibility issue for users trying to call `withOpportunisticTls`
    on `ThriftMux` clients and servers has been fixed. [e57d2a91](https://github.com/twitter/finagle/commit/e57d2a9156d72ada8a81a590714ece676e423ce6)

#### Runtime Behavior Changes

*   finagle-core: `ServiceFactory.const` propagates the close from the `ServiceFactory`
    to the underlying service, instead of ignoring it. [6475680d](https://github.com/twitter/finagle/commit/6475680d241f3e9b026b3c3aa6eb94da8c1c37d4)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

*   finatra-kafka-streams: SumAggregator and CompositeSumAggregator only support enhanced window
    aggregations for the sum operation. Deprecate SumAggregator and CompositeSumAggregator and create
    an AggregatorTransformer class that can perform arbitrary aggregations. [f588970e](https://github.com/twitter/finatra/commit/f588970e04c976b549d1b95dfce8326139d4353e)

*   finatra-streams: Open-source Finatra Streams. Finatra Streams is an integration
    between Kafka Streams and Finatra which we've been using internally at Twitter
    for the last year. The library is not currently open-source.
    [47cce546](https://github.com/twitter/finatra/commit/47cce5462c5831a4bd1952f3c80b72987fda5552)

*   inject-server: Add lint rule to alert when deprecated `util-logging` JUL flags from the
    `c.t.inject.server.DeprecatedLogging` trait are user defined. This trait was mixed-in
    only for backwards compatibility when TwitterServer was moved to the slf4j-api and the flags are
    not expected to be configured. By default, `util-app` based applications will fail to start if
    they are passed a flag value at startup which they do not define. Users should instead configure
    their chosen slf4j-api logging implementation directly. [388bf8f9](https://github.com/twitter/finatra/commit/388bf8f9564dd67681640aeefed1e75d6b63b5b9)

*   finatra-thrift: `c.t.finatra.thrift.Controllers` now support per-method filtering and
    access to headers via `c.t.scrooge.{Request, Response}` wrappers. To use this new
    functionality, create a `Controller` which extends the
    `c.t.finatra.thrift.Controller(SomeThriftService)` abstract class instead of constructing a
    `Controller` that mixes in the `SomeThriftService.BaseServiceIface` trait. With this, you can now
    provide implementations in form of `c.t.scrooge.Request`/`c.t.scrooge.Response` wrappers by calling
    the `handle(ThriftMethod)` method. Note that a `Controller` constructed this way cannot also
    extend a `BaseServiceIface`.

    ``` {.sourceCode .scala}
    handle(SomeMethod).filtered(someFilter).withFn { req: Request[SomeMethod.Args] =>
      val requestHeaders = req.headers
      // .. implementation here

      // response: Future[Response[SomeMethod.SuccessType]]
    }
    ```

    Note that if `Request`/`Response` based implementations are used the types on any
    existing `ExceptionMappers` should be adjusted accordingly. Also, if a `DarkTrafficFilterModule`
    was previously used, it must be swapped out for a `ReqRepDarkTrafficFilterModule`
    [9d891cd1](https://github.com/twitter/finatra/commit/9d891cd1f6f907c59ad9f40a7db20c4a2b33faf1)

#### Changed

*   inject-core, inject-server: Remove deprecated `@Bind` support from test mixins. Users should
    instead prefer using the [bind\[T\]](https://twitter.github.io/finatra/user-guide/testing/bind_dsl.html)
    DSL in tests. [841f6974](https://github.com/twitter/finatra/commit/841f6974864f84f4940f68a4b4145259b5c81933)

*   inject-app: Remove deprecated `bind\[T\]` DSL methods from c.t.inject.app.BindDSL.

    Instead of:

    ``` {.sourceCode .scala}
    injector.bind[T](instance)
    injector.bind[T, Ann](instance)
    injector.bind[T](ann, instance)
    ```

    Users should instead use the more expressive forms of these methods, e.g.,:

    ``` {.sourceCode .scala}
    injector.bind[T].toInstance(instance)
    injector.bind[T].annotatedWith[Ann].toInstance(instance)
    injector.bind[T].annotatedWith(ann).toInstance(instance)
    ```

    which more closely mirrors the scala-guice binding DSL. [2690003d](https://github.com/twitter/finatra/commit/2690003d8a79a520f46972ab05945c9381de0e7a)

*   finatra-thrift: For services that wish to support dark traffic over
    `c.t.scrooge.Request`/`c.t.scrooge.Response`-based services, a new dark traffic module is
    available: `c.t.finatra.thrift.modules.ReqRepDarkTrafficFilterModule` [9d891cd1](https://github.com/twitter/finatra/commit/9d891cd1f6f907c59ad9f40a7db20c4a2b33faf1)

*   finatra-thrift: Creating a `c.t.finatra.thrift.Controller` that extends a
    `ThriftService.BaseServiceIface` has been deprecated. See the related bullet point in "Added" with
    the corresponding PHAB\_ID to this one for how to migrate. [9d891cd1](https://github.com/twitter/finatra/commit/9d891cd1f6f907c59ad9f40a7db20c4a2b33faf1)

*   inject-core, inject-server: Remove deprecated `WordSpec` testing utilities. The framework
    default ScalaTest testing style is `FunSuite` though users are free to mix their testing
    style of choice with the framework provided test mixins as per the
    [documentation](https://twitter.github.io/finatra/user-guide/testing/mixins.html).
    [41767c6e](https://github.com/twitter/finatra/commit/41767c6ebd19488bf8140bda987ba19055313d31)

*   finatra-thrift: Instead of failing (potentially silently)
    `c.t.finatra.thrift.routing.ThriftWarmup` now explicitly checks that it is
    using a properly configured `c.t.finatra.thrift.routing.Router` [e2dc8b30](https://github.com/twitter/finatra/commit/e2dc8b300f6dcd4e861b0e4320f1d5cb5316e19a)

*   finatra-inject: `c.t.finatra.inject.server.PortUtils` has been modified to
    work with `c.t.f.ListeningServer` only. Methods which worked with the
    now-removed `c.t.f.b.Server` have been modified or removed.
    [642d7260](https://github.com/twitter/finatra/commit/642d7260b5282e3be2fb76ab8182b6504bb1c20d)

*   finatra-kafka-streams: Finatra Queryable State methods currently require the window size
    to be passed into query methods for windowed key value stores. This is unnecessary, as
    the queryable state class can be passed the window size at construction time. We also now
    save off all FinatraKeyValueStores in a global manager class to allow query services
    (e.g. thrift) to access the same KeyValueStore implementation that the FinatraTransformer
    is using. [c51e174b](https://github.com/twitter/finatra/commit/c51e174b1869c6abd7dfbd9a5965b2f27a4e5cf9)

#### Fixed

*   finatra-kafka-streams: Fix bug where KeyValueStore\#isOpen was throwing an
    exception when called on an uninitialized key value store
    [d3f833a1](https://github.com/twitter/finatra/commit/d3f833a14ef6efdd521fcd7425fcac210757d620)

### [Scrooge](https://github.com/twitter/scrooge/) ###

*   Update asm, cglib, jmock dependencies [688cd29e](https://github.com/twitter/scrooge/commit/688cd29e0a6421dca5e43a081bf5f9d9b8c02039)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

*   Propagate the admin server's shutdown to the handlers that are registered with the admin server.
    [8a164d46](https://github.com/twitter/twitter-server/commit/8a164d46d68749310f68b207d8decd7d10986afa)

### [Util](https://github.com/twitter/util/) ###

#### New Features

*   util-core: Added Reader.map/flatMap to transform Reader\[A\] to Reader\[B\]. Added `fromFuture()`
    and `value()` in the Reader object to construct a new Reader. [ac15ad8b](https://github.com/twitter/util/commit/ac15ad8bbd633aa5efd5e306d2dea2c40a50379e)

#### Breaking API Changes

*   util-core: The implicit conversions classes in `c.t.conversions.SomethingOps` have been
    renamed to have unique names. This allows them to be used together with wildcard imports.
    See Github issue (<https://github.com/twitter/util/issues/239>). [2d5d6da9](https://github.com/twitter/util/commit/2d5d6da989ab83e8701b9f57ae0708a5851beb07)

*   util-core: Both `c.t.io.Writer.FailingWriter` and `c.t.io.Writer.fail` were removed. Build your
    own instance should you need to. [63815225](https://github.com/twitter/util/commit/63815225ef894029bf107c1c2b4e17182e515994)


---
layout: post
title: August 2020 Release Notes - Version 20.8.0
published: true
post_author:
  display_name: Bonnie Eisenman
  twitter: brindelle
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Another month, another release. 😺 Here's the August release of Finagle, Finatra, Scrooge, Twitter Server, and Util.

### [Finagle](https://github.com/twitter/finagle/)

#### Runtime Behavior Changes

-   finagle-netty4-http: Post, Put, Patch non-streaming outbound requests with empty bodies will
    be added the Content-Length header with value 0. [9ce18e85](https://github.com/twitter/finagle/commit/9ce18e853deafad499e2a8d413e48dea9052fbe7)
-   finagle-core: A ServiceFactory created by ServiceFactory.const/constant propagates the wrapped
    service status. [3347c095](https://github.com/twitter/finagle/commit/3347c0956ff0d64dac68592d030c7d46d70f37f6)
-   finagle-http: c.t.f.http.filter.PayloadSizeFilter no longer adds an annotation on each
    streaming chunk and instead aggregates the byte count and adds a single record on stream
    termination. [e87b1c35](https://github.com/twitter/finagle/commit/e87b1c35da8d625dc573c8641b8e6a4ad23927e2)
-   finagle-zipkin-scribe: zipkin scribe log\_span prefix replaced with scribe. zipkin-scribe/scribe/&lt;stats&gt;. [5b100ee9](https://github.com/twitter/finagle/commit/5b100ee9b00d620b53f614e496c4faed9af122fc)

#### New Features

-   finagle-core: introduce type-safe ReqRep variant [459daf68](https://github.com/twitter/finagle/commit/459daf6864825f26cf8e5a707d75797b938e6808)
-   finagle-core: Added a new variant of Filter.andThenIf which allows passing the parameters
    as individual parameters instead of a Scala tuple. [fb071d9b](https://github.com/twitter/finagle/commit/fb071d9b755843dc2841bc14f0192252a136f06a)
-   finagle-core: new metric (counter) for traces that are sampled. finagle/tracing/sampled [1d6503e0](https://github.com/twitter/finagle/commit/1d6503e07b957f87403211bcf0ac80db1b009716)
-   finagle-netty4: Add the c.t.f.netty4.Netty4Listener.MaxConnections param that can be used
    to limit the number of connections that a listener will maintain. Connections that exceed
    the limit are eagerly closed. [9991aae3](https://github.com/twitter/finagle/commit/9991aae3851e6db2367379836298afce7fe6f210)
-   finagle-thrift: Added java-friendly c.t.f.thrift.exp.partitioning.ClientHashingStrategy and
    c.t.f.thrift.exp.partitioning.ClientCustomStrategy create methods, and added java-friendly
    c.t.f.thrift.exp.partitioning.RequestMergerRegistry\#addRequestMerger and
    c.t.f.thrift.exp.partitioning.ResponseMergerRegistry\#addResponseMerger to make partitioning
    easier to use from Java. [e0d78d14](https://github.com/twitter/finagle/commit/e0d78d146208c9592e88574a6d032d5bf20b29b2)

#### Breaking API Changes

-   finagle-core: ReqRep can no longer be created via new ReqRep(..). Please use
    ReqRep.apply(..) instead.
    [459daf68](https://github.com/twitter/finagle/commit/459daf6864825f26cf8e5a707d75797b938e6808)
-   finagle-thrift: Updated the c.t.f.thrift.exp.partitioning.ClientHashingStrategy and the
    c.t.f.thrift.exp.partitioning.ClientCustomStrategy to take constructor arguments instead
    of needing to override methods on construction. [e0d78d14](https://github.com/twitter/finagle/commit/e0d78d146208c9592e88574a6d032d5bf20b29b2)
-   finagle-zipkin-core: Removed unused statsReceiver constructor argument from RawZipkinTracer. [5b100ee9](https://github.com/twitter/finagle/commit/5b100ee9b00d620b53f614e496c4faed9af122fc)


### [Finatra](https://github.com/twitter/finatra/)

#### Added

-   inject-app: Add more Java-friendly constructors for the TestInjector. [2408860e](https://github.com/twitter/finatra/commit/2408860e1c550b030329dc746283232cd73f7679)

#### Changed

-   inject-modules: Improve Java usability: rename apply to get for
    StatsReceiverModule and LoggerModule.
    Add get methods for other TwitterModule singleton objects.
    (BREAKING API CHANGE) [0cbbf8ab](https://github.com/twitter/finatra/commit/0cbbf8ab6c8e69682ee04746267e33b5848260dc)
-   inject-core: Deprecate c.t.inject.Resettable (no replacement) and c.t.inject.TestTwitterModule.
    Users should prefer the \#bind\[T\] DSL over usage of the TestTwitterModule. [f95fe7cb](https://github.com/twitter/finatra/commit/f95fe7cb9002592ebf219227df253cd5c7e65b82)

#### Fixed

-   inject-server: Fix EmbeddedTwitterServer to return StartupTimeoutException when server under
    test fails to start within max startup time. [3eb0cd85](https://github.com/twitter/finatra/commit/3eb0cd859dd3e8293dd14773af8740e3d5c48be7)


### [Util](https://github.com/twitter/util/)

#### New Features

-   util-stats: Store MetricSchemas in InMemoryStatsReceiver to enable further testing. [c305712e](https://github.com/twitter/util/commit/c305712e6fc1fc85d598256b7850393a97cd5c38)
-   util-core: c.t.u.Var.Observer is now public. This allows scala users to extend the Var trait
    as has been the case for Java users. [ee1cebcf](https://github.com/twitter/util/commit/ee1cebcf44897cdd4df87c11ebc752fd9d583e07)
-   util-core: Added two new methods to c.t.u.Duration and c.t.u.Time: .fromHours and .fromDays. [955f2ce9](https://github.com/twitter/util/commit/955f2ce9458c8a60af78b919275d934e51d7f623)

#### Runtime Behavior Changes

-   util-app: Treat empty strings as empty collections in Flag\[Seq\[\_\]\], Flag\[Set\[\_\]\],
    Flag\[java.util.List\[\_\]\], and Flag\[java.util.Set\[\_\]\]. They were treated as collections
    with single element, empty string, before. [43f83d22](https://github.com/twitter/util/commit/43f83d2250af2f47425825175bd49e563a79fa18)



### [Twitter Server](https://github.com/twitter/twitter-server/)

No Changes


### [Scrooge](https://github.com/twitter/scrooge/)

-   scrooge: replace deprecated ScalaTest 3.0 API with ScalaTest 3.1/3.2 API. [9878247b](https://github.com/twitter/scrooge/commit/9878247b1bd474fcbb03e3044b664e289565f652)
-   scrooge-core: Change c.t.scrooge.ThriftStructMetaData from an abstract class to a trait
    to allow for mixin to classes that already extend other classes. [982e8530](https://github.com/twitter/scrooge/commit/982e8530184cd04d9b16dd11addc6d0c4efcaa68)


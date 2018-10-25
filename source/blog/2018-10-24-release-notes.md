---
layout: post
title: October 2018 Release Notes — Version 18.10.0
published: true
post_author:
  display_name: Neuman Vong
  twitter: neuman
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Here we are in the month of October, just a few weeks until creatures of
fantasy roam the streets together with people dressed up as creatures of
fantasy 👹.

Speaking of the fantastic, we have new releases!

[Finagle 18.10.0](https://github.com/twitter/finagle/releases/tag/finagle-18.10.0),
[Finatra 18.10.0](https://github.com/twitter/finatra/releases/tag/finatra-18.10.0),
[Scrooge 18.10.0](https://github.com/twitter/scrooge/releases/tag/scrooge-18.10.0),
[TwitterServer 18.10.0](https://github.com/twitter/twitter-server/releases/tag/twitter-server-18.10.0),
and [Util 18.10.0](https://github.com/twitter/util/releases/tag/util-18.10.0).

### [Finagle](https://github.com/twitter/finagle/) ###

#### Deprecations

* finagle-core: Deprecation warnings have been removed from the 'status', 'onClose',
  and 'close' methods on `c.t.f.t.Transport`, and added to the corresponding methods
  on `c.t.f.t.TransportContext`. [9ae6d978](https://github.com/twitter/finagle/commit/9ae6d978c9b0c77309e7d199f6f71c6cc5d58586)

#### Runtime Behavior Changes

* finagle-netty3: Implementations for 'status', 'onClose', and 'close' methods have
  been moved from `c.t.f.n.t.ChannelTransportContext` to `c.t.f.n.t.ChannelTransport`.
  [9ae6d978](https://github.com/twitter/finagle/commit/9ae6d978c9b0c77309e7d199f6f71c6cc5d58586)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Fixed

* finatra-thrift: Set the bound `StatsReceiver` in the underlying Finagle `ThriftMux` server
  in the `c.t.finatra.thrift.ThriftServer`. This prevented testing of underlying Finagle server
  stats as the `InMemoryStatsReceiver` used by the `EmbeddedThriftServer` was not properly passed
  all the way through the stack. [33d0524b](https://github.com/twitter/finatra/commit/33d0524b76f943c5661c0b21ff0d38c1d6563202)

#### Changed

* finatra-http, finatra-thrift: Make HTTP and Thrift StatsFitlers "Response Classification"
  aware. [4085d40c](https://github.com/twitter/finatra/commit/4085d40cb7cb607101564bbc488f9a1daea56dff)

* finatra-http, finatra-thrift: (BREAKING API CHANGE) Update the `DarkTrafficFilterModule` in
  both HTTP and Thrift to allow for specifying further configuration of the underlying Finagle client.
  This allows users the ability to set Finagle client concerns like ResponseClassification or other
  configuration not expressed by the DarkTrafficFilterModule's API.

  - Additionally, the Thrift `DarkTrafficFilterModule` has been updated to be ThriftMux only. For more information on mux see: [What is ThriftMux](https://twitter.github.io/finagle/guide/FAQ.html?highlight=thriftmux#what-is-thriftmux).

  - We also update the `enableSampling` method to accept a `c.t.inject.Injector` to aid in the decision-making for if a given request should be "sampled" by the filter. [d7486843](https://github.com/twitter/finatra/commit/d74868430cf6b0da2051b3ff0f2d1e47e6c0c169)

* finatra-thrift: (BREAKING API CHANGE) Update `c.t.finatra.thrift.routing.ThriftRouter` API for
  adding Java Thrift controllers. The `service: Class[_]` was rendered unnecessary some time ago
  but not removed from the API signature. Because this parameter is useless and it shadows
  another variable inside of the code we remove it from the signature altogether rather than
  deprecating the API. [c2378cc7](https://github.com/twitter/finatra/commit/c2378cc7b61bce18afa65ff5b76175dfaecd7b13)

* finatra-thrift: Rename `defaultFinatraThriftPort` to `defaultThriftPort`.
  [5910fd23](https://github.com/twitter/finatra/commit/5910fd2358ad0e9e9c8ee1c25b549afabfee199f)

### [Scrooge](https://github.com/twitter/scrooge/) ###

* scrooge: Add type annotations to public members in generated code.
  [5cad1005](https://github.com/twitter/scrooge/commit/5cad10055fb9fa45f7b2659bf5830745e9fc472b)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

#### Changes

* Deprecate `c.t.server.AdminHttpServer#routes`. Routes should be added to the `AdminHttpServer`
  via `c.t.server.AdminHttpServer#addAdminRoutes`. [4078e4cb](https://github.com/twitter/twitter-server/commit/4078e4cb39812f1085bd38fdcaca2de35f2dffc7)

#### Runtime Behavior Changes

* Update `BuildProperties` to not emit a warning when no `build.properties` file can be
  located. [7ce6e4cb](https://github.com/twitter/twitter-server/commit/7ce6e4cbcaf3ac9d9dccd62a5aaf9c9572cf5788)

### [Util](https://github.com/twitter/util/) ###

#### Breaking API Changes

* util-core: `c.t.io.Reader.Writable` and `c.t.Reader.writable()` are removed. Use `c.t.io.Pipe`
  instead. [5ef6a0dc](https://github.com/twitter/util/commit/5ef6a0dca89dad4488ce33cd1ea5a2f8eab1bb7a)

* util-core: `c.t.util.TempFolder` has been moved to `c.t.io.TempFolder`. [2f8ee904](https://github.com/twitter/util/commit/2f8ee9048431a7cdf10333390b0eb2e1c2df08cd)

* util-core: Removed the forwarding types `c.t.util.TimeConversions` and
  `c.t.util.StorageUnitConversions`. Use `c.t.conversions.time` and
  `c.t.conversions.storage` directly. [0c83ebc0](https://github.com/twitter/util/commit/0c83ebc0ae1d6d62fabf80a48bca501c6457440f)

* util-core: `c.t.concurrent.AsyncStream.fromReader` has been moved to
  `c.t.io.Reader.toAsyncStream`. [6c3be47d](https://github.com/twitter/util/commit/6c3be47d69bf628a9b87146309e2e02844a2d25b)

#### New Features

* util-core: `c.t.io.Reader.fromBuf` (`BufReader`), `c.t.io.Reader.fromFile`,
  `c.t.io.Reader.fromInputStream` (`InputStreamReader`) now take an additional parameter,
  `chunkSize`, the upper bound of the number of bytes that a given reader emits at each read.
  [719f41a6](https://github.com/twitter/util/commit/719f41a65b723c21d03348d02989c93e293beb42)

#### Runtime Behavior Changes

* util-core: `c.t.u.Duration.inTimeUnit` can now return
  `j.u.c.TimeUnit.MINUTES`. [0daac8d7](https://github.com/twitter/util/commit/0daac8d785b02bc819b1464c695f17a28ffb3384)

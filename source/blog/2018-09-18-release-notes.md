---
layout: post
title: September 2018 Release Notes — Version 18.9.0
published: true
post_author:
  display_name: Jordan Parker
  twitter: nepthar
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

It's the sunniest month of the year here in the Bay Area, and we're celebrating
with yet another set of fresh releases!

[Finagle 18.9.0](https://github.com/twitter/finagle/releases/tag/finagle-18.9.0),
[Finatra 18.9.0](https://github.com/twitter/finatra/releases/tag/finatra-18.9.0),
[Scrooge 18.9.0](https://github.com/twitter/scrooge/releases/tag/scrooge-18.9.0),
[TwitterServer 18.9.0](https://github.com/twitter/twitter-server/releases/tag/twitter-server-18.9.0),
and [Util 18.9.0](https://github.com/twitter/util/releases/tag/util-18.9.0).

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

* finagle-core: `c.t.f.FailureFlags` is now a public API. This is Finagle's
  API for attaching metadata to an exception. As an example this is used to
  check if an exception is known to be safe to retry. Java compatibility has
  also been added. [e6389831](https://github.com/twitter/finagle/commit/e6389831e527b8634de82ecbb275705578c0f688)

* finagle-core: Introducing StackTransformer, a consistent mechanism for
  accessing and transforming the default ServerStack. [0b6844cd](https://github.com/twitter/finagle/commit/0b6844cdfbc176a499b908d8cf71b171b3aac2d0)

* finagle-netty4: Allow sockets to be configured with the [SO_REUSEPORT](http://lwn.net/Articles/542629/) option
  when using native epoll, which allows multiple processes to bind and accept connections
  from the same port. [0316ac89](https://github.com/twitter/finagle/commit/0316ac8940f056b86e3d5463ba63b6033a539886)

#### Breaking API Changes

* finagle: `c.t.io.Reader` and `c.t.io.Writer` are now abstracted over the type
  they produce/consume (`Reader[A]` and `Writer[A]`) and are no longer fixed to `Buf`.
  [5242d49d](https://github.com/twitter/finagle/commit/5242d49d8e6aa9041626311ae66405b2634136b2)

* finagle-core: `Address.hashOrdering` now takes a seed parameter and
  `PeerCoordinate.setCoordinate` does not take a `peerOffset` any longer.
  [9e6734b2](https://github.com/twitter/finagle/commit/9e6734b21f55d0aed95e33dc299ce05b3c524748)

* finagle-core: Removed deprecated members `c.t.f.Failure.{Interrupted, Ignorable, DeadlineExceeded,
  Rejected, NonRetryable, flagsOf}`. [54435221](https://github.com/twitter/finagle/commit/54435221ae361b3eef3fe0b4b6846099f1504421)

* finagle-core: SingletonPool now takes an additional parameter which indicates if interrupts
  should propagate to the underlying resource. [c83ad5d1](https://github.com/twitter/finagle/commit/c83ad5d1a3727ee8a8638bff8669cf37edecbeab)

* finagle-core: Remove `TimeoutFactory.Role` in favor of passing a role to the `module` function.
  Since this module is a re-used within the client stack, it needs unique identifiers for each
  distinct module. [4c46b80d](https://github.com/twitter/finagle/commit/4c46b80d69108e079c7761425504d19647f152fd)

* finagle-core: the valid range for the argument to `WindowedPercentileHistogram.percentile`
  is now [0.0..1.0], e.g., 0.95 means 95th percentile. [8ad96f96](https://github.com/twitter/finagle/commit/8ad96f9619a889f93195e44b7f3be27c0cfebfd3)

* finagle-mux: The old pull-based mux implementations have been removed. [d1baeff9](https://github.com/twitter/finagle/commit/d1baeff95b7e464e2827d8800da6a3ef65526128)

* finagle-netty3: The type of context of a `ChannelTransport` has been changed from a
  `LegacyContext` to a `ChannelTransportContext`. [4cdd15d9](https://github.com/twitter/finagle/commit/4cdd15d91180e3a05369063061cee213b3642e69)

* finagle-netty4: The type of context of a `ChannelTransport` has been changed from a
  `Netty4Context` to a `ChannelTransportContext`. [edce8093](https://github.com/twitter/finagle/commit/edce8093e8e741b4b3f671702298ed4b06fb8735)

* finagle-netty4: `c.t.f.netty4.param.useUnpoolledByteBufAllocator` flag has been removed. There is
  no good reason to opt-out of a more efficient, pooled allocator. [07495a14](https://github.com/twitter/finagle/commit/07495a14672ff871a892355f1fcb0372c201dc48)

* finagle-thrift: `DeserializeCtx` became `ClientDeserializeCtx` for client side response
  classification, add `ServerDeserializeCtx` to handle server side response classification.
  [a8be34bd](https://github.com/twitter/finagle/commit/a8be34bdff98c794482f536ed6dd6432b7c23f06)

* finagle-serversets: `ZkMetadata.shardHashOrdering` now takes a seed parameter.
  [9e6734b2](https://github.com/twitter/finagle/commit/9e6734b21f55d0aed95e33dc299ce05b3c524748)

#### Bug Fixes

* finagle-thrift: Thrift clients created via `.servicePerEndpoint` now propagate exceptions
  appropriately when the method return type is void. [bb2654e1](https://github.com/twitter/finagle/commit/bb2654e13674a2e6304be2354caa02387df52589)

* finagle-thrift, finagle-thriftmux: Response classification is enabled in server side.
  [a8be34bd](https://github.com/twitter/finagle/commit/a8be34bdff98c794482f536ed6dd6432b7c23f06)

#### Runtime Behavior Changes

* finagle-memcached: A Memcached client (`c.t.f.Memcached.Client`) is now backed by a more efficient,
  push-based implementation. [c0a1f295](https://github.com/twitter/finagle/commit/c0a1f295f58d699a77142ea2720965b63203cc89)

* finagle-netty4: Finagle's Netty 4 implementation now defaults to use Linux's native epoll
  transport, when available. Run with `-com.twitter.finagle.netty4.useNativeEpoll=false` to opt out.
  [137f5672](https://github.com/twitter/finagle/commit/137f56721fd7aa750101aee29203649d6f0e539c)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed

* inject-core: Remove unnecessary Await.result Future.Value in TestMixin. [1616188c](https://github.com/twitter/finatra/commit/1616188cfb5414efa47d28618bde3b90abba0e63)

* finatra-http: (BREAKING API CHANGE) `c.t.io.Reader` and `c.t.io.Writer` are now abstracted over
  the type they produce/consume (`Reader[A]` and `Writer[A]`) and are no longer fixed to `Buf`.
  [d56244d1](https://github.com/twitter/finatra/commit/d56244d1f0cd1442c8712e3b2ba24fdd6570f9ee)

### [Scrooge](https://github.com/twitter/scrooge/) ###

#### New Features

* scrooge-generator: Scala and Java generated Thrift exceptions now implement `c.t.f.FailureFlags`.
  This allows exceptions to carry Finagle metadata such as non-retryable. [438599b0](https://github.com/twitter/scrooge/commit/438599b0b15fb3c2bbdcf302fe18046a530071b1)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

#### Runtime Behavior Changes

* Move logic to parse the server `build.properties` file out the `c.t.server.handler.ServerInfoHandler`
  and into a utility object, `c.t.server.BuildProperties` to allow for accessing by other server
  logic such that the properties do not need to be re-parsed anytime access is desired. Failure to
  load the properties can result in the server not starting in the case of a Fatal exception
  being thrown. [4c193594](https://github.com/twitter/twitter-server/commit/4c193594053cd332ef2ff1602df82ad948024a7e)

* Update `TwitterServer` trait to override the inherited `ShutdownTimer` to be the Finagle
  `DefaultTimer` instead of the `c.t.util.JavaTimer` defined by default in `c.t.app.App`. Also
  update the overridden `suppressGracefulShutdownErrors` in `TwitterServer` to be a val since
  it is constant (instead of a def). [944b7294](https://github.com/twitter/twitter-server/commit/944b7294eea62769cc53e30f6ecab91a243fe444)

### [Util](https://github.com/twitter/util/) ###

#### New Features

* util-logging: New way to construct `ScribeHandler` for java interoperability.
  [845620b4](https://github.com/twitter/util/commit/845620b48ea27c815b55ce1a7ce4deb54a1b2532)

* util-core: Added Reader#fromAsyncStream for consuming an `AsyncStream` as a `Reader`.
  [39ec9849](https://github.com/twitter/util/commit/39ec9849814642fb46d0604f3da8aaa2437574ff)

* util-core: Introducing `Reader.chunked` that chunks the output of a given reader.
  [1a7c54f9](https://github.com/twitter/util/commit/1a7c54f96e23e0d9c66bace6cae23b7e2f21a3a8)

* util-core: Added Reader#framed for consuming data framed by a user supplied function.
  [2316aa5d](https://github.com/twitter/util/commit/2316aa5dcf68780d125124d9eb7cf62ba585844a)

* util-security: Add `NullSslSession` related objects for use with non-existent
  `SSLSession`s.  f[12de479f](https://github.com/twitter/util/commit/12de479fa6cf7b13afdf9d2458a1bd5b01499d43)

* util-tunable: Introducing `Tunable.asVar` that allows observing changes to tunables.
  [94864832](https://github.com/twitter/util/commit/94864832a593f5f75c696c8dab913ceba69e81dc)

#### Breaking API Changes

* util-core: `c.t.io.Reader` and `c.t.io.Writer` are now abstracted over the type
  they produce/consume (`Reader[A]` and `Writer[A]`) and are no longer fixed to `Buf`.
  [7718fa29](https://github.com/twitter/util/commit/7718fa298ab87e7843a5f6f136b7f92a4398561d)

* util-core: `InMemoryStatsReceiver` now eagerly creates the mappings for `Counters`
  and `Stats` instead of waiting for the first call to `Counter.incr` and `Stat.add`.
  [97f0f0fa](https://github.com/twitter/util/commit/97f0f0faa8ab1ceb8fca8743d2b4b21d26b5769d)

* util-core: `c.t.io.Reader.Writable` is now `c.t.io.Pipe`. Both `Writable` type and
  its factory method are deprecated; use `new Pipe[A]` instead.  [cbff9760](https://github.com/twitter/util/commit/cbff976029b23dc9c8d7b3b6c497b49e0a6547ad)

* util-slf4j-api: Ensure that marker information is used when determining if log
  level is enabled for methods which support markers. [02d80820](https://github.com/twitter/util/commit/02d80820c041009511e40c36e382b9ac5572f698)

* util-slfj4-api: Finalize the underlying logger def in the Logging trait as it is not
  expected that this be overridable. If users wish to change how the underlying logger is
  constructed they should simply use the Logger and its methods directly rather than
  configuring the the underlying logger of the Logging trait.
  Add better Java compatibility for constructing a Logger. [56569b9f](https://github.com/twitter/util/commit/56569b9f4226b65b32d4e3f0079515b6d5542816)

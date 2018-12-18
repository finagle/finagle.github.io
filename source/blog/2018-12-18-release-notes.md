---
layout: post
title: December 2018 Release Notes - Version 18.12.0 🧤
published: true
post_author:
  display_name: Moses Nakamura
  twitter: mnnakamura
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

It's hot chocolate season in the big apple.  That means mittens, ice-skating,
and curling up by the radiator.  Grab your puffer, it's the most beautiful time
of the year.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

* finagle-redis: Add support for the new stream API released in Redis 5.0. `ba578c14 <https://github.com/twitter/finagle/commit/ba578c1445b2e241687ad3c89eec4f3d93431a76>`__

* finagle-core: Add Java compatibility for `c.t.f.Filter.TypeAgnostic.Identity`
  via `c.t.f.Filter.typeAgnosticIdentity()`. `cff9aedd <https://github.com/twitter/finagle/commit/cff9aeddc0ae6ceb4c50cb8d67b3418a133d30f9>`__

* finagle-core: Add Java compatibility for `c.t.f.Name` through `Names`.
  `30a8000c <https://github.com/twitter/finagle/commit/30a8000c4a910134219fc1317cead9735ca97cbb>`__

* finagle-core: Introduce a `StackServer.withStack` overload that
  makes modifying the existing `Stack` easier when using method chaining.
  `f1a980cf <https://github.com/twitter/finagle/commit/f1a980cfdb780963d1e4e146d9031a93b43b107d>`__

* finagle-stats: Split the implementation and `ServiceLoading` into separate modules.
  The implementation is in `finagle-stats-core`. This is backwards compatible
  for existing users of `finagle-stats` while allowing new usages built on top.
  `b9fe5c8d <https://github.com/twitter/finagle/commit/b9fe5c8d41e7246e0dda31e9c178ae0d7d09c571>`__

* finagle-thrift: Add `c.t.finagle.thrift.MethodMetadata` which provides a `LocalContext` Key
  for setting information about the current Thrift method and an accessor for retrieving
  the currently set value. `7b22e4ef <https://github.com/twitter/finagle/commit/7b22e4efb5efd14296f2a080b1eb2ccab38db804>`__

* finagle-thrift: Update `c.t.finagle.thrift.MethodMetadata` to provide an
  `asCurrent` method to set the current `c.t.finagle.thrift.MethodMetadata` in the
  `LocalContext`. `f46e1f77 <https://github.com/twitter/finagle/commit/f46e1f771477102c93f4f82a54d0d1292a4dffba>`__

#### Breaking API Changes

* finagle-core: The `c.t.u.Closable` trait has been removed from
  `c.t.f.t.TransportContext`, as well as the `close` and `onclose` methods. Uses of
  these methods within `TransportContext` should be changed to use the corresponding
  methods on `c.t.f.t.Transport` instead. `b8b850bb <https://github.com/twitter/finagle/commit/b8b850bb9e37449854f4c983bbc8f821987cdb59>`__

* finagle-core: The deprecated `c.t.f.t.Transport.peerCertificate` method on the `Transport` class
  (not the `Transport.peerCertificate` Finagle context) has been removed. Uses of this
  method should be changed to use `c.t.f.t.TransportContext.peerCertificate` instead.
  `ab0432b4 <https://github.com/twitter/finagle/commit/ab0432b4a56f993802c68af9b3633f0b461ec97a>`__

* finagle-core: The deprecated `c.t.f.t.TransportContext.status` method has been removed
  from `TransportContext`. Uses of this method should be changed to use
  `c.t.f.t.Transport.status` instead. `fd97536f <https://github.com/twitter/finagle/commit/fd97536f63a3f72c868fa4ae5e17772b21ccfc14>`__

* finagle-mysql: `c.t.f.m.Charset` has been renamed to `c.t.f.m.MysqlCharset` to resolve
  any ambiguity between it and the `Charset` `Stack` parameter. `05354cd5 <https://github.com/twitter/finagle/commit/05354cd55a2307d51b9cec24bd747786cd6db068>`__

* finagle-mysql: All `Stack` params (`Charset`, `Credentials`, `Database`, `FoundRows`,
  `MaxConcurrentPrepareStatements`, `UnsignedColumns`) have been moved to the
  `com.twitter.finagle.mysql.param` namespace. `d30c5549 <https://github.com/twitter/finagle/commit/d30c5549500e9e6876647a9365823ceae1cddd0b>`__

* finagle-mysql: The deprecated `c.t.f.m.Client.apply(factory, statsReceiver)` method
  has been removed. `17747e1a <https://github.com/twitter/finagle/commit/17747e1a969ee5a39c45852ca3d5486cb9600c10>`__

* finagle-mysql: The `c.t.f.m.Handshake` class and companion object have been made
  private. `20c8d50f <https://github.com/twitter/finagle/commit/20c8d50f248d8ef3f32c5dc3140f37c69ec726dc>`__

* finagle-http: Rename the toggle 'c.t.f.h.UseH2CClients' to 'c.t.f.h.UseH2CClients2'.
  `43c0b69c <https://github.com/twitter/finagle/commit/43c0b69c04be6ea31e5eaf6feb0fd9bbd1856f77>`__

#### Runtime Behavior Changes

* finagle: Upgrade to Netty 4.1.31.Final and netty-tcnative 2.0.19.Final. `8e0f4b86 <https://github.com/twitter/finagle/commit/8e0f4b868c34259350fb0def2e7fee5d3d77fece>`__

* finagle-base-http: The `DefaultHeaderMap` will replace `obs-fold` ( CRLF 1*(SP/HTAB) ) in
  inserted header values. `51c4f789 <https://github.com/twitter/finagle/commit/51c4f789f106a8ca433956b72a6d478c2189f5f0>`__

### [Finatra](https://github.com/twitter/finatra/) ###


#### Added

#### Changed

* finatra-thrift: Instead of failing (potentially silently)
  `c.t.finatra.thrift.routing.ThriftWarmup` now explicitly checks that it is
  using a properly configured `c.t.finatra.thrift.routing.Router` `e2dc8b30 <https://github.com/twitter/finatra/commit/e2dc8b300f6dcd4e861b0e4320f1d5cb5316e19a>`__

* finatra-thrift: `c.t.finatra.thrift.Controller` is now an abstract class
  rather than a trait. `09c9bbb1 <https://github.com/twitter/finatra/commit/09c9bbb13d19a25478c34b7e0a02883ebe26be0a>`__

* finatra-thrift: `c.t.finatra.thrift.internal.ThriftMethodService` is now
  private. `53dc0501 <https://github.com/twitter/finatra/commit/53dc05016196743cffcc7235b1625378468ee584>`__

* finatra-thrift: `c.t.finatra.thrift.exceptions.FinatraThriftExceptionMapper` and
  `c.t.finatra.thrift.exceptions.FinatraJavaThriftExceptionMapper` now extend
  `ExceptionManager[Throwable, Nothing]` since the return type was never used. They are
  now also final. `dc894547 <https://github.com/twitter/finatra/commit/dc894547390a1130414a15594f55b3828a05ffed>`__

* finatra-thrift: Remove `c.t.finatra.thrift.routing.JavaThriftRouter#beforeFilter`. This method
  adds too much confusion to the Router API and users are encouraged to instead apply their
  TypeAgnostic Filters directly to the resultant `Service[-R, +R]`  by overriding the
  `c.t.finatra.thrift.AbstractThriftServer#configureService` method instead. `b0cb8eaf <https://github.com/twitter/finatra/commit/b0cb8eaf7107c72ccb221aea588f06af20ed40d9>`__

* finatra-thrift: `c.t.finagle.Filter.TypeAgnostic` filters are now the standard type of filter
  that can be added by configuring a `ThriftRouter`. `c.t.finatra.thrift.ThriftFilter` has been
  deprecated. `6e93b9cc <https://github.com/twitter/finatra/commit/6e93b9cc415ed25e374a4207a84328a59036bcd9>`__

* finatra-thrift: `c.t.finatra.thrift.ThriftRequest` has been deprecated. All of the information
  contained in a ThriftRequest can be found in other ways:
    `methodName` -> `Method.current.get.name`
    `traceId`    -> `Trace.id`
    `clientId`   -> `ClientId.current`
  `6e93b9cc <https://github.com/twitter/finatra/commit/6e93b9cc415ed25e374a4207a84328a59036bcd9>`__

#### Fixed

* finatra-http: Validate headers to prevent header injection vulnerability. `8a925000 <https://github.com/twitter/finatra/commit/8a9250002d2d0676b3ff82ceaa9c5260772d7c0c>`__

#### Closed

### [Scrooge](https://github.com/twitter/scrooge/) ###

* scrooge-generator: Set a `LocalContext` value with the current Thrift method in the
  generated Java and Scala code such that the application `Service[-R, +R]` being executed has
  access to information about the current Thrift method being invoked. `09da3397 <https://github.com/twitter/scrooge/commit/09da33978159fc4f0ac95848adee3b09ae64326b>`__

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

No Changes

### [Util](https://github.com/twitter/util/) ###

#### New Features

* util-core: Provide a way to listen for stream termination to `c.t.util.Reader`, `Reader#onClose`
  which is satisfied when the stream is discarded or read until the end. `3b1434e2 <https://github.com/twitter/util/commit/3b1434e2b59a4f8df89c408ed442abb738e3a6a6>`__

* util-core: Conversions in `c.t.conversions` have new implementations
  that follow a naming scheme of `SomethingOps`. Where possible the implementations
  are `AnyVal` based avoiding allocations for the common usage pattern.
  `ee56e5f2 <https://github.com/twitter/util/commit/ee56e5f2418d5d6540d37268436ff6f47520edaf>`__

  - `percent` is now `PercentOps`
  - `storage` is now `StorageUnitOps`
  - `string` is now `StringOps`
  - `thread` is now `ThreadOps`
  - `time` is now `DurationOps`
  - `u64` is now `U64Ops`

#### Bug Fixes

* util-core: Fixed a bug where tail would sometimes return Some empty AsyncStream instead of None.
  `1dc614bc <https://github.com/twitter/util/commit/1dc614bc7adf236ffe1e92b45fac35ea3241f6b0>`__

#### Deprecations

* util-core: Conversions in `c.t.conversions` have been deprecated in favor of `SomethingOps`
  versions. Where possible the implementations are `AnyVal` based and use implicit classes
  instead of implicit conversions. `ee56e5f2 <https://github.com/twitter/util/commit/ee56e5f2418d5d6540d37268436ff6f47520edaf>`__

  - `percent` is now `PercentOps`
  - `storage` is now `StorageUnitOps`
  - `string` is now `StringOps`
  - `thread` is now `ThreadOps`
  - `time` is now `DurationOps`
  - `u64` is now `U64Ops`

#### Breaking API Changes

* util-core: Experimental `c.t.io.exp.MinThroughput` utilities were removed.  `d9c5e4a3 <https://github.com/twitter/util/commit/d9c5e4a3fbb383114bc5aad73754ed9fef6f4dd2>`__

* util-core: Deleted `c.t.io.Reader.Null`, which was incompatible with `Reader#onClose` semantics.
  `c.t.io.Reader#empty[Nothing]` is a drop-in replacement. `3b1434e2 <https://github.com/twitter/util/commit/3b1434e2b59a4f8df89c408ed442abb738e3a6a6>`__

* util-core: Removed `c.t.util.U64` bits. Use `c.t.converters.u64._` instead.  `8034e557 <https://github.com/twitter/util/commit/8034e5577c953c2b99836865cd9cf6da652aea71>`__

---
layout: post
title: 🌷 March 2018 Release Notes - Version 18.3.0
published: true
post_author:
  display_name: Stefan Lance
  twitter: stefan_lance
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Our March releases have arrived!

[Finagle 18.3.0][finagle], [Finatra 18.3.0][finatra], [Scrooge 18.3.0][scrooge], [TwitterServer 18.3.0][twitterserver], and [Util 18.3.0][util].

### [Finagle](https://github.com/twitter/finagle/) ###

New Features

  * finagle-core: `c.t.f.client.BackupRequestFilter.filterService` for wrapping raw services in a
    `c.t.f.client.BackupRequestFilter` is now public. [b227d988](https://github.com/twitter/finagle/commit/b227d98821ae5aa7bfa39f5c46b354e3407204d1)

  * finagle-core: Introduce `c.t.f.Stacks.EMPTY_PARAMS` for getting an empty Param map from
    Java, and `c.t.f.Stack.Params.plus` for easily adding Params to a Param map from Java.
    [43e0f007](https://github.com/twitter/finagle/commit/43e0f007a18f923c4280b7e2746952f2986eac28)

Bug Fixes

  * finagle-core: `c.t.f.liveness.FailureAccrualFactory` takes no action on `c.t.f.Failure.Ignorable`
    responses. [512894cf](https://github.com/twitter/finagle/commit/512894cf5b98b7d7b5e7ec7261a7db447a8e7f06)

  * finagle-core: `c.t.f.pool.WatermarkPool` is resilient to multiple closes on a service instance.
    [37c29e9e](https://github.com/twitter/finagle/commit/37c29e9e06dbecac64ffc97385e6f1bde4b5ff7e)

  * finagle-core: `c.t.f.pool.CachingPool` service wrapper instances are resilient to multiple closes.
    [ce779ec7](https://github.com/twitter/finagle/commit/ce779ec7f8ab0fcf39a8c0e9797af2b074214777)

  * finagle-core: Requeue module now closes sessions it prevented from propagating up the stack.
    [f5cdda14](https://github.com/twitter/finagle/commit/f5cdda14cf5675eb4f0fea230b8efb1ab7bbff95)

  * finagle-base-http: `c.t.f.http.Netty4CookieCodec.encode` now wraps Cookie values that would
    be wrapped in `c.t.f.http.Netty3CookieCodec.encode`. [78fdc9aa](https://github.com/twitter/finagle/commit/78fdc9aa62c55cc73bf7fe78a0d7c0b7376f5567)

  * finagle-base-http: `c.t.f.http.Cookie.maxAge` returns `c.t.f.http.Cookie.DefaultMaxAge`
    (instead of null) if maxAge has been set to null or None in the copy constructor
    [17a32d44](https://github.com/twitter/finagle/commit/17a32d4461929a20e543117c9c0c82c2cb8159a1).

  * finagle-http: The HTTP client will not attempt to retry nacked requests with streaming
    bodies since it is likely that at least part of the body was already consumed and therefore
    it isn't safe to retry. [a787955b](https://github.com/twitter/finagle/commit/a787955bc277a9f6928c29a05bb5ee7ddc3185df)

Breaking API Changes

  * finagle-base-http: Removed `c.t.f.http.Cookie.comment_`, `c.t.f.http.Cookie.comment_=`,
    `c.t.f.http.Cookie.commentUrl_`, and `c.t.f.http.Cookie.commentUrl_=`. `comment` and `commentUrl`
    per RFC-6265. [13a6bd2c](https://github.com/twitter/finagle/commit/13a6bd2c75339397eb8dbada68dcf0a85d6529aa)

  * finagle-base-http: Removed deprecated `c.t.f.http.Cookie.isDiscard` and
    `c.t.f.http.Cookie.isDiscard_=`, per RFC-6265. [0e03b630](https://github.com/twitter/finagle/commit/0e03b63020ef045b5e8968e6f344472bdf30d12b)

  * finagle-base-http: Removed deprecated `c.t.f.http.Cookie.ports` and
    `c.t.f.http.Cookie.ports_=`, per RFC-6265. [0469f5b1](https://github.com/twitter/finagle/commit/0469f5b155a30fe3806911c3ae37b84cabd1a842)

  * finagle-base-http: `c.t.f.http.RequestBuilder` has been moved to the finagle-http target
    and the implicit evidence, `RequestConfig.Yes` has been renamed to `RequestBuilder.Valid`.
    [1632856c](https://github.com/twitter/finagle/commit/1632856ce70d4c03756805620e173c44497d7c3d)

  * finagle-base-http: Removed deprecated `c.t.f.Cookie.isSecure`; use `c.t.f.Cookie.secure`
    instead. Removed deprecated `c.t.f.Cookie.isSecure_=`. [33d75b95](https://github.com/twitter/finagle/commit/33d75b95a03a38d33c2e4744ef75ee8a1d910669)

  * finagle-base-http: Removed deprecated `c.t.f.http.Cookie.version` and
    `c.t.f.http.Cookie.version_=`, per RFC-6265. [6c9020cc](https://github.com/twitter/finagle/commit/6c9020cc0f0c48e10e511b97ea2d82f7edf7669f)

  * finagle-core: `c.t.f.pool.WatermarkPool` was finalized. [37c29e9e](https://github.com/twitter/finagle/commit/37c29e9e06dbecac64ffc97385e6f1bde4b5ff7e)

  * finagle-core: `c.t.finagle.ssl.Ssl` and related classes have been
    removed. They were replaced as the primary way of using SSL/TLS
    within Finagle in release 6.44.0 (April 2017). Please migrate to using
    `c.t.f.ssl.client.SslClientEngineFactory` or
    `c.t.f.ssl.server.SslServerEngineFactory` instead. [d10a42b8](https://github.com/twitter/finagle/commit/d10a42b8392cf32ecdd5fcb73df7f9a47b0b522c)

  * finagle-core: Removed `newSslEngine` and `newFinagleSslEngine` from
    `ServerBuilder`. Please implement a class which extends
    `c.t.f.ssl.server.SslServerEngineFactory` with the previously passed in
    function used as the implementation of the `apply` method. Then use the
    created engine factory with one of the `tls` methods instead.
    [d10a42b8](https://github.com/twitter/finagle/commit/d10a42b8392cf32ecdd5fcb73df7f9a47b0b522c)

  * finagle-core: The deprecated `c.t.f.loadbalancer.DefaultBalancerFactory` has been removed.
    [f6971d76](https://github.com/twitter/finagle/commit/f6971d76459e79c49b71172a6701b9e79251bb98)

  * finagle-exp: The deprecated `c.t.f.exp.BackupRequestFilter` has been removed. Please use
    `c.t.f.client.BackupRequestFilter` instead. [350d8821](https://github.com/twitter/finagle/commit/350d8821d5e82393335260f130c35a5c8b95e133)

  * finagle-http: Removed the `c.t.f.Http.Netty3Impl`. Netty4 is now the only
    underlying HTTP implementation available. [ef9fedb1](https://github.com/twitter/finagle/commit/ef9fedb1aa7a049b9161937dbda498c7a86da42e)

  * finagle-zipkin-scribe: Renamed the finagle-zipkin module to finagle-zipkin-scribe, to
    better advertise that this is just the scribe implementation, instead of the default.
    [c23ef398](https://github.com/twitter/finagle/commit/c23ef398dd76219ee3b789432f86a0e5e7883405)


### [Finatra](https://github.com/twitter/finatra/) ###

Added

* inject-server: Add a lint rule in `c.t.inject.server.TwitterServer#warmup`. If a server does not
  override the default implementation of `TwitterServer#warmup` a lint rule violation will appear
  on the lint page of the HTTP admin interface. [f0e9749a](https://github.com/twitter/finatra/commit/f0e9749aaaf990bdb4837457bae5c70bef6d54bd)

* inject-server: Add `c.t.inject.server.TwitterServer#setup` lifecycle callback method. This is
  run at the end of the `postInjectorStartup` phase and is primarily intended as a way for
  servers to start pub-sub components on which the server depends. Users should prefer this method
  over overriding the `c.t.inject.server.TwitterServer#postWarmup` @Lifecycle-annotated method as
  the callback does not require a call its super implementation for the server to correctly start
  and is ideally less error-prone to use. [e35f2873](https://github.com/twitter/finatra/commit/e35f2873d9e729d8a993ac18fb1cdaa07e2acc55)

* inject-app: Add `c.t.inject.annotations.Flags#named` for getting an implementation of an `@Flag`
  annotation. This is useful when trying to get or bind an instance of an `@Flag` annotated type.
  [4baf6c9f](https://github.com/twitter/finatra/commit/4baf6c9fed15f2cabff8051b49619792c247ba05)

Changed

* finatra-http: `ReaderDiscarded` failures writing in `c.t.f.http.StreamingResponse` now only log
  at the info level without a stack trace, while other failures log at the error level with
  a stacktrace. [ad7dee19](https://github.com/twitter/finatra/commit/ad7dee19c23797d4bb2b2b5f3107d30f6b673aef)

* inject-thrift-client: Removed `withBackupRequestFilter` method on deprecated
  `c.t.inject.thrift.filters.ThriftClientFilterChain`. Instead of
  `c.t.inject.thrift.modules.FilteredThriftClientModule`, use
  `c.t.inject.thrift.modules.ThriftMethodBuilderClientModule` and use the `idempotent` method on
  `c.t.inject.thrift.ThriftMethodBuilder` to configure backup requests. [8d3ae4cf](https://github.com/twitter/finatra/commit/8d3ae4cfd2c4e335878a1a1fd7225633608b3af6).

* inject-app: `c.t.inject.annotations.FlagImpl` is no longer public and should not be used directly.
  Use `c.t.inject.annotations.Flags#named` instead. [4baf6c9f](https://github.com/twitter/finatra/commit/4baf6c9fed15f2cabff8051b49619792c247ba05)

Fixed

* inject-thrift-client: Fix for duplicate stack client registration. The
  `c.t.inject.thrift.modules.ThriftMethodBuilderClientModule` was incorrectly calling the
  `ThriftMux.client` twice. Once to create a MethodBuilder and once to create a ServicePerEndpoint.
  Now, the ServicePerEndpoint is obtained from the configured MethodBuilder. [37e477ba](https://github.com/twitter/finatra/commit/37e477ba2b1d1be9cfbb0ff698a5ab1a319766e0)

* inject-thrift-client: Convert non-camel case `ThriftMethod` names, e.g., "get_tweets" to
  camelCase, e.g., "getTweets" for reflection lookup on generated `ServicePerEndpoint` interface in
  `c.t.inject.thrift.ThriftMethodBuilder`. [305c2f55](https://github.com/twitter/finatra/commit/305c2f5523722ac26873cdae299335e05521df5a)

### [Scrooge](https://github.com/twitter/scrooge/) ###

- scrooge-generator: Add support for mutually recursive structs. [2a731bbc](https://github.com/twitter/scrooge/commit/2a731bbc49cdf11372cd1d001b9446451dcd84fe)

### [TwitterServer](https://github.com/twitter/twitter-server/) ###

No Changes

### [Util](https://github.com/twitter/util/) ###

Runtime Behavior Changes:

  * util-app: Ensure that any flag parsing error reason is written to `System.err`
    before attempting to print flag usage. In the event that collecting flags for
    the printing the usage message fails, users will still receive a useful message
    as to why flag parsing failed. [31efdaf0](https://github.com/twitter/util/commit/31efdaf028dc5788821822680cf28924ed6a0524)

  * util-core: Promises/Futures now use LIFO execution order for their callbacks
    (was depth-based algorithm before).  [bf47b55f](https://github.com/twitter/util/commit/bf47b55ff45a31bbd541f66257f2244df5c35f5b)

  * util-core: Wrap the function passed to `Closable.make` in a try/catch and return
    a `Future.exception` over any NonFatal exception. [63d1caf3](https://github.com/twitter/util/commit/63d1caf3b86044f6fe8ba7fd02be41d549350800)

Deprecations:

  * util-core: RichU64* APIs are deprecated. Use Java 8 Unsigned Long API instead:
    [0e27f594](https://github.com/twitter/util/commit/0e27f594a510e82555e2a66809d33a2466b0829c)

      - `new RichU64String("123").toU64Long` -> `Long.parseUnsignedInt`
      - `new RichU64Long(123L).toU64HexString` -> `Long.toHexString` (no leading zeros)

### Changelogs ###

* [Finagle 18.3.0][finagle]
* [Util 18.3.0][util]
* [Scrooge 18.3.0][scrooge]
* [TwitterServer 18.3.0][twitterserver]
* [Finatra 18.3.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-18.3.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-18.3.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-18.3.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-18.3.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-18.3.0/CHANGELOG.md
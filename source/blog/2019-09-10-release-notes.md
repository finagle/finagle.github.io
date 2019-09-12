---
layout: post
title: September 2019 Release Notes - Version 19.9.0 🍁
published: true
post_author:
  display_name: Jing Yan
  twitter: jyan
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Embrace a beautiful fall with our freshly baked September release! 🍪

### Highlights

- For users of Finagle HTTP/2 servers, we recommend upgrading to this latest release, as the upgrade to [Netty 4.1.39 release addresses multiple HTTP/2 CVE’s](https://netty.io/news/2019/08/13/4-1-39-Final.html).
- Shout-out to [Martijn Hoekstra](https://github.com/martijnhoekstra) for driving Finagle Scala 2.13.0 cross-building and adding cross-building support in finagle-{core,init,toggle,netty4}. [Future work](https://github.com/twitter/finagle/issues/771) to be continued and any help is appreciated from anyone reading these notes.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Feature

-   finagle-{core,init,toggle,netty4}: Enables cross-build for 2.13.0. [f21a54e0](https://github.com/twitter/finagle/commit/f21a54e0d759e005e089e9996113548078044498)
-   finagle-base-http: Add `None` as a valid SameSite header value. [0c43561a](https://github.com/twitter/finagle/commit/0c43561aa5d30f1fdaf4f80f400539cf1a1a44f0)

#### Breaking API Changes

-   finagle-core: The constructor on `c.t.f.filter.NackAdmissionFilter` used for testing that
    took an `Ema.Monotime` has been removed. [38fae802](https://github.com/twitter/finagle/commit/38fae80296dbc6316b169f30edb7ee3f7a5ac6cb)
-   finagle-core: The `Adddress.ServiceFactory` variant has been promoted from experimental
    status and moved to be properly part of `c.t.f.Address`. [68cf34b8](https://github.com/twitter/finagle/commit/68cf34b8275d5bde04f7652cc7bc281760207fd2)
-   finagle-http: improve performance of c.t.f.http.filter.StatsFilter. This results in two notable
    API changes: 1. There is a `private[filter]` constructor which can take a `() => Long` for
    determining the current time in milliseconds (the existing `StatsFilter(StatsReceiver)`
    constructor defaults to using `Stopwatch.systemMillis` for determining the current time in
    milliseconds. 2. The `protected count(Duration, Response)` method has been changed to
    `private[this] count(Long, Response)` and is no longer part of the public API.
    [f6ce4529](https://github.com/twitter/finagle/commit/f6ce45299c2e014c930be01bdc9e30fdf042ea9f)
-   finagle-partitioning: the hash-based routing that memcached uses has been relocated to a new
    top-level module so that it can be used more broadly across protocols. This results
    in several classes moving to the c.t.f.partitioning package: 1. The `Memcached.param.EjectFailedHost`, `KeyHasher`, and `NumReps` parameters are now
    available under `c.t.f.partitioning.param` 2. The `FailureAccrualException` and `CacheNode` definitions are now in the `c.t.f.paritioning`
    package. 3. The `ZkMetadata` class has moved to `c.t.f.p.zk` and the finagle-serverset module now depends
    on finagle-partitioning.
    [f27073dc](https://github.com/twitter/finagle/commit/f27073dce6064cf732032a1e9f3ca02256633679)

#### Runtime Behavior Changes

-   finagle-http: `c.t.f.http.service.NotFoundService` has been changed to no longer
    use `Request.response`. Use of `Request.response` is deprecated and discouraged.
    [acac9c38](https://github.com/twitter/finagle/commit/acac9c38283d562462eb9456b8121e6ed9855dff)
-   finagle-mysql: Handshaking for the MySQL 'Connection Phase' now occurs as part of session
    acquisition. As part of this change, the
    `com.twitter.finagle.mysql.IncludeHandshakeInServiceAcquisition` toggle
    has been removed and it no longer applies. [cd4877c1](https://github.com/twitter/finagle/commit/cd4877c1f8ab92d48d4ab4d0a0300e672f22898b)
-   finagle: Upgrade to Netty 4.1.39.Final. [001b0940](https://github.com/twitter/finagle/commit/001b094077834583dcfeda445876e3d9dea23358)
-   finagle-http: Enable Ping Failure Detection for MultiplexHandler based HTTP/2 clients. Note that
    the Ping Failure Detection implementation has been removed completely from the
    non-MultiplexHandler based HTTP/2 client. [8af32742](https://github.com/twitter/finagle/commit/8af327429dff08c8508798d945d4755aeae01587)
-   finagle: Added a dependency on Scala Collections Compat 2.1.2. [f21a54e0](https://github.com/twitter/finagle/commit/f21a54e0d759e005e089e9996113548078044498)

#### Bug Fixes

-   finagle-base-http: Removes the `Cookie` header of a `c.t.f.http.Message` whenever its cookie map
    becomes empty. [f9b76a0f](https://github.com/twitter/finagle/commit/f9b76a0f3e861697a13db8fc3bf15026c11f0d13)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

-   finatra-kafka: Add `withConfig` method variant which takes a `Map[String, String]`
    to allow for more complex configurations [60b5d3f1](https://github.com/twitter/finatra/commit/60b5d3f1b7240b81a1007f27e436d8f8e18f3058)

#### Changed

-   finatra: Remove commons-lang as a dependency and replace it with alternatives from stdlib
    when possible. [1c32f9a7](https://github.com/twitter/finatra/commit/1c32f9a79b272bc0910a72bb5c7d7ee5afd0cd45)
-   inject-server: Changed `c.t.inject.server.InMemoryStatsReceiverUtility` to show the expected and
    actual values as part of the error message when metric values do not match. [cefb1749](https://github.com/twitter/finatra/commit/cefb1749dfcfd2947976b87d28f308b067f05590)
-   finatra-kafka-streams: Improve StaticPartitioning error message [ec0f87fd](https://github.com/twitter/finatra/commit/ec0f87fd2727df969bd7024c3c37cdc9b4f2b432)

#### Fixed

-   finatra-http: Support Http 405 response code, improve routing performance for non-constant route
    [983a2c8f](https://github.com/twitter/finatra/commit/983a2c8f5421b182ac62ccf6ddf0e44e1719f46d)
-   inject-app: Update `c.t.inject.app.App` to only recurse through modules once. We currently
    call `TwitterModule#modules` more than once in reading flags and parsing the list of modules
    over which to create the injector. When `TwitterModule#modules` is a function that inlines the
    instantiation of new modules we can end up creating multiple instances causing issues with the
    list of flags defined in the application. This is especially true in instances of `TwitterModule`
    implemented in Java as there is no way to implement the trait `TwitterModule#modules` method as a
    eagerly evaluated value. We also don't provide an ergonomic method for Java users to define
    dependent modules like we do in apps and servers via `App#javaModules`. Thus we also add a
    `TwitterModule#javaModules` function which expresses a better API for Java users. [8d0a59fa](https://github.com/twitter/finatra/commit/8d0a59fa49b7bff3090cd7161b61c3a6dd8242a6)

### [Util](https://github.com/twitter/util/) ###

#### Runtime Behavior Changes

-   util-app: Better handling of exceptions when awaiting on the `c.t.app.App` to close at
    the end of the main function. We `Await.ready` on `this` as the last step of
    `App#nonExitingMain` which can potentially throw a `TimeoutException` which was previously
    unhandled. We have updated the logic to ensure that `TimeoutException`s are handled accordingly.
    [b17297c7](https://github.com/twitter/util/commit/b17297c731d7f693f0284a2d0d11e23635eff7e2)
-   util: Upgrade to Scala Collections Compat 2.1.2. [d4117162](https://github.com/twitter/util/commit/d411716220b4c8a747fbd779201922e4f01ac599)

#### Breaking API Changes

-   util-core: BoundedStack is unused and really old code. Delete it. [eeb0e947](https://github.com/twitter/util/commit/eeb0e947f9456075af34209cd09dfffe04cf0a58)
-   util-logging: `com.twitter.logging.ScribeHandler` and `com.twitter.logging.ScribeHandlers` have
    been removed. Users are encouraged to use slf4j for logging. However, if a util-logging integrated
    ScribeHandler is still required, users can either build their own Finagle-based scribe client as
    in `ScribeRawZipkinTracer` in finagle-zipkin-scribe, or copy the old `ScribeHandler`
    implementation directly into their code. [f4e56599](https://github.com/twitter/util/commit/f4e565993b4bbc6e458674fd332259a9b6ac4e48)

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   scrooge-generator: Introduce i8 type identifier as an alias for byte type. [03d84aea](https://github.com/twitter/scrooge/commit/03d84aea40c9edf87e8c69090c5077b8779fa655)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

No Changes


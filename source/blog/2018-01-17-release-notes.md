---
layout: post
title: 📆 January 2018 Release Notes - Version 18.1.0
published: true
post_author:
  display_name: Christopher Coco
  twitter: cacoco
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Time to turn the calendar to a new year and a new release -- our January release is here!

[Finagle 18.1.0][finagle], [Finatra 18.1.0][finatra], [Scrooge 18.1.0][scrooge], [TwitterServer 18.1.0][twitterserver], and [Util 18.1.0][util].

### [Finagle](https://github.com/twitter/finagle/) ###

New Features:

  * finagle-core: `FailureDetector` has a new method, `onClose`, which provides
    a Future that is satisfied when the `FailureDetector` marks a peer as Closed.
    [186f0949](https://github.com/twitter/finagle/commit/186f094957b43a9bc4a0e1a5abb6adb95e26fee8)

  * finagle-core: Introduce trace logging of requests as they flow through a
    Finagle client or server. These logs can be turned on at runtime by setting
    the "com.twitter.finagle.request.Logger" logger to trace level.
    [203fed55](https://github.com/twitter/finagle/commit/203fed55335633173b2a36b98c30c55336baaf3a)

  * finagle-http2: HTTP/2 clients now expose the number of currently opened streams under
    the `$client/streams` gauge. [add0050e](https://github.com/twitter/finagle/commit/add0050e29ff466c8f94dfa48023a7618c8564df)

  * finagle-http2: HTTP/2 servers now expose the number of currently opened streams under
    the `$server/streams` gauge. [ed6800a3](https://github.com/twitter/finagle/commit/ed6800a3c7b8f01c31a963377bbe5b0147ffd6cc)

  * finagle-memcached: By default, the Memcached client now creates two connections
    to each endpoint, instead of 4. [1c5d9eac](https://github.com/twitter/finagle/commit/1c5d9eacd8bacf3ecc6007f17769854cd8a630e0)

  * finagle-redis: Add support for redis Geo Commands. [d32d1236](https://github.com/twitter/finagle/commit/d32d123665fab5bada54a653029d60a88a29b1a6) based on the PR
    https://github.com/twitter/finagle/pull/628 written by Mura-Mi [https://github.com/Mura-Mi]

  * finagle-thrift: Add `c.t.f.thrift.service.ThriftServiceBuilder` and
    `c.t.f.thrift.service.ReqRepThriftServiceBuilder` for backwards compatibility
    of creating higher-kinded method-per-endpoint clients. [f61b6f99](https://github.com/twitter/finagle/commit/f61b6f99c7d108b458d5adcb9891ff6ddda7f125)

  * finagle-core: `c.t.f.http.MethodBuilder` and `c.t.f.thriftmux.MethodBuilder` now
    expose `idempotent` and `nonIdempotent` methods, which can be used to configure
    retries and the sending of backup requests. [2c1105e5](https://github.com/twitter/finagle/commit/2c1105e5e57abf5048f991339f9c54f2570fa7ea)

Bug Fixes:

  * finagle-mysql: Fix a bug with transactions where an exception during a rollback
    could leave the connection with a partially committed transaction. [4b76bfc2](https://github.com/twitter/finagle/commit/4b76bfc2fc86d4b713edb382e0cf38ac79371542)

  * finagle-toggle: `c.t.f.toggle.Toggle`s are independent; that is, applying the same value to
    two different toggles with the same fraction will produce independent true/false
    values. [8ef6acb1](https://github.com/twitter/finagle/commit/8ef6acb144c57d64dae78d32df724623c29c36e5)

Runtime Behavior Changes:

  * finagle-core, finagle-netty4: When creating engines, SslClientEngineFactories now use
    `SslClientEngineFactory.getHostString` instead of `SslClientEngineFactory.getHostname`.
    This no longer performs an unnecessary reverse lookup when a hostname is not supplied
    as part of the `SslClientConfiguration`.  [d05d1299](https://github.com/twitter/finagle/commit/d05d1299032673d03b13b32afe668c83de3fd65c)

  * finagle-http2: Supplies a dependency on io.netty.netty-tcnative-boringssl-static,
    which adds support for ALPN, which is necessary for encrypted http/2.  To use a
    different static ssl dependency, exclude the tcnative-boringssl dependency and
    manually depend on the one you want to use.  [246be7e5](https://github.com/twitter/finagle/commit/246be7e560e5089396335462b0585214e2f75983)

Breaking API Changes:

  * finagle-base-http, finagle-http: Removed Apache Commons Lang dependency,
    `org.apache.commons.lang3.time.FastDateFormat` now is `java.time.format.DateTimeFormatter`.
    [8cd6a882](https://github.com/twitter/finagle/commit/8cd6a882bf560bf78594057a756d2dcaa4b0d7d5)

  * finagle-base-http: `c.t.f.http.Message.headerMap` is now an abstract method.
    [24e74e52](https://github.com/twitter/finagle/commit/24e74e5270d0f3c31b50cc1d39181a3908a2ac67)

  * finagle-core: `c.t.f.ssl.server.SslServerSessionVerifier` no longer uses the unauthenticated
    host information from `SSLSession`. [559ae4ad](https://github.com/twitter/finagle/commit/559ae4ad3eb6bae4c2f885fb3149b492c6bf46a0)

  * finagle-memcached: `ConcurrentLoadBalancerFactory` was removed and its behavior
    was replaced by a Stack.Param inside finagle-core's `LoadBalancerFactory`.
    [502a91d5](https://github.com/twitter/finagle/commit/502a91d5f927c8c60f02e3d75e87262f407ae068)

  * finagle-thrift, finagle-thriftmux: Remove `ReqRep` specific methods. Since the "ReqRep"
    builders are now subclasses of their non-"ReqRep" counterparts their is no longer a
    need to expose "ReqRep" specific methods. [9737ead8](https://github.com/twitter/finagle/commit/9737ead820eef60896f562b13881c6f8cd9bb67e)

Deprecations:

  * finagle-exp: `c.t.f.exp.BackupRequestFilter` has been deprecated. Please use
    `c.t.f.client.BackupRequestFilter` instead. [3326d2fd](https://github.com/twitter/finagle/commit/3326d2fd9435c6e34ba61e2f0b100ea447cbadbe)

  * finagle-http: `c.t.f.http.Request.multipart` has been deprecated.
    Use `c.t.f.http.exp.MultipartDecoder` instead. [a205bd20](https://github.com/twitter/finagle/commit/a205bd207c29e4a6d5cf1273db4ea277f56feda8)

### [Finatra](https://github.com/twitter/finatra/) ###

Added:

  * finatra-thrift: Add support for building all types of Finagle Thrift clients to
    the underlying embedded TwitterServer with the `c.t.finatra.thrift.ThriftClient`
    test utility. See: https://twitter.github.io/scrooge/Finagle.html#creating-a-client
  [  47f7f6c7](https://github.com/twitter/finatra/commit/47f7f6c71fef30884d445c8ea10666a0232d0ede)

  * finatra-jackson: Added support to finatra/jackson for deserializing `com.twitter.util.Duration`
    instances from their String representations. [9e6576c9](https://github.com/twitter/finatra/commit/9e6576c99800073cabd8be7d869abd64890e44d5)

Changed:

  * finatra-http: Change visibility of internal class `c.t.finatra.http.internal.marshalling.RequestInjectableValues`
    to be correctly specified as private to the `http` package. [712edf91](https://github.com/twitter/finatra/commit/712edf91c0361fd9907deaef06e0bd61384f6a7e)

Fixed:

  * finatra-http: Ensure we close resources in the `ResponseBuilder`. Addresses
    [#440](https://github.com/twitter/finatra/issues/440). [dafe7259](https://github.com/twitter/finatra/commit/dafe7259b2ec3d89641425e3eca8af56a869b4e3)

Closed:

  * [#440](https://github.com/twitter/finatra/issues/440)


### [Scrooge](https://github.com/twitter/scrooge/) ###

  * scrooge-generator: Update `c.t.fingale.thrit.service.MethodPerEndpointBuilder`
    to build `MethodPerEndpoint` types. Add new `ThriftServiceBuilder` for
    building the higher-kinded form from a `ServicePerEndpoint`. Users should
    prefer using the `MethodPerEndpointBuilder`. [08b25e3d](https://github.com/twitter/scrooge/commit/08b25e3d99cbbb7eece52e7589f2de002aeecb5f)

  * scrooge-generator: Add more metadata to generated java objects [46dd949c](https://github.com/twitter/scrooge/commit/46dd949c0d6e3859633d8e9cc572eea6fa4f6676)
    Includes:
      * struct and field annotations from the idl files
      * which fields have default values
      * which field values of TType.STRING are actually binary fields

  * scrooge: Add support for `scrooge.Request` and `scrooge.Response`
    types in generated `ThriftMethod` code. [80bfa731](https://github.com/twitter/scrooge/commit/80bfa731310f70bbe2ef8bae974e06bd43b3041d)

### [TwitterServer](https://github.com/twitter/twitter-server/) ###

  * No changes

### [Util](https://github.com/twitter/util/) ###

New Features:

  * util-security: Added `c.t.util.security.X509CrlFile` for reading
    Certificate Revocation List PEM formatted `X509CRL` files.
    [32d8cc8a](https://github.com/twitter/util/commit/32d8cc8ac4fc4c1f9417df6ec6da392291eb4759)



### Changelogs ###

* [Finagle 18.1.0][finagle]
* [Util 18.1.0][util]
* [Scrooge 18.1.0][scrooge]
* [TwitterServer 18.1.0][twitterserver]
* [Finatra 18.1.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-18.1.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-18.1.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-18.1.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-18.1.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-18.1.0/CHANGELOG.md
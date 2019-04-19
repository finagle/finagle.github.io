---
layout: post
title: April 2019 Release Notes - Version 19.4.0
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

### Highlights

- After several years of continuous effort decoupling Finagle from Netty 3, we've finally got to the
  point the dependency can be dropped. As of this release, there is no Netty 3 artifacts on the
  classpath.
- Finagle HTTP now transmits trailing headers (trailers).
- Finagle HTTP has become more strict with headers validation and is now in compliance with
  RFC7230.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-core: Make `maxDepth` in `Namer` configurable. [03cc3197](https://github.com/twitter/finagle/commit/03cc319706182eb86ad1f4eb54041894a2599528)
    -   namerMaxDepth in Namer now configurable through a global flag (`namerMaxDepth`)
-   finagle-core: The newly renamed `SslSessionInfo` is now public. It is
    intended for providing information about a connection's SSL/TLS session.
    [811fe004](https://github.com/twitter/finagle/commit/811fe004a835620c834f2cac87dc69fa8b347d35)
-   finagle-core: Added the `c.t.finagle.DtabFlags` trait which defines a Flag and function for
    appending to the "base" `c.t.finagle.Dtab` delegation table. [675630df](https://github.com/twitter/finagle/commit/675630dfaace1a0f06104c4ac8719a581fa44851)
-   finagle-http: Finagle HTTP implementation now supports trailing headers (trailers). Use
    `c.t.f.http.Message.trailers` to access trailing headers on a fully-buffered message
    (isChunked == false) or `c.t.f.http.Message.chunkReader` on a message with chunked payload
    (isChunked == true). [351c43c1](https://github.com/twitter/finagle/commit/351c43c15861f644b77ca3c5e627a0225001c615)
-   finagle-http,thriftmux: Added tracing annotations to backup requests. [48f54e82](https://github.com/twitter/finagle/commit/48f54e82c2df35a5546a55c889286e99622b8b44)
    -   Binary annotation `srv/backup\_request\_processing`, when servers are processing backup requests.
-   finagle-http: Added new server metrics to keep track of inbound requests that are rejected due to
    their headers containing invalid characters (as seen by RFC-7230): `rejected_invalid_header_names`
    and `rejected_invalid_header_values`. [41bd061a](https://github.com/twitter/finagle/commit/41bd061a4b8afbd170c6bc108eb7de2b77a298d2)
-   finagle-http: Added stats of the duration in milliseconds of request/response streams:
    `request_stream_duration_ms` and `response_stream_duration_ms`. They are enabled by using
    `.withHttpStats` on `Http.Client` and `Http.Server` [916f4a26](https://github.com/twitter/finagle/commit/916f4a2683aef99bc5e0c29bbdad0523cebb7bc1)
-   finagle-mysql: A new toggle, `com.twitter.finagle.mysql.IncludeHandshakeInServiceAcquisition`, has
    been added. Turning on this toggle will move MySQL session establishment (connection phase) to be
    part of service acqusition. [fe4d8919](https://github.com/twitter/finagle/commit/fe4d8919922115cf5aa4d4c03305b04c89abb362)

#### Runtime Behavior Changes

-   finagle-core: Client-side nacking admission control now defaults on. See the documentation
    on `c.t.f.filter.NackAdmissionFilter` for details. This can be disabled by setting the
    global flag, `com.twitter.finagle.client.useNackAdmissionFilter`, to `false`.
    [aa36f56b](https://github.com/twitter/finagle/commit/aa36f56b7e47eb2af8fadca83f204fa57a38603e)
-   finagle-core: `LatencyCompensation` now applies to service acquisition. [1ec020a5](https://github.com/twitter/finagle/commit/1ec020a5b80b35f1d0158aac181b14d7942aaa66)
-   finagle-http: HTTP headers validation on the outbound path is now in compliance with RFC7230.
    [5b2e9f95](https://github.com/twitter/finagle/commit/5b2e9f9540b865983e060b65cb7dae83cbf93a22)
-   finagle-netty4: Netty's reference leak tracking now defaults to disabled.
    Set the flag `com.twitter.finagle.netty4.trackReferenceLeaks` to `true` to enable.
    [f63d7f7a](https://github.com/twitter/finagle/commit/f63d7f7a28157318f98ec8ca44821856aa7f550f)

#### Breaking API Changes

-   finagle: Dropped a dependency on Netty 3 [03c773a5](https://github.com/twitter/finagle/commit/03c773a506aa838c562e37a3e586fb862cfa1a6a):

    -   finagle-netty3 sub-project has been removed
    -   finagle-http-cookie sub-project has been removed
    -   `c.t.f.http.Cookie` no longer takes Netty's `DefaultCookie` in the constructor

-   finagle-core: The `peerCertificate` methods of `c.t.f.t.TransportContext` and `c.t.f.p.PushChannelHandle`
    have been replaced with the more robust `sslSessionInfo`. Users looking for just the functional
    equivalence of peerCertificate can use `sslSessionInfo.peerCertificates.headOption`.
    [dc4bfbcf](https://github.com/twitter/finagle/commit/dc4bfbcf226adc7b1a5f52366148f8ac36690a71)

-   finagle-core: The `com.twitter.finagle.core.UseClientNackAdmissionFilter` toggle has been replaced
    by a global flag, `com.twitter.finagle.client.useNackAdmissionFilter`.
    [aa36f56b](https://github.com/twitter/finagle/commit/aa36f56b7e47eb2af8fadca83f204fa57a38603e)

-   finagle-thrift: Allow users to specify `stringLengthLimit` and `containerLengthLimit`
    [233150a9](https://github.com/twitter/finagle/commit/233150a9f20dca50ed75c41b80f351674c17a862)
    -   method parameter readLength in `com.twitter.finagle.thrift.Protocols#binaryFactory` renamed to
        `stringLengthLimit` to reflect usage
    -   method parameter `containerLengthLimit` added to `com.twitter.finagle.thrift.Protocols#binaryFactory`

### [Finatra](<https://github.com/twitter/finatra/>) ###

#### Added

-   inject-server: Add `globalFlags` argument to `EmbeddedTwitterServer`, which will allow for scoping
    a `c.t.a.GlobalFlag` property change to the lifecycle of the underlying TwitterServer, as a
    `c.t.a.GlobalFlag` is normally scoped to the JVM/process. This change is also reflected in
    `EmbeddedHttpServer` and `EmbeddedThriftServer` constructors. [38a3180a](https://github.com/twitter/finatra/commit/38a3180a5d61d12fb1546dd572f075cfd2fb3dbf)
-   inject-utils: add `toOrderedMap` implicit conversion for `java.util.Map` [1686420c](https://github.com/twitter/finatra/commit/1686420c58506eddf3ef2fb4e75d8007bc27ee2e)
-   finatra-kafka-streams: Add flag `rocksdb.manifest.preallocation.size` with default value `4.megabytes`
    to `c.t.f.k.c.RocksDbFlags` and set value in `c.t.f.k.c.FinatraRocksDBConfig`. [0cac9785](https://github.com/twitter/finatra/commit/0cac9785bc90c421e49a7c0db08066cd0d7a61b9)
-   finatra-http: Add `commaSeparatedList` boolean parameter to `QueryParams`, for parsing comma-separated
    query parameters into collection types. [0ae425a2](https://github.com/twitter/finatra/commit/0ae425a2f50d0f764f39c80fddd8e11ee0f4bf8e)

#### Changed

-   finatra-kafka: Upgraded kafka libraries from 2.0.0 to 2.2.0 [9d22ee7e](https://github.com/twitter/finatra/commit/9d22ee7ea99f9db605882b90b0b6052e841e60ec)
    -   [Kafka 2.0.1 Release Notes](https://archive.apache.org/dist/kafka/2.0.1/RELEASE_NOTES.html)
    -   [Kafka 2.1.0 Release Notes](https://archive.apache.org/dist/kafka/2.1.0/RELEASE_NOTES.html)
    -   [Kafka 2.1.1 Release Notes](https://archive.apache.org/dist/kafka/2.1.1/RELEASE_NOTES.html)
    -   [Kafka 2.2.0 Release Notes](https://archive.apache.org/dist/kafka/2.2.0/RELEASE_NOTES.html)
-   finatra-thrift: Removed `c.t.finatra.thrift.exceptions.FinatraThriftExceptionMapper`,
    `c.t.finatra.thrift.filters.ClientIdAcceptlistFilter`,
    `c.t.finatra.thrift.modules.ClientIdAcceptlistModule`,
    `c.t.finatra.thrift.filters.ClientIdWhitelistFilter`,
    `c.t.finatra.thrift.modules.ClientIdWhitelistModule`,
    and the finatra/finatra\_thrift\_exceptions.thrift IDL. [caed5ec8](https://github.com/twitter/finatra/commit/caed5ec8c0aa38381853d8efb3a6717b78670dbc)
-   finatra-thrift: Constructing a ThriftRouter now requires serverName. [dc357fd8](https://github.com/twitter/finatra/commit/dc357fd8361f75e4831f464835581ce9ab38cdee)
-   finatra-examples: Updated `StreamingController` to use `Reader` instead of `AsyncStream`
    [3d5e3282](https://github.com/twitter/finatra/commit/3d5e3282cd860a1b4fa5b1c4a608098f97ca300a)
-   finatra-kafka-streams: Implement `FinatraKeyValueStore` as custom store. [cd38ddf6](https://github.com/twitter/finatra/commit/cd38ddf699872c48e4bbce2cfbda14c1a98d5864)
-   finatra-thrift: Constructing a `ThriftRouter` now requires `c.t.f.StackTransformer`.
    [a96312d2](https://github.com/twitter/finatra/commit/a96312d2fb3ee53ba56b2eda914245ef05c89c02)

#### Fixed

-   finatra-kafka: Ensure that `EmbeddedKafka` implementation of `beforeAll()` makes
    call to `super.beforeAll()` so hooks registered in super class get executed. [9404b28f](https://github.com/twitter/finatra/commit/9404b28f4477387872140a6d153196887213bb70)
-   finatra-kafka-streams: `FinatraTransformer.timerStore` config object references immutable
    map which causes exception thrown if user code calls `AbstractStoreBuilder.withLoggingDisabled`.
    Fixed `FinatraTransformer.timerStore` to convert from immutable map to mutable map before
    forwarding config object to kafka library. [827c4612](https://github.com/twitter/finatra/commit/827c46126dddc271e8b29b80f6275da3d852cb4d)

### [Twitter Server](<https://github.com/twitter/twitter-server/>) ###

-   Remove deprecated uses of `c.t.server.ShadowAdminServer`. [e94e8300](https://github.com/twitter/twitter-server/commit/e94e83006d24b26c63f279fa72ab22a95d406f4a)
-   Mix in the `c.t.finagle.DtabFlags` to allow servers to append to the "base" `c.t.finagle.Dtab`
    delegation table. Users can now call `c.t.finagle.DtabFlags\#addDtabs()` when they want to append
    the parsed `Flag` value to the `Dtab.base` delegation table. Users should note to only call this
    method _after_ Flag parsing has occurred (which is after **init** and before **premain**).
    We also update the `c.t.server.handler.DtabHandler` to always return a proper JSON response of
    the currently configured `c.t.finagle.Dtab.base`. [a00e3942](https://github.com/twitter/twitter-server/commit/a00e3942d95fd0a0e29e14b47fa0997c8e6b3799)

### [Util](<https://github.com/twitter/util/>) ###

-   util-app: Improve usage of `Flag.let` by providing a `Flag.letParse` method
    [0d9dded3](https://github.com/twitter/util/commit/0d9dded32b931d6fff7335b5f4c573c474b5b65a)

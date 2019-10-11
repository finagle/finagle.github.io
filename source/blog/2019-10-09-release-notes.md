---
layout: post
title: October 2019 Release Notes - Version 19.10.0 🌕
published: true
post_author:
  display_name: Christopher Coco
  twitter: cacoco
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

In preparation for Halloween 👻 at the end of the month, we are very happy to announce 
our October 🕷️ release: no tricks 🎃 -- all treats 🍬.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-partition: Enables cross-build for 2.13.0. [89f06885](https://github.com/twitter/finagle/commit/89f06885140ee186f7b8d7ff15169a7a3f8b676b)
-   finagle-exception: Enables cross-build for 2.13.0. [d90ae646](https://github.com/twitter/finagle/commit/d90ae6462db9a7f2a5e0e186f04ae1a6b79f4067)
-   finagle-exp: Enables cross-build for 2.13.0. [32bc9f48](https://github.com/twitter/finagle/commit/32bc9f48c3c4b99b3b847134ac315797bd80a643)
-   finagle-mysql: Enables cross-build for 2.13.0. [ef31c99b](https://github.com/twitter/finagle/commit/ef31c99bb4e6ef0072c8eba09736c781b5d81752)
-   finagle-{mux,thrift,thrift-mux}: Enables cross-build for 2.13.0. [47ee31fd](https://github.com/twitter/finagle/commit/47ee31fd5bf93b49aa304dfef6aae39abdb9be17)
-   finagle-redis: Enables cross-build for 2.13.0. [d90ae646](https://github.com/twitter/finagle/commit/d90ae6462db9a7f2a5e0e186f04ae1a6b79f4067)
-   finagle-tunable: Enables cross-build for 2.13.0. [69ded534](https://github.com/twitter/finagle/commit/69ded534047f1115ad46de76bf293ab747d67ea5)
-   finagle-grpc-context: Enables cross-build for 2.13.0. [65963f58](https://github.com/twitter/finagle/commit/65963f58bab0a4ed634beaf2df4905db2a3422ef)
-   finagle-thrift: Pass a factory to create a TReusableBuffer as the parameter of a finagle client
    to allow multiple clients share one TReusableBuffer. [05b2ec71](https://github.com/twitter/finagle/commit/05b2ec71b8e9c680102ea9df6bafe3e670aa264f)

#### Runtime Behavior Changes

-   finagle-http2: H2ServerFilter will no longer swallow exceptions that fire via
    exceptionCaught in the Netty pipeline. PHAB\_ID=D369185
-   finagle-http: Remove legacy HTTP/2 client implementation and make the MultiplexHandler-based
    implementation the default HTTP/2. [b6d0aa19](https://github.com/twitter/finagle/commit/b6d0aa19878f9faf990c09ab30c067479dd56c24)

#### Breaking API Changes

-   finagle-core: c.t.f.l.FailureAccrualFactory's didMarkDead() changed to didMarkDead(Duration).
    The Duration is the length of time the endpoint is marked dead. [fe2f43a3](https://github.com/twitter/finagle/commit/fe2f43a312aafc2dd8ab6889a1258e795d9653be)

#### Bug Fixes

-   finagle-mux: Mux now properly propagates Ignorable failures multiple levels for superseded
    backup requests. This allows for more accurate success rate metrics for downstream services,
    when using backup requests.
    [21b181e8](https://github.com/twitter/finagle/commit/21b181e89cc1d3d965fb30ba635b48111b0f4c20)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed

-   finatra-jackson: Update jackson reflection to use org.json.reflect instead of
    custom reflection. This enables support for parsing case classes defined over generic
    types, e.g., `case class Page[T](data: T)`. As a result of this change, use of lazy val
    for trait members which are mixed into case classes for use in deserialization is no
    longer supported. This addresses issue #480. [83d3ed6d](https://github.com/twitter/finatra/commit/83d3ed6d819f77421caa72764ed8c46467654101)

#### Fixed

-   finatra-jackson: Add support for parsing of case classes defined over generic types
    (even nested, and multiple), e.g., `case class Page[T, U](data: List[T], column: U)`.
    Fixes issue #408. [83d3ed6d](https://github.com/twitter/finatra/commit/83d3ed6d819f77421caa72764ed8c46467654101)
-   finatra-kafka: Sanitize topic name in MonitoringConsumer stats scope
    [0df09c6b](https://github.com/twitter/finatra/commit/0df09c6b540a2e2d3cc5038b628f97eee32d5237)
-   inject-server: Fix printing of all stats from the underlying InMemoryStatsReceiver in
    the eventually loop for stat assertion. Address finatra/kafka test logging for
    finatra/kakfa-streams/kafka-streams and finatra/kafka. [32833de1](https://github.com/twitter/finatra/commit/32833de11c91eb79038298cf65f8e03769271774)
-   inject-logback: A NullReferenceException could be thrown during metrics
    collection due to an incorrect logback.xml configuration. This has been fixed.
    [82f0382f](https://github.com/twitter/finatra/commit/82f0382f17ddebf64cb4e12c1ae55642fa8ed04c)

### [Util](https://github.com/twitter/util/) ###

#### Runtime Behavior Changes

-   util-core: When a computation from FuturePool is interrupted, its promise is
    set to the interrupt, wrapped in a j.u.c.CancellationException. This wrapper
    was introduced because, all interrupts were once CancellationExceptions. In
    `RB_ID=98612`, this changed to allow the user to raise specific exceptions as
    interrupts, and in the aid of compatibility, we wrapped this raised exception
    in a CancellationException. This change removes the wrapper and fails the
    promise directly with the raised exception. This will affect users that
    explicitly handle CancellationException. [9daad3d9](https://github.com/twitter/util/commit/9daad3d9ef7de09d52578fd3e131dea24bd1ce60)

#### Bug Fixes

-   util-core: Fixed bug in c.t.io.Reader.framed where if the framer didn't emit a List the
    emitted frames were skipped. [aedc943e](https://github.com/twitter/util/commit/aedc943eb2b53944c6371d2e7a6428260d0def9f)
-   util-hashing: Fix a bug where partitionIdForHash was returning incosistent values w.r.t
    entryForHash in KetamaDistributor. [c66080b6](https://github.com/twitter/util/commit/c66080b665d25334bcf6cca75ea3f02402342511)

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   scrooge-generator: Make isset BitSet final in Java generated thrift classes. [19ca055e](https://github.com/twitter/scrooge/commit/19ca055efbd0f63e9ebe763127cf76ba1c71f716)
-   scrooge-generator: Return Nil for exceptionFields when no exceptions declared in Scala service. [e6c44930](https://github.com/twitter/scrooge/commit/e6c44930875bdf763616e46091a5c5bedf1b25aa)
-   scrooge-generator: Use empty instances as defaults for Seq, Map, Set for Scala generated code. [8904ba89](https://github.com/twitter/scrooge/commit/8904ba899a84276cdadeb33dbee533d2e9276e38)
-   scrooge-generator: Use wrapper class valueOf in apachejavagen's getFieldValue. [8d02a4f3](https://github.com/twitter/scrooge/commit/8d02a4f337132bf16527a7e772a7f2866de20091)
-   scrooge-linter: Warn when function names are reserved words. Add support for reserved
    words in Javascript and Go. [ca2ae718](https://github.com/twitter/scrooge/commit/ca2ae718ca224434631e8b2809242e6bb5788ffa)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

No Changes

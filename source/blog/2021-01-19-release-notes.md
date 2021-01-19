---
layout: post
title: ❄️ January 2021 Release Notes - Version 21.1.0
published: true
post_author:
  display_name: Christopher Coco
  twitter: cacoco
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

A new year, a new release! 🎆

### [Scrooge](https://github.com/twitter/scrooge/)

-   scrooge: Scrooge uses better size estimate for Map/Set containers in read() to improve 
    performance in Java. [b1ebce81](https://github.com/twitter/scrooge/commit/b1ebce819e8f7f4ee5c941d29cd661d6c2a2e4ed)

### [Finagle](https://github.com/twitter/finagle/)

#### New Features

-   finagle-core: Add clnt/&lt;FilterName&gt;\_rejected annotation to filters that may throttle requests,
    including c.t.finagle.filter.NackAdmissionFilter and c.t.finagle.filter.RequestSemaphoreFilter.
    [66857683](https://github.com/twitter/finagle/commit/66857683c6b8ae2f16dde53f28c52c11b262d16e)
-   finagle-http: Record http-specific annotations including http.status\_code and
    http.method. See details at
    <https://github.com/open-telemetry/opentelemetry-specification/tree/master/specification/trace>
    [78d93fde](https://github.com/twitter/finagle/commit/78d93fde6cdf18534d6990ec7c8d4e97260e5c57)

#### Bug Fixes

-   finagle-core: Fix wraparound bug in Ring.weight, as reported by @nvartolomei [c4dc4fdc](https://github.com/twitter/finagle/commit/c4dc4fdc5beedec031a5af25a512e5319843f02b)
-   finagle-mysql: Update the UTF8 character set to cover those added in MySQL 8.
    [25e581bb](https://github.com/twitter/finagle/commit/25e581bb9106de16d027f709e153912585b5b0a5)
-   finagle-thriftmux: Fixed a bug where connections were not established eagerly in ThriftMux
    MethodBuilder even when eager connections was enabled. [ec67d48a](https://github.com/twitter/finagle/commit/ec67d48a9c8e9bb3db00cf9e921f438b88a4e8e0)

#### Runtime Behavior Changes

-   finagle-mysql: Don't use the full query when adding tracing annotations. [b215d255](https://github.com/twitter/finagle/commit/b215d25593e105f4dea8134cce6a902045199b21)

### [TwitterServer](https://github.com/twitter/twitter-server/)

-   Add separator\_char field to the top level of the Metrics Metadata endpoint and bump the
    endpoints version number to 2.1. [38a437b8](https://github.com/twitter/twitter-server/commit/38a437b832f437bca18983ad9527190054618eae)

### [Finatra](https://github.com/twitter/finatra/)

#### Changed

-   kafka: Enables cross-build for 2.13.1. Note that kafka 2.5 is bundled with scala 2.13+
    and kafka 2.2 is bundled with scala 2.12-. [7bdba713](https://github.com/twitter/finatra/commit/7bdba713151180b21eb485c16b7e255b1368c679)
-   kafkaStreams: Enables cross-build for 2.13.1. Note that kafka 2.5 is bundled with
    scala 2.13+ and kafka 2.2 is bundled with scala 2.12-. [7bdba713](https://github.com/twitter/finatra/commit/7bdba713151180b21eb485c16b7e255b1368c679)
-   benchmarks: Enables cross-build for 2.13.1. [c811e18a](https://github.com/twitter/finatra/commit/c811e18ad3a86a50946de4600ef55bdf6208770f)
-   inject-thrift-client-http-mapper: Enables cross-build for 2.13.1. [7c3f13ba](https://github.com/twitter/finatra/commit/7c3f13bab13ff5ced5c595c73067ffc6f855ed7c)
-   http-mustache: Enables cross-build for 2.13.1. [7c3f13ba](https://github.com/twitter/finatra/commit/7c3f13bab13ff5ced5c595c73067ffc6f855ed7c)
-   thrift: (BREAKING API CHANGE) Removed JavaThriftRouter.add(controller, protocolFactory) method.
    Use AbstractThriftServer.configureThriftServer to override Thrift-specific stack params
    (including Thrift.param.ProtocolFactory). [bc34aa7b](https://github.com/twitter/finatra/commit/bc34aa7bc191989f45611be946770f94e0e87ca9)
-   finatra-http: Remove deprecated c.t.finatra.http.response.StreamingResponse.
    Use c.t.finatra.http.streaming.StreamingResponse instead. [851a06a5](https://github.com/twitter/finatra/commit/851a06a5aa889269b73654ae5e283bad08f5a633)
-   finatra-kafka-streams: (BREAKING API CHANGE) Changed the delayWithStore DSL call to ensure that
    the store name is consistent across shards. Requires a new storeName parameter to allow
    for multiple delays in a single topology. [7373b478](https://github.com/twitter/finatra/commit/7373b478e9a184d13d7fe353b7edf9216f812d7a)

#### Fixed

-   finatra-kafka-streams: Renamed implicit Kafka Streams DSL classes in order to
    permit multiple DSL extensions to be used in the same Kafka Streams topology.
    [b48d4c5c](https://github.com/twitter/finatra/commit/b48d4c5c04244644263446d83ab98bc30896869f)
-   thrift: Fixed a bug where Thrift stack params (i.e., protocol factory) that are passed to
    AbstractThriftServer.configureThriftServer are ignored in JavaThriftRouter.
    [bc34aa7b](https://github.com/twitter/finatra/commit/bc34aa7bc191989f45611be946770f94e0e87ca9)


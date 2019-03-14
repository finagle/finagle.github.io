---
layout: post
title: March 2019 Release Notes - Version 19.3.0 🦁
published: true
post_author:
  display_name: Ian Bennett
  twitter: enbnt
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Spring has almost sprung, so take a look at all that we have done!

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-core: Added tracing annotations to backup requests. [5201f623](https://github.com/twitter/finagle/commit/5201f6237ce5185c4208d5945b33813b47507570)
    -   Timestamped annotation "Client Backup Request Issued"
    -   Timestamped annotation "Client Backup Request Won" or "Client Backup Request Lost"
    -   Binary annotation "clnt/backup\_request\_threshold\_ms", with the current value of the latency threshold, in milliseconds
    -   Binary annotation "clnt/backup\_request\_span\_id", with the span id of the backup request

#### Breaking API Changes

-   finagle-core: Deprecated multi-param legacy tls methods have been removed in
    c.t.f.param.ServerTransportParams and c.t.f.builder.ServerBuilder. Users should migrate
    to using the tls(SslServerConfiguration) method instead. [ca646bd8](https://github.com/twitter/finagle/commit/ca646bd850fae230f6d35a6aeb67be00679ccd97)

#### Runtime Behavior Changes

-   finagle-core: The tracing annotations from MkJvmFilter have been enhanced. [0586f657](https://github.com/twitter/finagle/commit/0586f657cdba87bbfddbb3f171d646139ec20fdf)
-   Timestamped annotations "GC Start" and "GC End" for each garbage collection
    event that occurred during the request.
-   Binary annotation "jvm/gc\_count", with the total number of garbage collection
    events that occurred during the request.
-   Binary annotation "jvm/gc\_ms", with the total milliseconds of garbage collection
    events that occurred during the request.

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

-   finatra-kafka: FinagleKafka clients pass correct deadline for close to
    underlying Kafka clients. [6e579e60](https://github.com/twitter/finatra/commit/6e579e60df4ec515e5157055d884f104f15c9bbd)
-   finatra-kafka-streams: (BREAKING API CHANGE) Create flags for common consumer and producer
    configs. KafkaFlagUtils\#kafkaDocumentation and getKafkaDefault are no longer public methods.
    [9ca7eac5](https://github.com/twitter/finatra/commit/9ca7eac5173450862af8ec08a292a70db942769c)
-   finatra-kafka: Added support to fetch end offset for a given partition. [2053b76a](https://github.com/twitter/finatra/commit/2053b76a6d4f02ce152469d21b4dcbb098e73f59)
-   finatra-http: Added HttpServerTrait which allows for a simple way to serve a
    Finagle Service\[Request, Response\] on an external interface without the need to
    configure the Finatra HttpRouter. [a4fe06c5](https://github.com/twitter/finatra/commit/a4fe06c5c9a6a0424f01a10c043ad705d5e1cba2)
-   finatra-http: Added support to serve c.t.io.Reader as a streaming request.
    [4491e5e5](https://github.com/twitter/finatra/commit/4491e5e52d8035ab7a4147f482201924cd12795d)

#### Changed

-   finatra-kafka-streams: finatra-kafka-streams: Refactor queryable state management [ce05c72f](https://github.com/twitter/finatra/commit/ce05c72fc507051f17f9160212fb768bad365f02)
-   finatra-kafka-streams: Improve querying of windowed stores. [ea65ef40](https://github.com/twitter/finatra/commit/ea65ef40230f7c024e9ab17baa400b54c2081b78)
-   inject-utils: Mark c.t.inject.utils.StringUtils\#snakify,camelify,pascalify as
    deprecated as their implementations have moved to util/util-core c.t.conversions.StringOps.
    Encourage users to switch usages to c.t.conversions.StringOps\#toSnakeCase,toCamelCase,toPascalCase.
    [85b9361c](https://github.com/twitter/finatra/commit/85b9361c761b34b07fa6c1c3af40930d552f2f9a)
-   finatra-thrift: Changed c.t.finatra.thrift.ThriftServerTrait\#service to \#thriftService to
    not collide with the serving of a Finagle service from the HttpServer when a server extends
    both HttpServer and ThriftServer. [a4fe06c5](https://github.com/twitter/finatra/commit/a4fe06c5c9a6a0424f01a10c043ad705d5e1cba2)

#### Fixed

#### Closed

### [Scrooge](https://github.com/twitter/scrooge/) ###

No Changes

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

-   Change the /admin/histograms?h=...-style endpoints to return data in the same style as
    /admin/histograms.json. This should make it easier to use tools to parse data from either
    endpoint. [92e4dad5](https://github.com/twitter/twitter-server/commit/92e4dad51acd0af3ad6bf656e43504716b925eaf)

### [Util](https://github.com/twitter/util/) ###

#### New Features

-   util-core: Discard parent reader from Reader.flatten when child reader encounters an exception.
    [0cc640ac](https://github.com/twitter/util/commit/0cc640ac8ff79218fd1d0fe165bbdb647f33a9f6)
-   util-core: Added c.t.conversions.StringOps\#toSnakeCase,toCamelCase,toPascalCase implementations.
    [b0a5d062](https://github.com/twitter/util/commit/b0a5d06269b9526b4408239ce1441b2a213dd0df)


---
layout: post
title: August 2020 Release Notes - Version 20.8.1
published: true
post_author:
  display_name: Ruben Oanta
  twitter: rubenoanta
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Release 20.8.0 had a corrupt artifact uploaded to maven central. This patch release
addresses that and includes some other goodies:

### [Finagle](https://github.com/twitter/finagle/)

#### New Features

-   finagle-thriftmux: Add MethodBuilder specific APIs for ThriftMux partition aware client.
    [e2f467c1](https://github.com/twitter/finagle/commit/e2f467c11e07db4a59c0f13888b0ecf36bcf34d6)


### [Finatra](https://github.com/twitter/finatra/)

#### Added

-   thrift: JavaThriftRouter now allows mounting controllers by value (as opposed to via DI).
    [bcc76056](https://github.com/twitter/finatra/commit/bcc760565ef4826d3393b318f0f73f554d4afdf7)
-   finatra-kafka: Expose delivery timeout duration in KafkaProducerConfig. [cc023430](https://github.com/twitter/finatra/commit/cc02343057284fb3d0924b09909f2c28666b01e5)

#### Changed

-   inject-core: Remove deprecated com.twitter.inject.Mockito trait. Users are encouraged to
    switch to the com.twitter.mock.Mockito trait from util/util-mock. [92c3f7ba](https://github.com/twitter/finatra/commit/92c3f7ba0f06ab4baf57489af04a32982052e145)

#### Fixed

-   inject-server: Ensure Awaiter.any does not try to block on an empty list of Awaitables. Add
    tests. [b19e8a25](https://github.com/twitter/finatra/commit/b19e8a253f86d9143160a0b57196f4b587c8f3df)
-   finatra-jackson: Fix bugs around generic case class deserialization involving other generic
    types. Reported (with reproduction and pointers) on GitHub by @aatasiei
    (<https://github.com/twitter/finatra/issues/547>). Fixes \#547. [a6ba62b6](https://github.com/twitter/finatra/commit/a6ba62b6b53ac5470a3b99a36634ec0f35600540)
-   finatra-jackson: Fix a bug preventing JSON parsing of generic case classes, which in turn, contain
    fields with generic case classes. Reported (with a thorough reproducer and an analysis) on GitHub
    by @aatasiei (<https://github.com/twitter/finatra/issues/548>). Fixes \#548. [0a3803ff](https://github.com/twitter/finatra/commit/0a3803ff9ae3e975c4dbe32538f7907fe7f6d9f1)

### [Util](https://github.com/twitter/util/)

#### New Features

-   util-mock: Introduce [mockito-scala](https://github.com/mockito/mockito-scala) based mocking
    integration. Fix up and update mockito testing dependencies:
    -   mockito-all:1.10.19 to mockito-core:3.3.3
    -   scalatestplus:mockito-1-10:3.1.0.0 to scalatestplus:mockito-3-2:3.1.2.0 [b2fb4b3a](https://github.com/twitter/util/commit/b2fb4b3a9e063a2183d4f14de4ae04f5e1b2abb2)
-   util-app: Add support for flags of Java Enum types. [4657258d](https://github.com/twitter/util/commit/4657258dfe0d7e1a70ad7460a78601c715bfb4bd)

### [Twitter Server](https://github.com/twitter/twitter-server/)

-   Check SecurityManager permissions in the ContentHandler to ensure that contention
    snapshotting is allowed. [ce783a3c](https://github.com/twitter/twitter-server/commit/ce783a3cadb9b27473006b59547adf22c534f5d9)

### [Scrooge](https://github.com/twitter/scrooge/)

-   scrooge-generator: The Scala generator no longer generates Proxy classes
    on structs by default. These can be opted into on a struct-by-struct
    basis by adding a Thrift annotation to a struct,
    (com.twitter.scrooge.scala.generateStructProxy = "true"). See struct Request
    in scrooge-generator-tests/src/test/resources/gold\_file\_input/gold.thrift
    for an example. [2a0f311b](https://github.com/twitter/scrooge/commit/2a0f311b0dc8cbfca907197f8e0218ecbce1e780)
-   scrooge-generator: Fixed a bug in the Java generated code where responses were
    often deserialized twice. [175e1358](https://github.com/twitter/scrooge/commit/175e135888188dbd3f9da41254ff69db73f0dd84)
-   scrooge-generator: Java-generated ServiceIface interfaces now extend
    c.t.f.thrift.AbstractThriftService. [a36486fb](https://github.com/twitter/scrooge/commit/a36486fb4b0a229232c1104009fbababd886d80c)
-   scrooge-generator: Reduced the size of generated Scala code. [1dc7e4f4](https://github.com/twitter/scrooge/commit/1dc7e4f4d4f6e49dfb3f2b9d61df377e2f8fcc13)



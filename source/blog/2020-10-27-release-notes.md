---
layout: post
title: October 2020 Release Notes - Version 20.10.0 🎃
published: true
post_author:
  display_name: Jing Yan
  twitter: freshlemonfish
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Trick or... our October release is as sweet as candies 👻

### [Finagle](https://github.com/twitter/finagle/) ###

#### Breaking API Changes

-   finagle-thrift: Change the partition locator function getLogicalPartitionId in
    PartitioningStrategy from Int => Int to Int => Seq[Int], which supports many to many mapping
    from hosts and logical partitions. [ab641adc](https://github.com/twitter/finagle/commit/ab641adccaff073f26ed63624c32eb584a47addf)

#### Runtime Behavior Changes

-   finagle-core: Disable eager connections for balancers with a non 1.0 weight. [11eae0d6](https://github.com/twitter/finagle/commit/11eae0d6b87a73a6ec11edf22a4c6a2bb7b35c68)


### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

-  finatra-kafka-streams: Add toCluster DSL call to publish to another Kafka cluster. [449eea1a](https://github.com/twitter/finatra/commit/449eea1aa27f48ae9fbbacb104f841f7fe9b7d69)

-  jackson: Add support for validating @JsonCreator annotated static (e.g., companion object defined apply methods) or secondary case class constructors. [1c1b55c9](https://github.com/twitter/finatra/commit/1c1b55c99461b38aa18e82199a4b650ca393937f)

-  inject-app: Allow injecting flags without default values as both scala.Option and java.util.Optional. [b74fe9e9](https://github.com/twitter/finatra/commit/b74fe9e949c983c8ab75f61976419b646013c537)

#### Changed

-   utils: Undo usage of TypesApi for help in determining if a class is a Scala case class
    as this fails for generic case classes in Scala 2.11, failing some supported cases for
    Jackson processing. [b1d43381](https://github.com/twitter/finatra/commit/b1d43381b000ed6aa130bc40ca5cb2e4d2548dad)
-   utils: Update ClassUtils\#simpleName to handle when package names have underscores
    followed by a number which throws an InternalError. Add tests. [bbc0cf7b](https://github.com/twitter/finatra/commit/bbc0cf7b6034d1e0eac7ed90b9fc394cdb03776c)
-   utils: Revamp ClassUtils\#isCaseClass to use the TypesApi for help in determining
    if a class is a Scala case class. Add tests. [bbc0cf7b](https://github.com/twitter/finatra/commit/bbc0cf7b6034d1e0eac7ed90b9fc394cdb03776c)
-   http: The http server did not properly log the bound address on server startup. Fix this
    and make the thrift server consistent. [4410ff38](https://github.com/twitter/finatra/commit/4410ff38961a0187c862dfb9ee4c0c5cbbe9c91e)
-   utils: (BREAKING API CHANGE) Rename maybeIsCaseClass to notCaseClass in
    ClassUtils and change the scope of the method. [82ffb4be](https://github.com/twitter/finatra/commit/82ffb4be9428fa318189575b645a5b24d3ab610f)
-   http: Adding support for optionally passing chain in the TLS sever trait. [5bcce35c](https://github.com/twitter/finatra/commit/5bcce35c8f53111d52050953e1f96acc32f8ce5a)
-   finatra: Bump version of Joda-Time to 2.10.8. [e2cbca30](https://github.com/twitter/finatra/commit/e2cbca30374cc1998bdf453a3cb501aa3045e7de)

#### Fixed

- finatra-kafka-streams: Revert AsyncTransformer to still use ConcurrentHashMap. [7d5b3ccf](https://github.com/twitter/finatra/commit/7d5b3ccf030582ffc3b704c43c6fd47eb21ca7bc)

- inject-thrift-client: The Singleton annotation has been removed from the DarkTrafficFilter and the JavaDarkTrafficFilter. It was there in error. [5efc1ab2](https://github.com/twitter/finatra/commit/5efc1ab237899be7cb3d8985484ed8f135c4d496)

- inject-thrift-client: When using RepRepServicePerEndpoint, Finatra's DarkTrafficFilter would throw a NoSuchMethodException when trying to lookup an inherited Thrift endpoint.
    [697b2137](https://github.com/twitter/finatra/commit/697b21375c934454673d3c6429a4395b2a17a67e)


### [Util](https://github.com/twitter/util/) ###

#### Bug Fixes

-   util-stat: MetricBuilder now uses a configurable metadataScopeSeparator to align
    more closely with the metrics.json api. Services with an overridden scopeSeparator will
    now see that reflected in metric\_metadata.json where previously it was erroneously using
    / in all cases. [7665b9eb](https://github.com/twitter/util/commit/7665b9eb09adaaa282e65f32b040aeb14ce29c3b)
-   util-slf4j-api: Better Java interop. Deprecate c.t.util.logging.Loggers as Java users should be
    able to use the c.t.util.logging.Logger companion object with less verbosity required.
    [26e7874b](https://github.com/twitter/util/commit/26e7874bfe4fdc7b338acfbd74612b414adf7118)


### [Scrooge](https://github.com/twitter/scrooge/) ###

No Changes

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

No Changes

---
layout: post
title: Jul 2022 Release Notes - Version 22.7.0
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

This release comes with a delay, which was intentional. A few months ago, we've decided to slow down our release train and switch from releasing monthly (12 releases a year) to releasing quarterly (4 releases a year).

The next release should have been in November. However, looking at the team's quite busy schedule throughout the rest of the year, it's very unlikely we would be able to make time for one more release in 2022. The 2023 Q1 release is looking more realistic.

We'll continue pablishing nightly snapshots (versioned as 22.10.0-SNAPSHOT) and will cut a patch release should any security vulnerabilities be fixed. Otherwise, tune back in 2023!

## [Finagle 22.7](https://github.com/twitter/finagle/releases/tag/finagle-22.7.0)

#### New Features

-   finagle-thrift: Changing visibility of InputBuffer and OutputBuffer from \[finagle\] to \[twitter\].  [d56bb847](https://github.com/twitter/finagle/commit/d56bb847a9b7722f13a2cc2fc536cb1c3bdd60a7)
-   finagle-core: Introduce panic mode in load balancers. Configure the threshold for
    panic mode to start using withLoadBalancer.panicMode. [c6060de8](https://github.com/twitter/finagle/commit/c6060de877b97936ef2ca54431a4539f6ee06c78)
-   finagle-core: Provide ServerParamsInjector, a class that will be service-loaded at run-time
    by Finagle servers, and will allow generic configuration of all sets of parameters.
    [f00434c1](https://github.com/twitter/finagle/commit/f00434c1f473c93ec4b5cfec11b9255b2f97f91b)
-   finagle-memcached: Add new function, newLoadBalancedTwemcacheClient, to create a TwemcacheClient
    that doesn't use a partitioning service.
    [eebf0821](https://github.com/twitter/finagle/commit/eebf0821b1251d6a910ac952bec0ccfba661884e)

#### Bug Fixes

-   finagle-core: fix issue where Trace.traceLocal and Trace.traceLocalFuture nested traces mistakenly
    annotate to the parent span. [77a7e774](https://github.com/twitter/finagle/commit/77a7e774cd4f3bde8bbbfe67eb38732a7cc2ef3a)

#### Breaking API Changes

-   finagle-core: Remove unused DeterministicAperture along with pathways to use weight-unaware
    aperture loadbalancers. [a5004ecc](https://github.com/twitter/finagle/commit/a5004ecc810e39c32e3041472f3bb752fc669e94)
-   finagle-base-http: Methods for getting/setting Accept, Authorization, Host, Referer,
    User-Agent, X-Forwarded-For headers were moved from c.t.f.http.Message class to
    c.t.f.http.Request as these headers are only valid on requests and not on responses.
    Methods for getting/setting Location, Retry-After, Server, and WWW-Authenticate headers
    were moved from c.t.f.http.Message class to c.t.f.http.Response as they are only valid
    on responses and not on requests.
-   finagle-core: Update OffloadFilter.Param API to encourage recommended construction.
    [b684552f](https://github.com/twitter/finagle/commit/b684552f9e2a7a7abc2d9ba2b74d1a394b8cad27)
-   finagle-core: Trace.recordLocalSpan is private\[this\] and no longer protected. [77a7e774](https://github.com/twitter/finagle/commit/77a7e774cd4f3bde8bbbfe67eb38732a7cc2ef3a)
-   finagle-core: "ServiceFactory\#status" is abstract and requires implementation in the inherited
    classes. [b2a7f4ea](https://github.com/twitter/finagle/commit/b2a7f4eaa004482157ffa2018e6d772d9138b139)
-   finagle-core: StackTransformer has been renamed to ServerStackTransformer and the symmetric
    client equivalent (ClientStackTransformer) has been added. For those using the older StackTransformer
    API you will both need to change the code (fix the extends) \_\_and\_\_ rename the META-INF file from
    resources/META-INF/services/com.twitter.finagle.StackTransformer to
    resources/META-INF/services/com.twitter.finagle.ServerStackTransformer in order to have your
    transformer continue to service-load correctly. [f5de196d](https://github.com/twitter/finagle/commit/f5de196dddb93109b64b4d4c216fe77d5f075565)

#### Runtime Behavior Changes

* finagle-core: Changed the default implementation for random and deterministic aperture
load balancers to weighted aperture. [f67c839c](https://github.com/twitter/finagle/commit/f67c839cfe1b2a9a8c555dc750a3a522afa41244)

* finagle-partitioning: ThriftCustomPartitioningServices now allow fanning out the same
request to multiple partitions. [59381065](https://github.com/twitter/finagle/commit/59381065511362d86736a15508364936e9480f8e)

-   finagle-core: Rename the counter metric loadbalancer/max\_effort\_exhausted to
    loadbalancer/panicked. [a055f74b](https://github.com/twitter/finagle/commit/a055f74b4e145ad7daef3f73b8d5837a9b4e979f)
-   finagle: Upgrade to Netty 4.1.76.Final and netty-tcnative 2.0.51.Final. [c07a9b0b](https://github.com/twitter/finagle/commit/c07a9b0bb6e49cd8438817e590d0f6557d110085)
-   finagle: Update Jackson library to version 2.13.3 [92d39db2](https://github.com/twitter/finagle/commit/92d39db21b713130b305f06f554337ccbad8ab11)
-   finagle: Bump version of lz4-java to 1.8.0. [305c467c](https://github.com/twitter/finagle/commit/305c467c2ba8f72b2ada012b592b000b961809a4)
-   finagle: Upgrade to Netty 4.1.78.Final and netty-tcnative 2.0.53.Final to support
    tls tracing for finagle in \[Pixie\](<https://pixie.dev/>). The Pixie changes aren't
    complete yet, but upgrading netty is a prerequisite for that. [d251883b](https://github.com/twitter/finagle/commit/d251883b19dfd177a5c08dfc790327bfeb19c7c0)\

## [Finatra 22.7](https://github.com/twitter/finatra/releases/tag/finatra-22.7.0)


#### Changed

-   inject-utils|inject-thrift: Move package private methods PossiblyRetryable\#isCancellation and
    PossibleRetryable\#isNonRetryable in inject-thrift to inject-utils ExceptionUtils as publicly
    usable methods. These methods are generally useful when processing interrupts on Futures.
    [3d351450](https://github.com/twitter/finatra/commit/3d3514506d7c22002fc4744e5b50c1238c54f580)

#### Runtime Behavior Changes

-   inject-server: Remove deprecated c.t.inject.server.DeprecatedLogging trait. This trait was
    introduced as a placeholder shim to ensure that JUL util-logging Flags were still defined within
    a Finatra server such that servers did not fail upon startup if Flag values were being set.
    The default behavior during Flag parsing is to error if a Flag value is passed for a Flag not
    defined within the application.

    We have removed the shim and the trait (and thus the Flag definitions), as it is not expected
    that users use util-logging JUL Flags for logging configuration with Finatra servers since Finatra
    uses the SLF4J-API. Logging configuration should be done on the choosen SLF4J-API logging
    implementation. If your server fails to start after this change, please ensure you are not passing
    values for the JUL util-logging Flags. [5b5ccf4f](https://github.com/twitter/finatra/commit/5b5ccf4f170256d06f47e8bca4f8ff1a29429c1a)

#### Changed

-   finatra: Removed `kafka` and `kafka-streams` modules from finatra core library.

    Note: We published a stand-alone [finatra-kafka client](https://github.com/finagle/finatra-kafka)
    with deprecation announcement to serve as exit pathway for current users.

    Announcement: [finagle blog](https://finagle.github.io/blog/2022/06/01/announce-migrations/)
    [27e2c9c4](https://github.com/twitter/finatra/commit/27e2c9c40caada815b2665e0702725ebdd6dc6f9)

#### Added

-   finatra: Introduce InMemoryTracer for inspecting Trace information via tests. [0755b77e](https://github.com/twitter/finatra/commit/0755b77e702d4bbe554aa1a30ac52235d0023168)

#### Runtime Behavior Changes

- finatra: Update Jackson library to version 2.13.3 [a4065f19](https://github.com/twitter/finatra/commit/a4065f196b6c9c7ee5c7f8c48bdb556ddc79a064)

## [Util 22.7](https://github.com/twitter/util/releases/tag/util-22.7.0)

#### Breaking API Changes

-   util-stats: SourceRole subtypes have been moved into the SourceRole object to make their
    relationship to the parent type more clear. [633cf5b0](https://github.com/twitter/util/commit/633cf5b0649c8377207201c633fdd7ecf6ae6758)

#### Runtime Behavior Changes

-   util-jackson: Update Jackson library to version 2.13.3 [8c96a442](https://github.com/twitter/util/commit/8c96a44240688d9a32a42e8c6e3e225244055dab)
-   util-jackson: Deserialized case classes with validation on optional fields shouldn't throw an error.
    [3b94d2e6](https://github.com/twitter/util/commit/3b94d2e628d6d62d678006c3177f46dfeb1e0ec9)
-   util: Update snakeyaml to 1.28 [d486a7da](https://github.com/twitter/util/commit/d486a7dab7110ee05d24760e9d9531f75393254d)

## [Scrooge 22.7](https://github.com/twitter/scrooge/releases/tag/scrooge-22.7.0)

-   scrooge-generator: Introduce a AnnotatedFieldType to abstract type annotations from
    FieldType definitions. Currently used to propagate thrift annotations inside of
    collection types. [59e91e64](https://github.com/twitter/scrooge/commit/59e91e6404cb802f0297c1fc7cb89e6692b3f4e9) [2fa68351](https://github.com/twitter/scrooge/commit/2fa68351e354a21c511ab666bcf66274fd2941f8)
-   scrooge-core: c.t.scrooge.ThriftUnion.fieldInfoForUnionClass API for retrieving
    ThriftStructFieldInfo for a ThriftUnion member class without having to instantiate
    it. [19809c22](https://github.com/twitter/scrooge/commit/19809c226bfc5ea18613e18a0d897cba553c5f56)
-   scrooge-generator: Add @.generated annotation to Swift generated code [8fd6a089](https://github.com/twitter/scrooge/commit/8fd6a0896e5ca768189bd8ea1bb3c97d091916c8)
-   scrooge-generator: Provide a \$STRUCT\#unsetFields method to allow bulk unsets [aef5029b](https://github.com/twitter/scrooge/commit/aef5029b24f11992255d0bc0497cb1d064c67b1b)
-   scrooge-generator: support thrift validations on nested fields that are struct, union, and
    exception [8bad4dd7](https://github.com/twitter/scrooge/commit/8bad4dd746dae8513016f39f423457e8af4ac5fe)


## [Twitter Server 22.7](https://github.com/twitter/twitter-server/releases/tag/twitter-server-22.7.0)

-   Admin HTTP server is now on Finagle's default HTTP protocol version, which supports
    HTTP/1.1, HTTP/2 cleartext protocol upgrade, HTTP/2 prior-knowledge, and ALPN.
    [6b9bf60f](https://github.com/twitter/twitter-server/commit/6b9bf60fbc8df03c9b56bba46dd2ad074a67024e)
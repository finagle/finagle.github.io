---
layout: post
title: July 2020 Release Notes - Version 20.7.0
published: true
post_author:
  display_name: Ruben Oanta
  twitter: rubenoanta
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Hi folks! Our July release is here – enjoy!

### [Finagle](https://github.com/twitter/finagle/)

### Breaking API Changes

-   finagle-core: Correct the spelling of Tracing.recordClientSendFrargmet() to
    Tracing.recordClientSendFragment() [30726c01](https://github.com/twitter/finagle/commit/30726c014efe95760e9daff00e1813a412cd1bbe)
-   finagle-redis: Use StrictKeyCommand for XDEL [d174f9d6](https://github.com/twitter/finagle/commit/d174f9d603fa28122e3cdcc1d39563790bcbe98e)
-   finagle-toggle: Toggle.isDefinedAt(i: Int) has become Toggle.isDefined. Additionally, a new method Toggle.isUndefined has been added. [3bb78ce8](https://github.com/twitter/finagle/commit/3bb78ce8dd10e816f18544143cbd5081a2f13721)
-   finagle-zipkin-scribe: The scribe.thrift file was moved to finagle-thrift/src/main/thrift under a new
    namespace. com.twitter.finagle.thrift.scribe.(thrift|thriftscala) [01a20b79](https://github.com/twitter/finagle/commit/01a20b798726550a670b890aa630e4ddd657bddd)

### Bug Fixes

-   finagle-zipkin-scribe: The scribe client should be configured using the NullTracer. Otherwise, spans
    produced by the client stack will be sampled at initialSampleRate. [0446dd3e](https://github.com/twitter/finagle/commit/0446dd3e5ea519cac15cec990f919113c5a2d503)

### [Finatra](https://github.com/twitter/finatra/)

20.7.0
======

### Added

-   inject-app: Adding flag converters for java.io.File (including comma-separated variants).
    [48429870](https://github.com/twitter/finatra/commit/48429870b9fd2378599d10d648c2f51b86f1224a)
-   finatra-kafka-streams: Added TracingKafkaClientSupplier to provide TracingKafkaProducer and
    TracingKafkaConsumer to enable Zipkin tracing. Tracing can be enabled with the toggle
    com.twitter.finatra.kafka.TracingEnabled. [fd2c5e0d](https://github.com/twitter/finatra/commit/fd2c5e0d652a30f2d8a7eb991124e970266d8ca7)
-   finatra-kafka: Added TracingKafkaProducer and TracingKafkaConsumer to enable Zipkin tracing
    for Kafka. FinagleKafkaProducerBuilder.build() and FinagleKafkaConsumerBuilder.buildClient()
    now return instances of TracingKafkaProducer and TracingKafkaConsumer respectively with
    tracing enabled by default. Tracing can be enabled with the toggle
    com.twitter.finatra.kafka.TracingEnabled. [d0d8a060](https://github.com/twitter/finatra/commit/d0d8a060ba21b7636b4f935b99efd533f49380bb)

### Changed

-   finatra: Update org.scalatest dependency to 3.1.2 and introduce finer-grained dependencies on
    org.scalatestplus artifacts. [ceccb7c5](https://github.com/twitter/finatra/commit/ceccb7c5a8748f8124d178a05a857e13c405dfb0) [fbb7b535](https://github.com/twitter/finatra/commit/fbb7b5357f32f15b86c7a70f16804411c17bef7f)
-   inject-thrift-client: Remove unused ClientId property from
    ThriftMethodBuilderClientModule\#provideServicePerEndpoint method. [381853f8](https://github.com/twitter/finatra/commit/381853f83ff25b639f143891b49b54c388ef50c1)
-   inject-server: Improve startup time of EmbeddedTwitterServer by observing lifecycle events to
    determine startup, where previously we were doing 1 second polls. The nonInjectableServerStarted
    property is removed and isStarted should be referenced regardless of the type of underlying
    twitterServer type. The end result should see a faster test execution feedback loop. Our Finatra
    test targets range from a roughly 2x to 10x reduction in execution times.

    You may experience new test failures in cases where an exception is thrown as part of
    c.t.inject.TwitterServer.start() or c.t.server.TwitterServer.main() and the test would have
    expected a failure as part of startup. As the error takes place after the startup lifecycle,
    you may now need to Await.result the EmbeddedTwitterServer.mainResult() to assert the error.

    You may also experience some new non-deterministic behavior when testing against PubSub style
    logic. As the server may be started earlier, your tests may be relying on assumptions that
    an event would have occurred within the previous 1 second startup poll, which is no longer
    guaranteed. You may need to adjust your test logic to account for this behavior.

    [a134e9b8](https://github.com/twitter/finatra/commit/a134e9b83f79e94f78788add162160678ee1f15e)

-   finatra: Update com.google.inject.guice dependency to 4.2.3 and net.codingwell.scala-guice
    to version 4.2.11. The net.codingwell.scala-guice library has switched from Manifests to TypeTags
    for transparent binding and injector key creation. The c.t.inject.TwitterModule has moved from its
    custom bind DSL to the scalaguice.ScalaModule which brings the TwitterModule inline with both the
    TwitterPrivateModule and the bind\[T\] test DSL to now have the same consistent binding DSL across
    all three. Thus, there is no more confusing bindSingleton function in the TwitterModule bind API.

    Upgrading scalaguice helps move a necessary dependency of Finatra to a version which is Scala 2.13
    compatible moving Finatra closer to Scala 2.13 support. [26c1e810](https://github.com/twitter/finatra/commit/26c1e8102450f57b2d279fb3ddb75977ddcef4f5) [5faa2e6f](https://github.com/twitter/finatra/commit/5faa2e6f4543a19d7beceac631bb7952c60a6d62)

### Fixed

-   inject-app: Having two sets of flag converters for primitive types (both Java and Scala) confuses
    the DI runtime, preventing the injection. We now have only a single set of converters, based off
    Scala primitive types. [9c1b0d68](https://github.com/twitter/finatra/commit/9c1b0d68c551a177fb95ca8e0adf8bb08dafa0f3)

### [Util](https://github.com/twitter/util/)

### New Features

-   util-app: Add ability to observe App lifecycle events. [2d2e6803](https://github.com/twitter/util/commit/2d2e680310c21052f3879f30c568515585b3148b)

### [Twitter Server](https://github.com/twitter/twitter-server/)

### Breaking API Changes

-   Make Lifecycle and Lifecycle.Warmup self-typed to TwitterServer. Lifecycle was previously
    self-typed to c.t.app.App and Lifecycle.Warmup previously had no self-type restrictions. These
    traits can now only be mixed into instances of TwitterServer. The Lifecycle.DetatchedWarmup
    trait is introduced to allow users to transition to it, where they were previously extending
    Lifecycle.Warmup without mixing into a TwitterServer. Lifecycle.DetatchedWarmup
    is immediately deprecated and will be removed in a future release. [cb85a45f](https://github.com/twitter/twitter-server/commit/cb85a45fbc4d4d380b66f14db16b164a4d194981)

### [Scrooge](https://github.com/twitter/scrooge/)

-   scrooge-core: c.t.scrooge.ThriftStructMetaData has been changed from a concrete
    class to an abstract class with different implementations. To construct an object
    of ThriftStructMetaData, please now use one of the apply methods in the
    ThrifStructMetaData companion object. [05881d4d](https://github.com/twitter/scrooge/commit/05881d4d5a90f1800f178f80c80d050366a690e7)
-   scrooge-generator: Removed experiment-flag argument and replaced it with
    language-flag. Updated GeneratorFactory object and trait to match. [8fa0583c](https://github.com/twitter/scrooge/commit/8fa0583cac55ed90ac7df689740e52c28241d355)
---
layout: post
title: December 2020 Release Notes - Version 20.12.0
published: true
post_author:
  display_name: Moses Nakamura
  twitter: mnnakamura
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

You get two for the price of one this time!  We skipped the 20.11.0 release, and we're headed
straight to 20.12.0.  This is the last minor bump of 2020, since there aren't any other months
this year (we hope!).  Goodbye to the optometrically significant year! 👓

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-core: Add a new stat (histogram) that reports how long a task has been sitting in the
    offload queue. This instrumentation is sampled at the given interval (100ms by default) that
    can be overridden with a global flag com.twitter.finagle.offload.statsSampleInterval.
    [a7ebf2e1](https://github.com/twitter/finagle/commit/a7ebf2e10afe37063525c162db471aae21f757e7)
-   finagle-core: Add a new experimental flag com.twitter.finagle.offload.queueSize that allows to
    put bounds on the offload queue. Any excess work that can't be offloaded due to a queue overflow
    is run on IO (Netty) thread instead. Put this way, this flag enables the simplest form of
    backpressure on the link between Netty and OffloadFilter. [af228ca6](https://github.com/twitter/finagle/commit/af228ca6769e989d197856a8384a3ec21f3665f4)
-   finagle-netty4: Add ExternalClientEngineFactory to the open source version of Finagle. This
    SslClientEngineFactory acts as a better example of how to build custom client and server engine
    factories in order to reuse SSL contexts for performance concerns. [931785d9](https://github.com/twitter/finagle/commit/931785d94912b51b7920b1f2c737fa935f6120bf)
-   finagle-core: Provide com.twitter.finagle.naming.DisplayBoundName for configuring how to
    display the bound Name for a given client in metrics metadata. [67be8e1e](https://github.com/twitter/finagle/commit/67be8e1e310b75713e6d4ab075942b2a1bb07302)
-   finagle-core: Provide ClientParamsInjector, a class that will be service-loaded at run-time
    by Finagle clients, and will allow generic configuration of all sets of parameters.
    [b7bb5afc](https://github.com/twitter/finagle/commit/b7bb5afcebeb5c1e98bf8b82e2af3aab006fcb46)

#### Breaking API Changes

-   finagle-core: Move DarkTrafficFilter and AbstractDarkTrafficFilter from the experimental
    finagle-exp to supported finagle-core. The package containing these classes changed from
    c.t.finagle.exp to c.t.finagle.filter. [0ecaa5e7](https://github.com/twitter/finagle/commit/0ecaa5e7c3214e673966c1e05df3da78292faade)
-   finagle-core, finagle-thrift: Move ForwardingWarmUpFilter and ThriftForwardingWarmUpFilter
    from the experimental finagle-exp to supported finagle-core, and finagle-thrift, respectively.
    The package containing ForwardingWarmUpFilter changed from c.t.finagle.exp to
    c.t.finagle.filter, and the package containing ThriftForwardingWarmUpFilter changed from
    c.t.finagle.exp to c.t.finagle.thrift.filter. [e725bc86](https://github.com/twitter/finagle/commit/e725bc863c3b099c6d1a976c879abf007281556a)
-   finagle-core: FailureAccrualFactory.isSuccess has been replaced with the method
    def classify(ReqRep): ResponseClass to allow expressing that a failure should be ignored.
    [d586bd24](https://github.com/twitter/finagle/commit/d586bd2403c1721831df04d3588c963662b060cb)

#### Runtime Behavior Changes

-   finagle-core: Use Scala default implementation to calculate Hashcode and equals method for
    ServiceFactoryProxy. [c473b395](https://github.com/twitter/finagle/commit/c473b395ff95166f8f1db26dbc9d2a9d4adf39c5)
-   finagle: Update build.sbt to get aarch64 binaries and try the fast path acquire up to 5 times
    before failing over to the AbstractQueuedSynchronizer slow path in NonReentrantReadWriteLock
    for Arm64. [d45dfb02](https://github.com/twitter/finagle/commit/d45dfb022355a8105bd76d37dc77628d4e0cd330)

#### Bug Fixes

-   finagle-core: Users should no longer see the problematic
    java.lang.UnsupportedOperationException: tail of empty stream when a c.t.f.s.RetryPolicy
    is converted to a String for showing. [e7ec247d](https://github.com/twitter/finagle/commit/e7ec247d00d94039d8dd6ad3cefc2e416feecbd7)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

-   kafka: Add an option includePartitionMetrics to KafkaFinagleMetricsReporter to not include
    metrics per partition of the FinagleKafkaConsumer. Defaults to true. [1f5a00ee](https://github.com/twitter/finatra/commit/1f5a00ee82790bf59403fca6ad0e367fef5d58dd)
-   finatra: Enables cross-build for 2.13.0 for inject-logback. [0468a613](https://github.com/twitter/finatra/commit/0468a6135647f22da678be567003ec3adb1a37cc)
-   finatra-kafka-streams: Add delay DSL calls to insert a delay into a Kafka Streams topology.
-   finatra: Enables cross-build for 2.13.0 for inject-thrift-client. [82cf2830](https://github.com/twitter/finatra/commit/82cf2830a38ce8c97dc9f9313486163fe150e358)
-   finatra-kafka-streams: Add c.t.f.k.t.s.PersistentTimerValueStore which stores a value in the
    timerstore that can be used when the timer is triggered. [3cd8bfc0](https://github.com/twitter/finatra/commit/3cd8bfc0281e8c240b0095a3569880da22915a83)
-   inject-core: Add ability to call InMemoryStats\#waitFor with a fixed timeout
    [306b7196](https://github.com/twitter/finatra/commit/306b719605019ecf2940627d288622d59bc6aece)
-   finatra: Enables cross-build for 2.13.0 for httpclient, http, and jackson. [d6dbc074](https://github.com/twitter/finatra/commit/d6dbc074e07695d71c19eba25945b33a5f3811e5)

#### Changed

-   inject-utils: Deprecate all methods in c.t.inject.conversions.map.RichMap, and move
    functionality to c.t.conversions.MapOps in the util/util-core project. [e765b5ae](https://github.com/twitter/finatra/commit/e765b5ae89ba7c0e32dcea0ad630368c0b1a959e)
-   inject-utils: Deprecate all methods in c.t.inject.conversions.tuple, and move functionality
    to c.t.conversions.TupleOps in the util/util-core project. [2bd6dbf6](https://github.com/twitter/finatra/commit/2bd6dbf630ce85a9e92a8fcba7f086dd7d8125b9)
-   inject-utils: Deprecate all methods in c.t.inject.conversions.seq, and move functionality
    to c.t.conversions.SeqOps in the util/util-core project. [0ad0d114](https://github.com/twitter/finatra/commit/0ad0d1140f5ad7c89944c06179990a4253f14aa2)
-   inject-utils: Remove deprecated camelify, pascalify, and snakify from
    c.t.inject.conversions.string.RichString. Additionally, deprecate toOption and
    getOrElse in c.t.inject.conversions.string.RichString, and move functionality to
    c.t.conversions.StringOps in the util/util-core project. [b058e7f4](https://github.com/twitter/finatra/commit/b058e7f40b383467756d2744609a8e138e75ca1f)
-   c.t.finatra.http.exceptions.ExceptionMapperCollection changed from Traversable to Iterable
    for cross-building 2.12 and 2.13. [d6dbc074](https://github.com/twitter/finatra/commit/d6dbc074e07695d71c19eba25945b33a5f3811e5)
-   inject-core: (BREAKING API CHANGE) Move the testing utility InMemoryStatsReceiverUtility
    and InMemoryStats into inject-core from inject-server. They can both be found under
    com.twitter.inject. [fa5d5d69](https://github.com/twitter/finatra/commit/fa5d5d694ade59b75de782f92ed760d7734e69c6)
-   validation: (BREAKING API CHANGE) Introduce new Validation Framework APIs which support
    cascading validation to nested case classes and other improvements which also closer align
    to JSR380. Validator\#validate has changed from returning Unit and throwing an exception
    to model the JSR380 version that returns a Set of failed constraints. There is a new method
    which replicates the throwing behavior. [19008194](https://github.com/twitter/finatra/commit/19008194251ec1909ee6a2478ed0138bd33509e6)
-   kafka: Split c.t.f.kafka.tracingEnabled flag into c.t.f.k.producers.producerTracingEnabled and
    c.t.f.k.consumers.consumerTracingEnabled to selectively enable/disable tracing for
    producers/consumers. Producer tracing is turned on by default and consumer tracing is turned off
    by default now. [b95b8460](https://github.com/twitter/finatra/commit/b95b84608006662f05c5418daeadc3c61c350bf3)

#### Fixed

-   inject-server: Wire through HTTP method in AdminHttpClient so that POST requests can be made to
    HTTPAdmin endpoints. [8d846128](https://github.com/twitter/finatra/commit/8d8461286364c671dba0ad9ae0879500d166c5b1)

### [Util](https://github.com/twitter/util/) ###

#### Breaking API Changes

-   util-core: removed com.twitter.util.Config. [e95799b8](https://github.com/twitter/util/commit/e95799b8079e018bd3d806e84191990633d751ed)

#### New Features

-   util-core: c.t.conversions now includes conversion methods for maps (under MapOps)
    that were moved from Finatra. [3aa49339](https://github.com/twitter/util/commit/3aa49339e21963e434dbb3ce6f6ef80d9b2fcac9)
-   util-core: c.t.conversions now includes conversion methods for tuples (under TupleOps)
    that were moved from Finatra. [905bbf2a](https://github.com/twitter/util/commit/905bbf2abde0384b54ddb95cec26a9fb870d1152)
-   util-core: c.t.conversions now includes conversion methods for seqs (under SeqOps)
    that were moved from Finatra. [654a0a37](https://github.com/twitter/util/commit/654a0a374e5d2aae3a10988efb8f71e38041c2dc)
-   util-core: c.t.conversions now includes conversion methods toOption, and getOrElse
    under StringOps. [2d7ec5c2](https://github.com/twitter/util/commit/2d7ec5c2ebc419c1642b47a31d445632b5102bef)

\* util-core: c.t.util.Duration now includes fromJava and asJava conversions to

:   java.time.Duration types. [45340fb4](https://github.com/twitter/util/commit/45340fb4d1a433c09401e11065754b5ffb482108)

#### Runtime Behavior Changes

-   util-core: Activity.apply(Event) will now propagate registry events to the underlying
    Event instead of registering once and deregistering on garbage collection. This means
    that if the underlying Event is "notified" while the derived Activity is not actively
    being observed, it will not pick up the notification. Furthermore, the derived Activity
    will revert to the Activity.Pending state while it is not under observation. [f70326eb](https://github.com/twitter/util/commit/f70326eb4a90293a23d0e99a5c7abc64ee497bce)
-   util-core: Activity\#stabilize will now propagate registry events to the underlying
    Activity instead of registering once and deregistering on garbage collection. This means
    that if the underlying Activity is changed to a new state while the derived Activity is not actively
    being observed, it will not update its own state. The derived Activity will maintain its last
    "stable" state when it's next observed, unless the underlying Activity was updated to a new "stable"
    state, in which case it will pick that up instead. [f70326eb](https://github.com/twitter/util/commit/f70326eb4a90293a23d0e99a5c7abc64ee497bce)
-   util-stats: c.t.finagle.stats.DenylistStatsReceiver now includes methods for creating
    DenyListStatsReceiver from partial functions. [ba55bd0e](https://github.com/twitter/util/commit/ba55bd0e87fbd84a1bbf2954f03ea6f5f86cacdd)
-   util-core: c.t.util.FuturePool now supports exporting the number of its pending tasks via
    numPendingTasks. [22fedfd1](https://github.com/twitter/util/commit/22fedfd1eb17938f6d730b024db414051bcb9f2f)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

-   scrooge: Make options parser a separate class. All fields of com.twitter.scrooge.Compiler class
    are changed to immutable types. [5960c564](https://github.com/twitter/scrooge/commit/5960c56496813f64a949fdb2261bf18df12109e9)
-   scrooge-generator: Java throws an exception when encountering incorrect field
    types in a struct while deserializing. [39870f0f](https://github.com/twitter/scrooge/commit/39870f0f2187a209fe58f039ef22f647cba77c33)
-   scrooge-generator: Scrooge no longer fails to parse Thrift IDL when annotations are used
    on the individual components of a 'container type' (e.g. list, set, map). Those types of
    annotations are not currently used by scrooge, instead they are skipped over and discarded,
    but the IDL no longer fails to parse when they are encountered. [37edfe5b](https://github.com/twitter/scrooge/commit/37edfe5bede6477c3b091e081e5a193c8ff125a7)
-   scrooge-generator: Scrooge preallocates containers to the correct size on the deepCopy
    operation to improve performance in Java. [acf9ae5f](https://github.com/twitter/scrooge/commit/acf9ae5f39e72ed2b5dbaeccd41e3cd50cb92a1d)

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   Escape user-provided string from the returned text. This removes a potential vector for an XSS
    attack. [e0aeb87e](https://github.com/twitter/twitter-server/commit/e0aeb87e89a6e6c711214ee2de0dd9f6e5f9cb6c)


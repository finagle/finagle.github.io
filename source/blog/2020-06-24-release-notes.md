---
layout: post
title: June 2020 Release Notes - Version 20.6.0
published: true
post_author:
  display_name: Ryan O'Neill
  twitter: ryanoneill
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Summer is happening 🏖️, and with that comes the June release of Finagle, Finatra, Scrooge, Twitter Server, and Util 😎.

### [Finagle](https://github.com/twitter/finagle/)

#### Runtime Behavior Changes

-   finagle-core: FailFastFactory is now disabled at runtime when a client's destination has only
    one endpoint, since the client cannot do anything meaningful by breaking the circuit early.
    This is recommended as a best practice anyway, now it's the default behavior. Less things
    to configure and worry about! [f2c100e8](https://github.com/twitter/finagle/commit/f2c100e8c1ba2edd737f10aa698ac80313d11195)
-   finagle-core: namer annotations are prefixed with "clnt/". [c8680fff](https://github.com/twitter/finagle/commit/c8680fffd9f1c9ef9000d3f58d2cad823addabba)
-   finagle-core: namer.success & namer.failure are not annotated as they are not request based.
    namer.tree annotation was also removed to reduce the size of traces. [c8680fff](https://github.com/twitter/finagle/commit/c8680fffd9f1c9ef9000d3f58d2cad823addabba)
-   finagle-core: The offload filter client annotation is annotated under the child request span instead of
    its parent. The offload filter annotations are also changed to be binary annotations with the key
    (clnt|srv)/finagle.offload\_pool\_size and the value being the pool size [011f096d](https://github.com/twitter/finagle/commit/011f096dd8d078ea21fa02f1801855d656e06a7f)
-   finagle-memcached: The key in RetrievalCommand are ommited in traces. The total number of Hits
    and Misses are annotated via a counter instead under clnt/memcached.(hits/misses) [6fd0e2c9](https://github.com/twitter/finagle/commit/6fd0e2c91bab44784138a731f31d72e36ed1b253)

#### Breaking API Changes

-   finagle-core: Migrated List\[Tracer\] to Seq\[Tracer\] in Tracing, and tracersCtx.
    [cb06890b](https://github.com/twitter/finagle/commit/cb06890b78bf8c2b08e8c05e1fbb4cc99634e9d4)
-   finagle-core: PayloadSizeFilter and WireTracingFilter are now public APIs.
    [fc1951a5](https://github.com/twitter/finagle/commit/fc1951a51ba5b67983fabfa05508dc757bfdf95c)
-   finagle-zipkin-core: initialSampleRate flag will now fail if the sample rate is not in the range
    \[0.0, 1.0\]. [180f333c](https://github.com/twitter/finagle/commit/180f333c32c4937d0f3908ac6c9e427d39394db3)
-   finagle-mysql: mysql client annos are prefixed with clnt/ [37d55c2a](https://github.com/twitter/finagle/commit/37d55c2a7dacb821baf63f6447ce57d5bf6f19fc)

#### New Features

-   finagle-thrift: Expose c.t.f.thrift.exp.partitioning.PartitioningStrategy,
    the bundled PartitioningStrategy APIs are public for experiments.
    [bf1d47be](https://github.com/twitter/finagle/commit/bf1d47be286e804758bbf55230f795952733a7d8)
-   finagle-http: Add LoadBalancedHostFilter to allow setting host header after LoadBalancer
    [5304ce69](https://github.com/twitter/finagle/commit/5304ce691590d4946e13fd353888ff3951379bd8)
-   finagle-core: Trace the request's protocol identified by the ProtocolLibrary of the client
    stack. This is annotated under clnt/finagle.protocol. [464bbeb6](https://github.com/twitter/finagle/commit/464bbeb61e2f0f43c2f8d2168cc4330d95d0f39e)
-   finagle-core: Add letTracers to allow setting multiple tracers onto the tracer stack.
    [cb06890b](https://github.com/twitter/finagle/commit/cb06890b78bf8c2b08e8c05e1fbb4cc99634e9d4)
-   finagle-core: DeadlineFilter now exposes a metric admission\_control/deadline/remaining\_ms
    which tracks the remaining time in non-expired deadlines on the server side. An increase in this
    stat, assuming request latency is constant and timeout configurations upstream have not changed,
    may indicate that upstream services have become slower. [939f9a3e](https://github.com/twitter/finagle/commit/939f9a3eae96b3916f80989e11f0720ecb03dbf6)
-   finagle-redis: Make partitionedClient accessible. [7ba107e1](https://github.com/twitter/finagle/commit/7ba107e1bc329b55acfa701671bbf65b77c73e58)
-   finagle-core, finagle-http, finagle-thriftmux: introduce MethodBuilder maxRetries
    configuration. A ThriftMux or HTTP method can now be configured to allow a specific number of
    maximum retries per request, where the retries are gated by the configured RetryBudget. This
    configuration can be applied via Http.client.methodBuilder(name).withMaxRetries(n) or
    ThriftMux.client.methodBuilder(name).withMaxRetries(n). [4328896d](https://github.com/twitter/finagle/commit/4328896dfcf30b8509706a38c0931e71015ece6e)
-   finagle-memcached: Annotate the shard id of the backend the request will reach. [6fd0e2c9](https://github.com/twitter/finagle/commit/6fd0e2c91bab44784138a731f31d72e36ed1b253)

#### Bug Fixes

-   finagle-zipkin-core: Remove flush and late-arrival annotations, which artificially extend
    trace durations. [967ef1fc](https://github.com/twitter/finagle/commit/967ef1fcc96d025f5dede722109b1436370e0f22)
-   finagle-core: namer annotations are added at the Service level instead of ServiceFactory as
    traces are intended to be request based [c8680fff](https://github.com/twitter/finagle/commit/c8680fffd9f1c9ef9000d3f58d2cad823addabba)

### [Finatra](https://github.com/twitter/finatra/)

#### Added

-   inject-app: You can now inject Flag values of any type (not just primitive types). Most of the
    common Flag types are already supported out of the box (e.g., Seq\[InetSocketAddress\]), but it's
    also possible to register your own converters derived from any Flaggable instance.
    [92a47062](https://github.com/twitter/finatra/commit/92a470625c8803abba19206ac3260af35243790e)
-   inject-stack: Move StackTransformer from inject/inject-core to inject/inject-stack to
    remove the finagle-core dependency from inject/inject-core. [554e367e](https://github.com/twitter/finatra/commit/554e367e1439b40a6adb509565b4d37929892a5a)
-   inject-server: adding httpPostAdmin test method. [067b45cf](https://github.com/twitter/finatra/commit/067b45cfe2fc82d4f545ef69b308fa79cc6fabfb)

#### Changed

-   thrift/http: Introduce a [Common Log Format](https://en.wikipedia.org/wiki/Common_Log_Format)
    type of formatting for Thrift access logging to replace the current prelog text. Ensure
    the HTTP and Thrift access logging filters are aligned in functionality and behavior.
    [f7108618](https://github.com/twitter/finatra/commit/f7108618643a130e40d9fb6d3327f384bf2c23d9)
-   inject-slf4j: Remove Jackson dependency. Case classes which wish to use the slf4j Logging
    functionality should use the finatra/jackson c.t.finatra.jackson.caseclass.SerdeLogging
    trait which provides a @JsonIgnoreProperties to ignore logging fields. [70111cd8](https://github.com/twitter/finatra/commit/70111cd8fb1a5ac6ed7268c0b8967b35a74d9e2e)

### [Util](https://github.com/twitter/util/)

#### New Features

-   util-stats: Add two new Java-friendly methods to StatsReceiver (addGauge and provideGauge)
    that take java.util.function.Supplier as well as list vararg argument last to enable better
    developers' experience. [77c76e41](https://github.com/twitter/util/commit/77c76e418bea0b1ef43168cde73ae30a69fa0cc5)
-   util-app: Add a Flaggable instance for java.time.LocalTime. [19f13a07](https://github.com/twitter/util/commit/19f13a075adeeffd6ef1449e7050eff5e3b070e3)
-   util-app: Add two new methods to retrieve flag's unparsed value (as string): Flag.getUnparsed
    and Flag.getWithDefaultUnparsed. [4ef3c9b9](https://github.com/twitter/util/commit/4ef3c9b99a6421cb1b28ebf5355582efb4392665)

### [Twitter Server](https://github.com/twitter/twitter-server/)

### [Scrooge](https://github.com/twitter/scrooge/)


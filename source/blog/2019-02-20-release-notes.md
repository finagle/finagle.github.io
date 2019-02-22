---
layout: post
title: February 2019 Release Notes - Version 19.2.0 ☔️
published: true
post_author:
  display_name: Yufan Gong
  twitter: yufangong
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

It is the rainy season in San Francisco, grab a cup of hot tea and take a look at our new February release!

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

* finagle-core: Added gauge `is_marked_dead` as an indicator of whether the host is marked
  as dead(1) or not(0) in `FailFastFactory`. [068a15e6](https://github.com/twitter/finagle/commit/068a15e685dc5dda02ef098b1031378c04f1b9cc)

* finagle-core: `KeyCredentials.CertsAndKey` has been added as an option for
  `c.t.f.ssl.KeyCredentials` for when the certificate and certificate chain are
  contained within the same file. [b4a9e8cd](https://github.com/twitter/finagle/commit/b4a9e8cdbc79c27d6ff909f810e072115c7cbc4b)

* finagle-thriftmux: Additional information is now annotated in traces for clients
  using Scrooge generated Thrift bindings. [c69a22f8](https://github.com/twitter/finagle/commit/c69a22f8a174e86aca2e72ddcdc98f3a5927157b), [32d9b56b](https://github.com/twitter/finagle/commit/32d9b56b905b13035bf5f92ad9639371e9e7e631),
  [6283c6ce](https://github.com/twitter/finagle/commit/6283c6ce95bf4dda1c826c41cd3a6a2b15f38327).
  This includes:

  - RPC method name
  - Request serialization time, in nanoseconds
  - Request deserialization time, in nanoseconds
  - Response serialization time, in nanoseconds
  - Response deserialization time, in nanoseconds

#### Breaking API Changes

* finagle-http: Removed `Http.Client.withCompressionLevel` because it wasn't doing anything.
  To migrate your client, simply remove the configuration--it had absolutely no effect.
  [87944371](https://github.com/twitter/finagle/commit/8794437119a6b7c492657e3e13ead7f0021d0494)

* finagle-http: `c.t.f.dispatch.ExpiringServerDispatcher` was dead code. We removed it.
  [ae0571c9](https://github.com/twitter/finagle/commit/ae0571c9dbc88b1708f2dc338c2511318812c3c3)

* finagle-thrift: Removed `newIface` and `newServiceIface` methods from
  `c.t.f.thrift.ThriftRichClient.MultiplexedThriftClient`, which are deprecated in November 2017.
  [773b6e57](https://github.com/twitter/finagle/commit/773b6e57ab38c45c0dbecc4438fe0b3d9bcb2e12)

* finagle-thrift: Removed deprecated APIs located in Thrift.scala:
    1. c.t.f.Thrift.Client.stats
      => use c.t.f.Thrift.Client.clientParam.clientStats
    2. c.t.f.Thrift.withProtocolFactory
      => use c.t.f.Thrift.client.withProtocolFactory
    3. c.t.f.Thrift.withClientId
      => usec.t.f.Thrift.client.withClientId
    4. c.t.f.Thrift.Server.serverLabel
      => use c.t.f.Thrift.Server.serverParam.serviceName
    5. c.t.f.Thrift.Server.serverStats
      => use c.t.f.Thrift.Server.serverParam.serverStats
    6. c.t.f.Thrift.Server.maxThriftBufferSize
      => use c.t.f.Thrift.Server.serverParam.maxThriftBufferSize
  [c6eb2020](https://github.com/twitter/finagle/commit/c6eb20207376a86f59ef34753da39a27390faf18)

* finagle-thrift: `c.t.f.thrift.ThriftServiceIface.Filterable` is removed, use
  `c.t.f.thrift.service.Filterable` instead. [23affacc](https://github.com/twitter/finagle/commit/23affacc34d7559d89bbd7ce9d0fe9720f584e92)

* finagle-thrift: `c.t.f.thrift.ThriftServiceIface` is removed, use
  `c.t.f.thrift.service.ThriftServicePerEndpoint` instead. [23affacc](https://github.com/twitter/finagle/commit/23affacc34d7559d89bbd7ce9d0fe9720f584e92)

* finagle-thriftmux: Removed deprecated APIs located in ThriftMux.scala:
    1. c.t.f.ThriftMux.Client.stats
      => use c.t.f.ThriftMux.Clien.clientParam.clientStats
    2. c.t.f.ThriftMux.Server.serverLabel
      => use c.t.f.ThriftMux.Server.serverParam.serviceName
    3. c.t.f.ThriftMux.Server.serverStats
      => use c.t.f.ThriftMux.Server.serverParam.serverStats
    4. c.t.f.ThriftMux.Server.maxThriftBufferSize
      => use c.t.f.ThriftMux.Server.serverParam.maxThriftBufferSize
  [c6eb2020](https://github.com/twitter/finagle/commit/c6eb20207376a86f59ef34753da39a27390faf18)

* finagle-thriftmux: `ThriftMux.Client.pushMuxer` is removed. Use `ThriftMux.Client.standardMuxer`
  instead. [90333b1a](https://github.com/twitter/finagle/commit/90333b1acaae9ebf2d34358b183574598c3b1c83)

* finagle-thriftmux: `ThriftMux.serverMuxer` is removed. Use `ThriftMux.Server.defaultMuxer`
  instead. [90333b1a](https://github.com/twitter/finagle/commit/90333b1acaae9ebf2d34358b183574598c3b1c83)

* finagle-base-http: Removed the `c.t.f.http.Statuses` java helper, which was deprecated two years
  ago in favor of using `c.t.f.http.Status` directly. [75a4a209](https://github.com/twitter/finagle/commit/75a4a2097540d3577f1a72611340c371974b8406)

* finagle-base-http: Removed the `c.t.f.http.Versions` java helper, which was deprecated two years
  ago in favor of using `c.t.f.http.Version` directly. [f191f1db](https://github.com/twitter/finagle/commit/f191f1db1cbcb8d5dac7e9e295e7e09c21762a75)

* finagle-base-http: Removed the `c.t.f.http.Methods` java helper, which was deprecated two years
  ago in favor of using `c.t.f.http.Method` directly. [ccf10dbc](https://github.com/twitter/finagle/commit/ccf10dbc54f33313860d4f1a229537a2d9677a07)

* finagle-http: `c.t.f.http.Response.Ok` was removed. Use just `Response()` or `Response.Proxy`
  if you need to mock it. [d93bb1c9](https://github.com/twitter/finagle/commit/d93bb1c97c96312fb2354d552fc6d83f29e6e975)

* finagle-core: `Drv.Aliased` and `Drv.newVose` are now private, please
  construct a `Drv` instance using `Drv.apply` or `Drv.fromWeights`.
  [9c810dd3](https://github.com/twitter/finagle/commit/9c810dd3b5f5111f2ad4abdab56a6b09a65cc05d)

* finagle-core: `c.t.f.BackupRequestLost` is now removed. Please use `c.t.f.Failure.ignorable`
  instead. [02d3d524](https://github.com/twitter/finagle/commit/02d3d524b64dd6ba9af4f4b5104c901abeb9b9f5)

#### Bug Fixes

* finagle-http: Fix for a bug where HTTP/2 clients could retry requests that had a chunked
  body even if the request body was consumed. [b031e757](https://github.com/twitter/finagle/commit/b031e757a624ba082397a849e7fad26073b6e6f1)

* finagle-http: Fix for a bug where HTTP clients could assume connections are reusable, despite
  having streaming requests in flight. [88a2d0ba](https://github.com/twitter/finagle/commit/88a2d0ba683124fb390d8e9367ccd5959bd5df27)

#### Runtime Behavior Changes

* finagle-core: Faster `Filters`. Removes unnecessary `Service.rescue` proxies from
  the intermediate `andThen`-ed `Filters`. Previously in rare cases you might have seen
  a raw `Exception` not wrapped in a `Future` if the `Filter` threw. These will now
  consistently be lifted into a `Future.exception`. [a2ddc727](https://github.com/twitter/finagle/commit/a2ddc72761885782fbf7ee8dec335aeb190dc027)

* finagle-core: MethodBuilder metrics filtering updated to now report rolled-up
  logical failures. [6e3bf33f](https://github.com/twitter/finagle/commit/6e3bf33f83cfe211163233ce430d17b533b2fe14)

* finagle-http: Disabling Netty3 cookies in favor of Netty4 cookies. [fccd92c6](https://github.com/twitter/finagle/commit/fccd92c6f9a1ebc4053f07f90047e4fcbab8414e)

* finagle-http: Removed the debug metrics `http/cookie/dropped_samesites` and
  `http/cookie/flagless_samesites`. [2de928ce](https://github.com/twitter/finagle/commit/2de928ce4bb6973fe38160de3e174ecfc147f5b0)

#### Deprecations

* finagle-core: Multi-param legacy `tls` methods have been deprecated in
  `c.t.f.param.ServerTransportParams` and `c.t.f.builder.ServerBuilder`. Users should migrate
  to using the `tls(SslServerConfiguration)` method instead. [fbfc6d1a](https://github.com/twitter/finagle/commit/fbfc6d1aac4bd242bd546a9bbfa87deb53bea280)

* finagle-core: `$client.withSession.maxIdleTime` is now deprecated; use
  `$client.withSessionPool.ttl` instead to set the maximum allowed duration a connection may be
  cached for.  [0f060e37](https://github.com/twitter/finagle/commit/0f060e3701f48e27f108a4911e156b8180f0c5aa)

* finagle-serversets: `c.t.f.zookeeper.ZkResolver` has been deprecated in favor
  of `c.t.f.serverset2.Zk2Resolver`. [9878a9ec](https://github.com/twitter/finagle/commit/9878a9ec32e9605caa58728e469d694c18fed1e7)


### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

* finatra-kafka: Expose timeout duration in FinagleKafkaConsumerBuilder dest(). [abd68ddf](https://github.com/twitter/finatra/commit/abd68ddfc6393e816c97079a28eb9ab10cb3a3d3)

* finatra-kafka-streams: Expose all existing RocksDb configurations. See
  `c.t.f.k.config.FinatraRocksDBConfig` for details on flag names,
  descriptions and default values. [1454867c](https://github.com/twitter/finatra/commit/1454867ca2b2b4e59fecdfcb8f97d57d8853ada4)

* finatra-kafka-streams: Added two RocksDB flags related to block cache tuning,
  `cache_index_and_filter_blocks` and `pin_l0_filter_and_index_blocks_in_cache`.
  [3b0931e3](https://github.com/twitter/finatra/commit/3b0931e399877ce51d8b1e861ee7fc4e537932d2)

* finatra-kafka: Adding an implicit implementation of
  `c.t.app.Flaggable[c.t.finatra.kafka.domain.SeekStrategy]`
  and `c.t.app.Flaggable[org.apache.kafka.clients.consumer.OffsetResetStrategy]`.
  [ef071e54](https://github.com/twitter/finatra/commit/ef071e546966d21b70d085a654810b158ae49169)

* finatra-http: Added support to serve `c.t.io.Reader` as a streaming response in
  `c.t.finatra.http.internal.marshalling.CallbackConverter`. [e5bda446](https://github.com/twitter/finatra/commit/e5bda446476e98d7ccf6053a3d6cb4b404948cc1)

* finatra-kafka: Expose endOffsets() in FinagleKafkaConsumer. [bcbb5774](https://github.com/twitter/finatra/commit/bcbb57748bbfad717d3151353a8962a58b20b593)

* finatra-kafka-streams: Adding missing ScalaDocs. Adding metric for elapsed state
  restore time. RocksDB configuration now contains a flag for adjusting the number
  of cache shard bits, `rocksdb.block.cache.shard.bits`. [afd9a17c](https://github.com/twitter/finatra/commit/afd9a17c9d7223065dfb37e7d6c006da21c1b2d4)

* finatra-jackson: Added @Pattern annotation to support finatra/jackson for regex pattern
  validation on string values. [862f0ab1](https://github.com/twitter/finatra/commit/862f0ab15660145fb8c3f432da544950a57747e9)

#### Changed

* finatra-kafka-streams: Refactor package names. All classes moved from
  com.twitter.finatra.streams to com.twitter.finatra.kafkastreams. [a2ad0ef3](https://github.com/twitter/finatra/commit/a2ad0ef3df8de67486a49ddcc3661fb030a3670c)

* finatra-kafka-streams: Delete deprecated and unused classes. [ee948398](https://github.com/twitter/finatra/commit/ee948398653e7f387d29e815dec0d7b651bb9305)

* finatra-kafka-streams: `c.t.finatra.streams.transformer.domain.Time` is now the canonical
   representation of time for watermarks and timers. `RichLong` implicit from
   `com.twitter.finatra.streams.converters.time` has been renamed to `RichFinatraKafkaStreamsLong`.
   [093b31b8](https://github.com/twitter/finatra/commit/093b31b8739dc8e776c7d9d78b0059dd7e880ce1)

* finatra-jackson: Fix `CaseClassField` annotation reflection for Scala 2.12. [3747c1ab](https://github.com/twitter/finatra/commit/3747c1ab12abd53739e277834370f1e8c951b0ad)

* finatra-kafka-streams: Combine FinatraTransformer with FinatraTransformerV2. [cd455c43](https://github.com/twitter/finatra/commit/cd455c43d2b25415248228862f8b96991a494a54)

* finatra-thrift: The return type of `ReqRepDarkTrafficFilterModule#newFilter` has been changed from
  `DarkTrafficFilter[MethodIface]` to `Filter.TypeAgnostic`. [50184f1b](https://github.com/twitter/finatra/commit/50184f1ba1876dc4465ec0df5d8847692e87a0e5)

* finatra-kafka: Add lookupBootstrapServers function that takes timeout as a parameter.
  [e3426fb9](https://github.com/twitter/finatra/commit/e3426fb98a320b2bf9bd48ef62843337e9a928e4)

* finatra-thrift: If a Controller is not configured with exactly one endpoint
  per method, it will throw an AssertionError instead of logging an error message.
  An attempt to use non-legacy functionality with a legacy Controller will throw
  an AssertionError. [d1d6d1e0](https://github.com/twitter/finatra/commit/d1d6d1e079faa05b3ac1a8a42b792f56cd12f777)

* finatra-kafka: Add flags for controlling rocksdb internal LOG file growth.
  - `rocksdb.log.info.level` Allows the setting of rocks log levels
    `DEBUG_LEVEL`, `INFO_LEVEL`, `WARN_LEVEL`, `ERROR_LEVEL`, `FATAL_LEVEL`,
    `HEADER_LEVEL`.
  - `rocksdb.log.max.file.size` The maximal size of the info log file.
  - `rocksdb.log.keep.file.num` Maximal info log files to be kept.
  [c03a497c](https://github.com/twitter/finatra/commit/c03a497c0b96edae20671c4ab5ad754056a9d329)

* finatra-kafka: Add admin routes for properties and topology information
  - `/admin/kafka/streams/properties` Dumps the
    `KafkaStreamsTwitterServer#properties` as plain text in the TwitterServer
    admin page.
  - `/admin/kafka/streams/topology` Dumps the
    `KafkaStreamsTwitterServer#topology` as plain text in the TwitterServer
    admin page.
  [ecf2e54f](https://github.com/twitter/finatra/commit/ecf2e54f685a3f017175fb1711d2666439c9bfed)

* inject-server: EmbeddedTwitterServer that fails to start will now continue to
  throw the startup failure on calls to methods that require a successfully started server.
  [3ca4437c](https://github.com/twitter/finatra/commit/3ca4437cf9b2755692375de4e468d720a78836a4)

#### Fixed

* finatra-kafka-streams: `FinatraTopologyTester` did not set
  `TopologyTestDriver#initialWallClockTimeMs` on initialization causing diverging wall clock time
  when `TopologyTestDriver#advanceWallClockTime` advanced time. The divergence was between
  system time set by `org.joda.time.DateTimeUtils.setCurrentMillisFixed` and internal mock timer
  `TopologyTestDriver#mockWallClockTime`. `FinatraTopologyTester.inMemoryStatsReceiver` is reset on
  `TopologyFeatureTest#beforeEach` for all test that extend `TopologyFeatureTest`.
  [3b93a7d7](https://github.com/twitter/finatra/commit/3b93a7d7d0316d49489cf7882d0a424278d66cd7)

* finatra-kafka-streams: Improve watermark assignment/propagation upon reading the first
  message and when caching key value stores are used. [9aa12b8d](https://github.com/twitter/finatra/commit/9aa12b8db05360853443cb60d975423e8af8048b)

* finatra-jackson: Support inherited annotations in case class deserialization. Case class
  deserialization support does not properly find inherited Jackson annotations. This means
  that code like this:

  ```
  trait MyTrait {
    @JsonProperty("differentName")
    def name: String
  }
  case class MyCaseClass(name: String) extends MyTrait
  ```

  would not properly expect an incoming field with name `differentName` to parse into the
  case class `name` field. This commit provides support for capturing inherited annotations
  on case class fields. Annotations processed in order, thus if the same annotation appears
  in the class hierarchy multiple times, the value configured on the class will win otherwise
  will be in the order of trait linearization with the "last" declaration prevailing.
  [6237ff86](https://github.com/twitter/finatra/commit/6237ff86718e6e91fd0a5174fa17718fa740005f)

* finatra: Remove extraneous dependency on old `javax.servlet` ServletAPI dependency.
  The fixes #478. [85100952](https://github.com/twitter/finatra/commit/851009524e0a9f9d40fbc1ef97a0d16ccd93dac5)

#### Closed

### [Scrooge](https://github.com/twitter/scrooge/) ###

No Changes

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

No Changes

### [Util](https://github.com/twitter/util/) ###

#### New Features

* util-core: updated `Reader#fromFuture` to resolve its `onClose` when reading of end-of-stream.
  [f2a05474](https://github.com/twitter/util/commit/f2a05474ec41f34146d710bdc2a789efd6da9d21)

* util-core: Added `Reader.flatten` to flatten a `Reader[Reader[_]]` to `Reader[_]`,
  and `Reader.fromSeq` to create a new Reader from a Seq. [a49bab4d](https://github.com/twitter/util/commit/a49bab4db50b09f2516805cb82a318d6b0557c8c)

* util-core: Added `Duration.fromMinutes` to return a `Duration` from a given number of minutes.
  [eda0b390](https://github.com/twitter/util/commit/eda0b390f3ac61fc3dd01df6255c18ef807f6920)

* util-core: If given a `Timer` upon construction, `c.t.io.Pipe` will respect the close
  deadline and wait the given amount of time for any pending writes to be read. [0a142872](https://github.com/twitter/util/commit/0a142872237b2709c1228bcedf9441cde2164af6)

* util-core: Optimized `ConstFuture.proxyTo` which brings the performance of
  `flatMap` and `transform` of a `ConstFuture` in line with `map`. [de4cebda](https://github.com/twitter/util/commit/de4cebda30c90f2461990e623e8a842f57249534)

* util-core: Experimental toggle (com.twitter.util.BypassScheduler) for speeding up
  `ConstFuture.map` (`transformTry`). The mechanism, when turned on, runs map operations
  immediately (why not when we have a concrete value), instead of via the Scheduler, where it may
  be queued and potentially reordered, e.g.:
  `f.flatMap { _ => println(1); g.map { _ => println(2) }; println(3) }` will print `1 2 3`,
  where it would have printed `1 3 2`. [aeafba1a](https://github.com/twitter/util/commit/aeafba1a4f547dc0e543a3bcea596ceb78ff4e63)

* util-security: `Pkcs8KeyManagerFactory` now supports a certificates file which contains multiple
  certificates that are part of the same certificate chain. [337e270f](https://github.com/twitter/util/commit/337e270f8fbdb5dd76ec01573e5262c0ab2054bd)

#### Bug Fixes

* util-core: Fixed the behavior in `c.t.io.Reader` where `Reader#flatMap` fails to propagate
  parent reader's `onClose`. [f2a05474](https://github.com/twitter/util/commit/f2a05474ec41f34146d710bdc2a789efd6da9d21)

#### Runtime Behavior Changes

* util-core: Closing a `c.t.io.Pipe` will notify `onClose` when the deadline has passed whereas
  before the pipe would wait indefinitely for a read before transitioning to the Closed state.
  [0a142872](https://github.com/twitter/util/commit/0a142872237b2709c1228bcedf9441cde2164af6)

* util-core: Don't allow `AsyncSemaphore` `Permit`s to be released multiple times. Before it was
  possible to release a permit more than once and incorrectly remove waiters from the queue.
  With this change, the `release` permit operation is idempotent. [ea24c951](https://github.com/twitter/util/commit/ea24c9510623bdc4d0e35f21fa4ba2c7a66d4279)

#### Breaking API Changes

* util-core: Remove `c.t.u.CountDownLatch` which is an extremely thin shim around
  `j.u.c.CountDownLatch` that provides pretty limited value.  To migrate to `j.u.c.CountDownLatch`,
  instead of `c.t.u.CountDownLatch#await(Duration)`, please use
  `j.u.c.CountDownLatch#await(int, TimeUnit)`, and instead of
  `c.t.u.CountDownLatch#within(Duration)`, please throw an exception yourself after awaiting.
  [b9914f15](https://github.com/twitter/util/commit/b9914f15b14e28cc6705cc6b5c876b22087f326b)

* util-core: Deprecated conversions in `c.t.conversions` have new implementations
  that follow a naming scheme of `SomethingOps`. [df397f53](https://github.com/twitter/util/commit/df397f5338fb608d20e103307cb57985428fce47)

  - `percent` is now `PercentOps`
  - `storage` is now `StorageUnitOps`
  - `string` is now `StringOps`
  - `thread` is now `ThreadOps`
  - `time` is now `DurationOps`
  - `u64` is now `U64Ops`

* util-collection: Delete util-collection.  We deleted `GenerationalQueue`, `MapToSetAdapter`, and
  `ImmutableLRU`, because we found that they were of little utility.  We deleted `LruMap` because it
  was a very thin shim around a `j.u.LinkedHashMap`, where you override `removeEldestEntry`.  If you
  need `SynchronizedLruMap`, you can wrap your `LinkedHashMap` with
  `j.u.Collection.synchronizedMap`.  We moved `RecordSchema` into finagle-base-http because it was
  basically only used for HTTP messages, so its new package name is `c.t.f.http.collection`.
  [60eff0a4](https://github.com/twitter/util/commit/60eff0a430fe16912accc5dec4b8c9f574ddc588)

* util-core: Rename `BlacklistStatsReceiver` to `DenylistStatsReceiver`. [ed3f7069](https://github.com/twitter/util/commit/ed3f7069ffd5640e53776b09bb490b09fd1b8b25)

* util-core: `Buf.Composite` is now private. Program against more generic, `Buf` interface instead.
  [41e24395](https://github.com/twitter/util/commit/41e24395a0d38c2c64c5451a358e7e130a93f6fe)

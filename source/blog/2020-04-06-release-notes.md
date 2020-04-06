---
layout: post
title: April 2020 Release Notes - Version 20.04.0
published: true
post_author:
  display_name: Ian Bennett
  twitter: enbnt
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

In these unprecedented times, we wish for nothing but your health and safety. April showers 🌦️ bring May flowers 🌻, so #StayAtHome and fill some time reading about some of the changes in our latest release.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

- finagle-thrift/thriftmux: Thrift and ThriftMux client side can set a sharable
  TReusableBuffer by `withTReusableBufferFactory`. [9213ca35](https://github.com/twitter/finagle/commit/9213ca351a949d270e71169729b725e82914888b)

#### Breaking API Changes

- finagle-partitioning: Rename `c.t.finagle.partitioning.CacheNode` and `CacheNodeMetadata`
  to `c.t.finagle.partitioning.PartitionNode` and `PartitionNodeMetadata`. [d32f0c25](https://github.com/twitter/finagle/commit/d32f0c25ce4ead094c3bce7046872ff1a6195b32)

- finagle-partitioning: Rename `c.t.finagle.partitioning.KetamaClientKey` to `HashNodeKey`
  [2d0cd33e](https://github.com/twitter/finagle/commit/2d0cd33ed8ff0b267465f52b0864462dd1225df1)

#### Bug Fixes

- finagle-base-http: RequestBuilder headers use SortedMap to equalize keys in different caps.
  `setHeader` keys are case insensitive, the last one wins. [535f324c](https://github.com/twitter/finagle/commit/535f324c8255f87f7848ad927759dac63888ad22)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

- inject-app: Add Java-friendly `main` to `EmbeddedApp`. [4b40075d](https://github.com/twitter/finatra/commit/4b40075d75a8499572872179309fea6540d61a3a)

- finatra-kafka: Expose timeout duration in KafkaProducerConfig dest(). [c5340a97](https://github.com/twitter/finatra/commit/c5340a97d6d6521890faf888b62fff2efd99b7d7)

#### Changed

- finatra-validation|jackson: (BREAKING API CHANGE) Introduced new case class validation library
  inspired by JSR-380 specification. The new library can be used as its own to validate field and
  method annotations for a case class. The library is also automatically integrated with Finatra's
  custom `CaseClassDeserializer` to efficiently apply per field and method validations as request
  parsing is performed. However, Users can easily turn off validation during request parsing with
  the setting `noValidation` in their server configurations. For more information, please checkout
  `Finatra User's Guide <https://docbird.twitter.biz/finatra/user-guide/index.html>`__.
  [d874b1a9](https://github.com/twitter/finatra/commit/d874b1a92cd2cc257bf0d170cfb46a486df3fb5d)


### [Util](https://github.com/twitter/util/) ###

#### New Features

- util-core: When looking to add idempotent close behavior, users should mix in `CloseOnce` to
  classes which already extend (or implement) `Closable`, as mixing in `ClosableOnce` leads to
  compiler errors. `ClosableOnce.of` can still be used to create a `ClosableOnce` proxy of an
  already instantiated `Closable`. Classes which do not extend `Closable` can still
  mix in `ClosableOnce`. [43671464](https://github.com/twitter/util/commit/43671464bd0bcb925d970370d45eaa9e84400ccb)

#### Breaking API Changes

- util-hashing: Rename
   `c.t.hashing.KetamaNode` => `HashNode`,
   `c.t.hashing.KetamaDistributor` => `ConsistentHashingDistributor`.
  [f595ed97](https://github.com/twitter/util/commit/f595ed971acacd2ccac84a49053e6b737cff860d)


### [Twitter Server](https://github.com/twitter/twitter-server/) ###

- No Changes

### [Scrooge](https://github.com/twitter/scrooge/) ###

- No Changes



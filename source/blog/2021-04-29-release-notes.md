---
layout: post
title: April 2021 Release Notes - Version 21.4.0
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Fresh off the press, **April 2021 release** of Twitter CSL libraries. Enjoy!

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features ####

-   finagle-core: Introduce a new ResponseClassifier ('IgnoreIRTEs') that treats
    com.twitter.finagle.IndividualRequestTimeoutExceptions as ResponseClass.Ignored.
    This response classifier is useful when a client has set a super low RequestTimeout and
    receiving a response is seen as 'best-effort'. [e897bd67](https://github.com/twitter/finagle/commit/e897bd673a088c196e5ee4c8cc162e5adaa78583)
-   finagle-mysql: Introduce support of opportunistic TLS to allow mysql clients
    with enabled TLS to speak over encrypted connections with MySQL servers where
    TLS is on, and fallback to plaintext connections if TLS is switched off on
    the server side. [e02495aa](https://github.com/twitter/finagle/commit/e02495aa6ba58f3a6e4e73d81acc9f653ed78481)

#### Runtime Behavior Changes ####

-   finagle-core: The "failures" counter is changed to be created eagerly, when no failure
    happens, the counter value is 0. [d81a57c6](https://github.com/twitter/finagle/commit/d81a57c615b0486df8f34415d55e1812fd223c5b)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed ####

-   http-core: Add support to build a multipart/form-data POST request in Finatra RequestBuilder.
    [8d2d8c58](https://github.com/twitter/finatra/commit/8d2d8c58564135ce048ad5abb5c0daa07eb17ef1)
-   finatra-kafka-streams: Update AsyncTransformer to support threadpools. [0498a06a](https://github.com/twitter/finatra/commit/0498a06a80bfbd1410d251cd47131d68490599f6)
-   finatra-kafka-streams: Set kafka.producer.acks=all by default [cce382d9](https://github.com/twitter/finatra/commit/cce382d96714d1c8e38da052763f523a9c8485ae)

### [Util](https://github.com/twitter/util/) ###

#### Runtime Behavior Changes ####

-   util-reflect: Memoize c.t.util.reflect.Types\#isCaseClass computation. [9319a683](https://github.com/twitter/util/commit/9319a68358146eae433ff9105c5734831652054a)

#### Breaking API Changes ####

-   util-stats: Added a methods c.t.f.stats.Counter\#metadata: Metadata,
    c.t.f.stats.Stat\#metadata: Metadata, and c.t.f.stats.Gauge\#metadata:
    Metadata to make it easier to introspect the constructed metric. In
    particular, this will enable constructing Expressions based on the full name
    of the metric. If you don't have access to a concrete Metadata instance
    (like MetricBuilder) for constructing a Counter, Stat, or Gauge, you can
    instead supply NoMetadata. [9968ad40](https://github.com/twitter/util/commit/9968ad4022f7d55fdb8c4df28e1059d2c5c0f634)

#### New Features

-   util-stats: Added a com.twitter.finagle.stats.Metadata abstraction, that can
    be either many com.twitter.finagle.stats.Metadata, a MetricBuilder, or a
    NoMetadata, which is the null Metadata. This enabled constructing
    metadata for counters that represent multiple counters under the hood.
    [9968ad40](https://github.com/twitter/util/commit/9968ad4022f7d55fdb8c4df28e1059d2c5c0f634)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

-   Change Metrics Metadata Endpoint to return a histogram's metadata when queried using the /admin/metrics.json
    full (suffixed) histogram name as the value for the name argument. [7ffed11c](https://github.com/twitter/twitter-server/commit/7ffed11c5c38187b2d33ce9271c6b8a4f7e4fdf9)

### [Scrooge](https://github.com/twitter/scrooge/) ###

No Changes. Just the version bump.

### Changelogs ###

* [Finagle 21.4.0][finagle]
* [Finatra 21.4.0][finatra]
* [Util 21.4.0][util]
* [Scrooge 21.4.0][scrooge]
* [TwitterServer 21.4.0][twitterserver]

[finagle]: https://github.com/twitter/finagle/blob/finagle-21.4.0/CHANGELOG.rst
[finatra]: https://github.com/twitter/finatra/blob/finatra-21.4.0/CHANGELOG.rst
[util]: https://github.com/twitter/util/blob/util-21.4.0/CHANGELOG.rst
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-21.4.0/CHANGELOG.rst
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-21.4.0/CHANGELOG.rst

---
layout: post
title: ☃️ February 2021 Release Notes - Version 21.2.0
published: true
post_author:
  display_name: Yufan Gong
  twitter: yufangong
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Depends on which part of this planet you are in, you may grab a hot drink or bask in the sunshine. Here is our short and sweet February release.

### NOTE

All of our libraries are cross-building with Scala 2.13 in this release! Starting from the March Release, we will say good bye to Scala 2.11.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-zipkin-core: Record `zipkin.sampling_rate` annotation to track sampling
    rate at trace roots. [2269eb6b](https://github.com/twitter/finagle/commit/2269eb6b1a2e9290a5e17bd4283babb9a78f64e5)

-   finagle-core: Added variant of `c.t.f.Address.ServiceFactory.apply` that does not require
    specifying `c.t.f.Addr.Metadata` and defaults to `c.t.f.Addr.Metadata.empty`. [11971f0f](https://github.com/twitter/finagle/commit/11971f0f5ac611984e8f68890b209a739445b156)

-   finagle-core: Added variant of `c.t.f.Name.bound` which takes a `c.t.f.Service` as a parameter.
    Tying a `Name` directly to a `Service` can be extremely useful for testing the functionality
    of a Finagle client. [1422ffd5](https://github.com/twitter/finagle/commit/1422ffd5b35cfe01374b90122b671b2c69043ad7)

-   finagle-mux: Added variant of `c.t.f.mux.Request.apply` and `c.t.f.mux.Requests.make` which takes
    only the body of the `Request` (in the form of `c.t.io.Buf`) as a parameter. This is useful for
    when the path value of a `Request` is not used by the server (e.g. testing). [3ca46304](https://github.com/twitter/finagle/commit/3ca463044cddf936eb4f79a50f63c6ddf4e5743b)

#### Runtime Behavior Changes

-   finagle-memcached: The log level of messages pertaining to whether a Memcached client is using the
    older non-partitioned or the newer partitioned version has been lowered. These messages are no
    longer written at an 'info' level. [4bce560a](https://github.com/twitter/finagle/commit/4bce560aa1773964c5acbd16142763a697aa873f)

### [Finatra](https://github.com/twitter/finatra/)

#### Changed

-   finatra: all subprojects cross-building with 2.13.1. [7deb1153](https://github.com/twitter/finatra/commit/7deb11535e5c9eb0787326e64dc44bf060b935df)

-   kafkaStreams: Enables cross-build for 2.13.1 for projects kafkaStreamsStaticPartitioning,
    kafkaStreamsPrerestore, and kafkaStreamsQueryableThrift. [c9e5bda1](https://github.com/twitter/finatra/commit/c9e5bda15a01b5b59daa45be2ea15d50fa999e63)

### Changelogs ###

* [Finagle 21.2.0][finagle]
* [Util 21.2.0][util]
* [Scrooge 21.2.0][scrooge]
* [TwitterServer 21.2.0][twitterserver]
* [Finatra 21.2.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-21.2.0/CHANGELOG.rst
[util]: https://github.com/twitter/util/blob/util-21.2.0/CHANGELOG.rst
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-21.2.0/CHANGELOG.rst
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-21.2.0/CHANGELOG.rst
[finatra]: https://github.com/twitter/finatra/blob/finatra-21.2.0/CHANGELOG.rst

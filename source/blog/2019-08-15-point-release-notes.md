---
layout: post
title: Util August 2019 Point Release Notes - Version 19.8.0
published: true
post_author:
  display_name: Yufan Gong
  twitter: yufangong
tags: Releases, Util
---

A point release to publish [Util](https://github.com/twitter/util/) on scala 2.13.

#### New Features

-   util: Enables cross-build for 2.13.0. [d5d20cc3](https://github.com/twitter/util/commit/d5d20cc337710b07343eb09ecdab005968c97879)

#### Java Compatibility

-   util-stats: In `c.t.finagle.stats.AbstractStatsReceiver`, the `counter`, `stat` and
    `addGauge` become final, override `counterImpl`, `statImpl` and `addGaugeImpl` instead.
    [d5d20cc3](https://github.com/twitter/util/commit/d5d20cc337710b07343eb09ecdab005968c97879)

-   util-core:
   `c.t.concurrent.Offer.choose`,
   `c.t.concurrent.AsyncStream.apply`,
   `c.t.util.Await.all`,
   `c.t.util.Closable.sequence` become available to java for passing varargs. [d5d20cc3](https://github.com/twitter/util/commit/d5d20cc337710b07343eb09ecdab005968c97879)

-   util-stats:
   `c.t.finagle.stats.StatsReceiver.provideGauge` and `addGauge` become available to java for
    passing varags. [d5d20cc3](https://github.com/twitter/util/commit/d5d20cc337710b07343eb09ecdab005968c97879)

#### Breaking API Changes

-   util-core: (not breaking) `c.t.util.Future.join` and `c.t.util.Future.collect` now take
    `Iterable[Future[A]]` other than Seq. [d5d20cc3](https://github.com/twitter/util/commit/d5d20cc337710b07343eb09ecdab005968c97879)

-   util-core:  Revert the change above, in `c.t.util.Future`, `collect`, `collectToTry` and `join`
    take `scala.collection.Seq[Future[A]]`. [e451e3b2](https://github.com/twitter/util/commit/e451e3b28dd96e1ebc72aebe679f7c2c0f00fd26)

-   util-core: `com.twitter.util.Event#build` now builds a Seq of events. `Event#buildAny` builds
    against any collection of events. [d5d20cc3](https://github.com/twitter/util/commit/d5d20cc337710b07343eb09ecdab005968c97879)

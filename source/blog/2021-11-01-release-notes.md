---
layout: post
title: October 2021 Release Notes - Version 21.10.0
published: true
post_author:
  display_name: Joy Bestourous
  twitter: joybestou
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Didn't get enough of Halloween this season? Here's an extra treat: the October release 🎃🍬🍫

[Util](https://github.com/twitter/util/)
========================================

New Features
------------

-   util-core: Add convenience methods to convert to java.time.ZonedDateTime and
    java.time.OffsetDateTime. toInstant, toZonedDateTime, and toOffsetDateTime also preserve
    nanosecond resolution. [c2750767](https://github.com/twitter/util/commit/c2750767b44b3ab329028b4e3617b78b9124696e)
-   util-stats: Moved c.t.finagle.stats.LoadedStatsReceiver and c.t.finagle.stats.DefaultStatsReceiver
    from the finagle-core module to util-stats. [266b69bd](https://github.com/twitter/util/commit/266b69bd1e23e1fe3bb2b73aa73168ee5f11c8fc)

[Scrooge](https://github.com/twitter/scrooge/)
==============================================

No Changes

[Finagle](https://github.com/twitter/finagle/)
==============================================

Breaking API Changes
--------------------

-   finagle-core: c.t.f.loadbalancer.distributor.AddressedFactory has been removed. Use
    c.t.f.loadbalancer.EndpointFactory directly instead. [4043382a](https://github.com/twitter/finagle/commit/4043382a1fc81fa7de1c2491eba9392b01260e77)

-   finagle-core: Moved c.t.finagle.stats.LoadedStatsReceiver and c.t.finagle.stats.DefaultStatsReceiver
    from the finagle-core module to util-stats. [709c0c37](https://github.com/twitter/finagle/commit/709c0c37429c1f047cf53360e32e3d4cfea0bfed)

[Finatra](https://github.com/twitter/finatra/)
==============================================

Changed
-------

-   http-server: Add versions of HttpRouter\#filter which accept a Guice TypeLiteral to
    aid Java users in being able to apply generically typed Filters obtained from the object graph.
    [46a45c4b](https://github.com/twitter/finatra/commit/46a45c4b1340ca8c4f5ab801a8589a3979d90c33)

[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

No Changes

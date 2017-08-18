---
layout: post
title: Finagle 7 Release Notes
published: true
post_author:
  display_name: Daniel Schobel
  twitter: dschobel
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The August release is here and brings a major version bump for both Finagle and Util to v7! :cake: :cake: :cake:

Over the last few years Finagle has had an extensive internal overhaul to support Netty 4 along with a rewrite of all its protocols so now as the last traces of Netty 3 have been removed from finagle-core we felt the time was right to celebrate with a shiny new major version.

(Fun fact: Finagle's last major version bump came almost 5 years ago, a simpler time when 'Gangnam Style' was still dominating the charts.)

Without further ado, here are the highlights:

[Finagle 7.0.0][finagle], [Finatra 2.12.0][finatra], [Scrooge 4.19.0][scrooge], [TwitterServer 1.31.0][twitterserver], and [Util 7.0.0][util].


### Finagle ###

In addition to the Netty dependency cleanup, Finagle gets new [Tunables](https://twitter.github.io/finagle/guide/Configuration.html#tunables) api for configuring dynamic timeouts and finagle-stats drops a hard-to-kill legacy dependency on [Commons](https://github.com/twitter/commons)

* finagle-core: Finagle is now fully decoupled from Netty 3. [49d4d0d](https://github.com/twitter/finagle/commit/49d4d0df6d7e0a5dcac85ca6564efcae101c8e04)
* finagle-mux: Introduce a new more efficient message decoder. [f432bd4](https://github.com/twitter/finagle/commit/f432bd443c4998431e4cbfeb6934916e7310c9a8)
* finagle-netty4: Netty 4 transports now use pooled allocators by default. [a70b4b9](https://github.com/twitter/finagle/commit/a70b4b92bf025e30284d4ef96d1d3150c298ef97)
* finagle-stats: No longer backed by commons metrics, now its own thing. [a647fb9](https://github.com/twitter/finagle/commit/a647fb9cb051ddccaf8efff1533844264cdcc1d1)
* finagle-tunable: `StandardTunableMap` is now public. Users can access file-based, in-memory,
    and service-loaded tunable values using the map.
    See [tunables](https://twitter.github.io/finagle/guide/Configuration.html#tunables) for details. [f07ebb6](https://github.com/twitter/finagle/commit/f07ebb6475ec38ee8ef77f526c724d98c2b2d95e)


### Scrooge ###

* scrooge-generator: Generated Java code now is using `c.t.s.TReusableBuffer` to reduce
  object allocations. [4cd9ee7](https://github.com/twitter/scrooge/commit/4cd9ee7017d75cec068f5acf14b97bc2955474ec)
* scrooge-generator: Generated Cocoa code now supports modular frameworks and 
  removes some compiler warnings about implicit casts. [f48cd56](https://github.com/twitter/scrooge/commit/f48cd56e9398305ee7e280e161b0423da4131845)
  
### Util ###
Util's StatsReceivers learned about Verbosity Levels as a way to reduce the number of exported metrics during normal operations.

* util-stats: Introducing Verbosity Levels for StatsReceivers [fa91412](https://github.com/twitter/finagle/commit/fa91412d243eae8146465a439d69c78a1caca9c6)
* util-core: Added `c.t.util.SlowProbeProxyTimer` for monitoring the duration
    of execution for timer tasks. [7c8425d](https://github.com/twitter/util/commit/7c8425d95e45771ff88e8d23857f9f8026bb09aa)
* util-events: This module is deprecated and will be removed in an upcoming
    release. [c465fdb](https://github.com/twitter/util/commit/c465fdbb2a781ad009f134305be74e49127e1cb1)

### Dependencies ###
Netty has been upgraded to 4.1.12

### Changelogs ###

* [Finagle 7.0.0][finagle]
* [Util 7.0.0][util]
* [Scrooge 4.19.0][scrooge]
* [TwitterServer 1.31.0][twitterserver]
* [Finatra 2.12.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-7.0.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-7.0.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-4.19.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-1.31.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-2.12.0/CHANGELOG.md

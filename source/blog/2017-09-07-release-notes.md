---
layout: post
title: September 2017 Release Notes
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The September releases are here.

[Finagle 7.1.0][finagle], [Finatra 2.13.0][finatra], [Scrooge 4.20.0][scrooge], [TwitterServer 1.32.0][twitterserver], and [Util 7.1.0][util].

### Finagle ###

New Features:

* finagle-core: If a `c.t.u.tunable.Tunable` request or total timeout has been configured
on a client which uses `a c.t.f.client.DynamicTimeout` filter, the current value of tunable will
be used in the case of no dynamic timeout set for a request. [4a419c5e](https://github.com/twitter/finagle/commit/4a419c5ec91f634c54d3d8577800100e4d7756be)

* finagle-core: `FailedFastException` now captures the throwable that caused it. [f4efc2d1](https://github.com/twitter/finagle/commit/f4efc2d10d080e950ca2bd96112f95caaa286db6)

* finagle-redis: Add support for `DBSIZE` command. [8f7efec0](https://github.com/twitter/finagle/commit/8f7efec0b860ab2dddff3beadf80c303bcb2522d)

Bug Fixes:

* finagle-core: Unregister `ServerRegistry` entry on `StackServer#close`. A
`StackServer` entry is registered in the `ServerRegistry` on serve of the
server but never unregistered. It is now unregistered on close of
the `StackServer`. [5d8dd660](https://github.com/twitter/finagle/commit/5d8dd660dd18ee58ea7cf470c7826145ae10cb05)

* finagle-netty4: `Netty4ClientEngineFactory` and `Netty4ServerEngineFactory` now
properly load all chain certificates when the `SslClientConfiguration` or
`SslServerConfiguration` uses `KeyCredentials.CertKeyAndChain` instead of just the
first one in the file. [93618f4f](https://github.com/twitter/finagle/commit/93618f4fe7849d775e422d7c1d6bbb5b8f0ba1b5)

Runtime Behavior Changes:

* finagle-stats: Verbosity levels are now respected: debug-metrics aren't exported
by default. [6c666ab5](https://github.com/twitter/finagle/commit/6c666ab5c3363ae5bd22b0fbd96f33995fe36ac7)

* finagle-netty4: `ChannelTransport` no longer considers the `Channel.isWritable` result
when determining status. [ce811a20](https://github.com/twitter/finagle/commit/ce811a206411ea61b0fb309306614e3056b88908)

### Finatra ###

* finatra-http: No longer depends on `bijection-util`. [4afe23eb](https://github.com/twitter/finatra/commit/4afe23eba16d3b836637e84feedf28cb740290f7)

### Dependencies ###

* Netty has been updated to 4.1.14 [f28705d5](https://github.com/twitter/finagle/commit/f28705d556077cbd56b19ce90eba35be7203ad07)

* Guava has been updated to 23.0 [ffdda1a0](https://github.com/twitter/finagle/commit/ffdda1a0899e6a42082ad0ea81983dabb618d32f)

### Changelogs ###

* [Finagle 7.1.0][finagle]
* [Finatra 2.13.0][finatra]
* [Scrooge 4.20.0][scrooge]
* [TwitterServer 1.32.0][twitterserver]
* [Util 7.1.0][util]

[finagle]: https://github.com/twitter/finagle/blob/finagle-7.1.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-2.13.0/CHANGELOG.md
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-4.20.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-1.32.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-7.1.0/CHANGES

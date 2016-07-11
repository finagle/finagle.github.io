---
layout: post
title: Finagle 6.36 Release Notes
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Util, Ostrich, Scrooge, TwitterServer
---

This is Finagle's first release only for Java 8 and Scala 2.11. Since the previous release, the team
has been focusing on the Netty 4 migration as well as eliminating some technical debt.

### Towards Netty 4

The team is firing on all cylinders towards Netty 4 support in Finagle. This milestone brings
*beta* (not yet widely used in production) Netty 4 support to Mux/ThriftMux, HTTP 1.1, and
SOCKS5 (proxy).

In the meantime, we're part way through migrating the MySQL, Memcached, and Redis protocol.
Everything is going quite smoothly (except for a couple of
[shortcuts we had to take with Redis][redis-api]) and we're super positive about having an
experimental Netty 4 support for those protocols in the next release.

### Killing Tech Debt

There was a tech debt sprint this milestone where we fixed plenty of broken windows. To mention a few: 

- replace our own version of `NoStacktrace` with the Scala version
- replace our own fork of JSR166e with the JDK8 version
- clean up duplicated stats: `closechans`, `closed`, and `load`
- finagle-zipkin is now split into two packages: finagle-zipkin (implementation) and
  finagle-zipkin-core (core data types and interfaces)

### Side Effects are Side Effects

There is one runtime change we think it's worth highlighting here. We changed the behaviour of
`.onSuccess`/`.onFailure` combinators so that they don't fail a request if the passed function
throws an exception. Please, consider refactoring if your application has been relying on that
behaviour.

### Changelog

* [Finagle 6.36][finagle]
* [Util 6.35][util]
* [Scrooge 4.8][scrooge]
* [TwitterServer 1.21][ts]
* Ostrich 9.19 (no changes, only dependency bump)

[redis-api]: https://groups.google.com/forum/#!topic/finaglers/LOCVA0nhcaU
[finagle]: https://github.com/twitter/finagle/releases/tag/finagle-6.36.0
[util]: https://github.com/twitter/util/releases/tag/util-6.35.0
[ts]: https://github.com/twitter/twitter-server/releases/tag/twitter-server-1.21.0
[scrooge]: https://github.com/twitter/scrooge/releases/tag/scrooge-4.8.0
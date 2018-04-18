---
layout: post
title: 🦋 Spring Review
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

It’s time to take a look back at what went down with Finagle, Finatra & friends over the past three months, and get an idea of what’s to come. As projects don’t tend to care about quarterly boundaries, some of our work is a work in progress.

#### Efficiency

Low level machinery:

* LIFO `Promise` continuations are on, and most importantly, the extra overhead has been [ripped out](https://github.com/twitter/util/commit/bf47b55ff45a31bbd541f66257f2244df5c35f5b).
* `Buf` concatenation has been [optimized](https://github.com/twitter/util/commit/060a8d15bd5a3c9121e71ea3f9a1fb9974d4ab6f), and our ThriftMux throughput simulations saw a 2–4% increase.
* Made `Promise.poll` and `Promise.isDefined` [faster](https://github.com/twitter/util/commit/5197362634c6db982fdc0d181eed14cdd7090f4b).

#### Resiliency

After a few years of languishing with an experimental tag, backup requests have been rewritten and are killing tail latencies in production. [Read up](https://twitter.github.io/finagle/guide/MethodBuilder.html#backup-requests) and see if they can help your service.

HTTP/2 client work continues and we continue to find interesting things. Of note — it does not seem like many folks out on the internets have implemented cleartext h2 upgrades.

#### Operability

Our MySQL client received a number of usability fixes to it’s APIs ([1](https://github.com/twitter/finagle/commit/5a54f45da4b78f22ccc001164f7c3df5314b34ce), [2](https://github.com/twitter/finagle/commit/48f688d1b52ed51499eb3c693a4fe253a5b67100), [3](https://github.com/twitter/finagle/commit/d8e44b2dc4d4d5c7276c3daa2b937ce15a7321b9), [4](https://github.com/twitter/finagle/commit/f3676d3186fb5dddb4fc2a833c79094af5fb460e), [5](https://github.com/twitter/finagle/commit/ebde8ebe203a88b8cba481c39033dac3c71e02e9), [6](https://github.com/twitter/finagle/commit/c5bd6b975657782607ad33b73ea414661a54f544), [7](https://github.com/twitter/finagle/commit/f67978aaa48b7b65e20de787b0d84354cb5a968e)). There’s more planned, so stay tuned to this channel.

#### Tech Debt

[R.I.P. libthrift 0.5.0](https://github.com/twitter/scrooge/commit/997f2464ca04998ce5b7a73c56c7667d1754a01b)! We’ll be on version 0.10.0 for a bit before we upgrade to 0.11 which was released while we were already working on the upgrade.

Netty 3 still lives on due to HTTP cookies, but we’re chipping away at it.

------------

As always, please feel free to ask questions on
either the [Finagle](https://groups.google.com/forum/#!forum/finaglers) or
[Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists or on [Gitter](https://gitter.im/twitter/finagle).

See you this summer!

Kevin Oliver and team
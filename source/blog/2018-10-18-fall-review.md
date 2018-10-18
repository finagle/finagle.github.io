---
layout: post
title: Fall Update 🍂
published: true
post_author:
  display_name: Neuman Vong
  twitter: neuman
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Fall is here! If you live in Boulder, you might take a 🚶and [watch coyotes
hunt prairie dogs](https://twitter.com/davidjrusek/status/1050100034157637632).
The new season brings about a change of clothes, but what about a change of
code? Upgrade to the [latest Finagle
version](https://github.com/twitter/finagle/releases/latest) and enjoy the new
features, APIs, and bug fixes! Here's a breakdown of what's new.

**Developer experience**

- We continue evolving Reader/Writer APIs to make them more friendly for
  application-level development. This part is nearly done and our next step is
  to adopt said APIs in both Finagle and Finatra, providing their users with a
  seamless developer experience. ([1](https://github.com/twitter/finagle/commit/5242d49d8e6aa9041626311ae66405b2634136b2))
- Tunables are now observable via Vars. ([1](https://github.com/twitter/util/commit/94864832a593f5f75c696c8dab913ceba69e81dc))
- Lots of examples of how to use Future. ([1](https://github.com/twitter/util/commit/3e9d68fadfc8c0d008242245e06715491b46575b), [2](https://github.com/twitter/util/commit/6b41ef4711ede2dc1590725f6042da68f33fac5d))

**HTTP2**

MANY performance improvements. We no longer consider h2c
experimental! This will be on by default in the next few months.

**Resiliency**

- Thrift and ThriftMux servers now feature Response Classification to better
  indicate their success rate.
- New and improved Tracing. This work dramatically reduces the number of
  context lookups. ([1](https://github.com/twitter/finagle/commit/547cd86465109e6777d2afb98a7560d6a053b7b4), [2](https://github.com/twitter/finagle/commit/50c00d8847e0e5f3ade029ee3a51b5e2e795f115), [3](https://github.com/twitter/finagle/commit/33841d214af7506750d6106fdeb0d95fbd95cc42), [4](https://github.com/twitter/finagle/commit/5a5ceb63740480381a2a137474afa5c39ad23981), [5](https://github.com/twitter/finagle/commit/5a5ceb63740480381a2a137474afa5c39ad23981))
- Finatra security update. Jackson Upgraded 2.8.4 => 2.9.6, plugs
  [CVE-2017-7525](https://nvd.nist.gov/vuln/detail/CVE-2017-7525).

**Performance.**

- `Future.transform` creates a new `Promise` every time it is called, but
  sometimes we can operate directly on a `Try`, whose operations are much
  simpler and less costly. Since `transform` is fundamental to many other
  future operations, the result is faster futures. ([1](https://github.com/twitter/util/commit/3245a8e1a98bd5eb308f366678528879d7140f5e))
- Avoid unnecessary deep copies in Local.Context. ([1](https://github.com/twitter/util/commit/faaf0f2fe27520d47f896099bb8dc5f34b5d3c6a))
- Push is now default implementation for ThriftMux. We removed the previous
  implementation because we saw that Push improved throughput, CPU usage, and
  allocations. ([1](https://github.com/twitter/finagle/commit/c0a1f295f58d699a77142ea2720965b63203cc89), [2](https://github.com/twitter/finagle/commit/735a6bae3f8352b569ff153ec47d97a54914eee2), [3](https://github.com/twitter/finagle/commit/735a6bae3f8352b569ff153ec47d97a54914eee2), [4](https://github.com/twitter/finagle/commit/eedd1fd890da85c6efcdc0ff597e22055967d811))

**Netty3 cookies are dead, long live Netty4 cookies?**

We are _almost_ there. The last threshold to cross is decoupling cookie
validation logic. ([1](https://github.com/twitter/finagle/commit/5e5ea39079f0445fc8823f5947ea2e504574c564))

**Finatra.**

- Custom AsyncAppender with StatsReceiver integration
  ([1](https://twitter.github.io/finatra/user-guide/logging/asyncappender.html)).
- Better/easier configuration for https servers. ([1](https://github.com/twitter/finatra/commit/3c19b2df303a30fda254822dc97cb2372d2220b3)

**Travis-CI.** MANY stability improvements.

------------

Thanks for following along. If you'd like to know more about any one of these
updates, or if you have a question about them, join us on the
[Finagle](https://groups.google.com/forum/#!forum/finaglers) or
[Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists
or hop on [Gitter](https://gitter.im/twitter/finagle).


Happy coding,

Neuman and the Core Systems Libraries team

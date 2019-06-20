---
layout: post
title: June 2019 Release Notes - Version 19.6.0
published: true
post_author:
  display_name: Ruben Oanta
  twitter: rubenoanta
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Hey Finaglers,

We've cut a June release for our libraries! Here are some highlights:

`util-core`: Use Local at callback creation for a Future's interrupt handler rather than
the raiser's locals so that it is consistent with other callbacks. We believe the original
design can lead to confusing behavior and bugs and will eventually make this new behavior the
default. This functionality is currently disabled and can be enabled by a toggle
(com.twitter.util.UseLocalInInterruptible) by setting it to 1.0 if you would like
to try it out. [04cee8fb](https://github.com/twitter/util/commit/04cee8fb8e56e2566318abec74eefa59dfd8ad83)

`finagle-core`: For both, servers and clients, introduce a way to shift application-level future
callbacks off of IO threads, into a given `FuturePool` or `ExecutorService`.
Use `withExecutionOffloaded` configuration method (on a client or a server) to access
new functionality. This was always possible in an adhoc fashion using a future pool,
but we've now made it easier to do correctly and across an entire server or client.
This is coupled with some useful [docs](http://twitter.github.io/finagle/guide/ThreadingModel.html#threading-model)
that go into more details on Finagle's threading model and when/why you'd want to use
this feature. [40431bb4](https://github.com/twitter/finagle/commit/40431bb43526efb7450a254e95baf52eda5dc997)

`finagle-core`: Stats and retry modules use a ResponseClassifier to give hints for how to handle
failure (e.g., Is this a success or is it a failure? If it's a failure, may I retry the request?).
The stats module increments a success counter for successes, and increments a failure counter for
failures. But there isn't a way to tell the stats module to just do nothing. And, this is exactly
what the stats module should do (nothing) in the case of ignorable failures (e.g. backup request
cancellations). To represent these cases, we introduce a new ResponseClass: Ignorable. [256b79b8](https://github.com/twitter/finagle/commit/256b79b8c9b61144ca63b2d23940597588aeab9e)

`finatra-http`: Add c.t.inject.server.InMemoryStatsReceiverUtility which allows for testing
assertions on metrics captured within an embedded server's InMemoryStatsReceiver. Update the
Kafka tests and utilities to use the InMemoryStatsReceiverUtility and mark the
c.t.finatra.kafka.test.utilsInMemoryStatsUtil as deprecated. [f82afa58](https://github.com/twitter/finatra/commit/f82afa58c5832e2508d780ed7ab1f4eb9f7cc971)

`finatra`: Add an explicit dependency on com.sun.activation to allow for using
Finatra with JDK 11. This fixes [#484](https://github.com/twitter/finatra/issues/484). [5a7ccf31](https://github.com/twitter/finatra/commit/5a7ccf312f96f410ae0d96e77ba364faa460ccd8)

Be sure to checkout the full change log for each project to get more details:

https://github.com/twitter/util/releases/tag/util-19.6.0
https://github.com/twitter/finagle/releases/tag/finagle-19.6.0
https://github.com/twitter/twitter-server/releases/tag/twitter-server-19.6.0
https://github.com/twitter/scrooge/releases/tag/scrooge-19.6.0
https://github.com/twitter/finatra/releases/tag/finatra-19.6.0

-Ruben
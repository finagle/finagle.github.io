---
layout: post
title: Finagle Block Party
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Finagle, Util, TwitterServer
---

💔 **SPOILER ALERT:** you do not want to go to this party 💔

Blocking Finagle's event loop via calls to
[Await.result](http://twitter.github.io/util/docs/index.html#com.twitter.util.Await$@result[T](awaitable:com.twitter.util.Awaitable[T],timeout:com.twitter.util.Duration):T)
or
[Await.ready](http://twitter.github.io/util/docs/index.html#com.twitter.util.Await$@ready[T%3C:com.twitter.util.Awaitable[_]](awaitable:T):T)
will cause your application to experience unexpected slowness, a
decrease in throughput, and potentially deadlocks. Find out if our new
tools that identify the calls that cause service sadness are right for
you.

✮ *Why is blocking bad?*

Finagle uses Netty which is a network library built on an event loop.
When an event loop thread blocks, that thread can no longer do its
other asynchronous work. As such, blocking has effects that span
beyond the line of code that is doing the blocking. Removing blocking
code should help your service with throughput and latency.

✮ *How do I find out if my service is blocking?*

Blocking can happen in two ways, explicitly and implicitly. Explicit
blocking is when code synchronously waits on a Future from an event
loop thread. In Finagle, this is done by making calls to
[Await.result](http://twitter.github.io/util/docs/index.html#com.twitter.util.Await$@result[T](awaitable:com.twitter.util.Awaitable[T],timeout:com.twitter.util.Duration):T)
or
[Await.ready](http://twitter.github.io/util/docs/index.html#com.twitter.util.Await$@ready[T%3C:com.twitter.util.Awaitable[_]](awaitable:T):T).

If your service is running Finagle 6.37, there is now a gauge exported
as
[scheduler/blocking\_ms](http://twitter.github.io/finagle/guide/Metrics#scheduler)
which can be used to identify how much time is being spent. You can
verify that your service continues to operate correctly by checking
the new lint rule added to TwitterServer's
[/admin/lint](http://twitter.github.io/twitter-server/Admin.html#admin-lint)
admin endpoint.

Implicit blocking happens when your code runs a potentially expensive
operation, for example making network calls on the event loop thread
using a synchronous API. Unfortunately, these calls are difficult to
track down and we do not yet have any tooling to help on this front.

✮ *Bummer, it is blocking. How do I find out what’s blocking?*

You can do a deploy with an extra system property set that will log
the stacktraces for a fraction of the blocking calls. Given that the
code is about to block, the extra overhead of logging the stacktrace
shouldn't be a significant overhead. However, if your service has a
large amount of blocking, you may want to limit this fraction to avoid
filling up your logs. You can set it via
`-Dcom.twitter.concurrent.schedulerSampleBlockingFraction=$fraction`
where `$fraction` must be between `0.0` and `1.0`, inclusive.

This will output a log that should point you to the code doing the
blocking. For example in the stacktrace below, HttpServer.scala would
be the cause:

```
I 0812 21:39:31.743 THREAD18 TraceId:a2c1d94ae0029777: Scheduler blocked for 5004957 micros via the following stacktrace
com.twitter.concurrent.LocalScheduler$BlockingHere
  at com.twitter.concurrent.LocalScheduler$Activation.blocking(Scheduler.scala:216)
  at com.twitter.concurrent.LocalScheduler.blocking(Scheduler.scala:285)
  at com.twitter.concurrent.Scheduler$.blocking(Scheduler.scala:115)
  at com.twitter.util.Await$.result(Awaitable.scala:151)
  at com.twitter.util.Await$.result(Awaitable.scala:140)
  at com.twitter.example.HttpServer$$anonfun$4.apply(HttpServer.scala:28)
  at com.twitter.example.HttpServer$$anonfun$4.apply(HttpServer.scala:24)
  ...
```

✮ *How can I fix the blocking code?*

We recommend that applications use the [Future
combinators](http://twitter.github.io/finagle/guide/Futures.html#sequential-composition)
such as `flatMap`, `onSuccess`, `transform`, and so on. Sometimes this type
of change may not be feasible and in those cases you can use a
[FuturePool](https://github.com/twitter/util/blob/master/util-core/src/main/scala/com/twitter/util/FuturePool.scala)
to shift the blocking off of the event loop and onto a thread pool
that your application controls.

Please let us know if you have any questions, either by
getting in touch through [@finagle](https://twitter.com/finagle), the
[Finaglers mailing list](https://groups.google.com/forum/#!forum/finaglers),
or [chat](https://gitter.im/twitter/finagle).

Thanks for reading and we sincerely hope you don’t RSVP.

---
layout: post
title: Making application errors matter
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Finagle, Resiliency
---

Finagle’s new response classifiers improve client’s avoidance of
faulty nodes thus increasing your success rate. To get this benefit,
you must wire up the application’s rules into your clients and how to
do so is explained below.

First, a pop quiz — does Finagle treat an HTTP 500 response as a
success or failure? How about a Thrift Exception?

If you answered **failures**, sadly, you are in for a surprise. Finagle
lacks application level domain knowledge of what kinds of responses
are failures. Without this, Finagle uses a conservative policy and
treats all [`Returns`][Try] as successful
and all [`Throws`][Try] as failures. Unfortunately, both HTTP 500s and Thrift
Exceptions are `Returns`, and thus, successful responses.

By having you, the developers, give Finagle this application level
knowledge, it can then accurately track failures in its [failure
accrual module][failureaccrual] which directly helps your client’s success rate.
Finagle’s built-in [success rate][successrates] metrics (e.g. `clnt/tweetsvc/success`)
also become accurate and this in turn means you may be able remove
additional success rate metrics you may be wrapping on top of a
Finagle client.

In the future, we are considering wiring this into load balancing
which enables us to penalize servers which are returning failures or
[partial results][brownout].

### Cool story. How do I use it?

As of [release 6.33][release633] you wire up a [`ResponseClassifier`][responseclassifier]
to your client. For HTTP clients, using
[`HttpResponseClassifier.ServerErrorsAsFailures`][httpsrverrors] often works great as it
classifies any HTTP 5xx response code as a failure. For
Thrift/ThriftMux clients you may want to use
[`ThriftResponseClassifier.ThriftExceptionsAsFailures`][thriftexceptions] which classifies
any deserialized Thrift Exception as a failure. For a large set of use
cases these should suffice. Classifiers get wired up to your client in
a straightforward manner, for example:

```scala
// Scala
import com.twitter.finagle.ThriftMux
import com.twitter.finagle.builder.ClientBuilder
import com.twitter.finagle.thrift.service.ThriftResponseClassifier

// Discoverable Parameters API
ThriftMux.client
  ...
  .withResponseClassifier(ThriftResponseClassifier.ThriftExceptionsAsFailures)

// ClientBuilder API
ClientBuilder
  ...
  .responseClassifier(ThriftResponseClassifier.ThriftExceptionsAsFailures)
```

```java
// Java
import com.twitter.finagle.Http;
import com.twitter.finagle.builder.ClientBuilder;
import com.twitter.finagle.http.service.HttpResponseClassifier;

// Discoverable Parameters API
Http.client()
  ...
  .withResponseClassifier(HttpResponseClassifier.ServerErrorsAsFailures());

// ClientBuilder API
ClientBuilder
  ...
  .responseClassifier(HttpResponseClassifier.ServerErrorsAsFailures());
```

If a classifier is not specified on a client or if a user’s classifier
isn’t defined for a given request/response pair then
[`ResponseClassifier.Default`][defaultclassifier] is used. This gives us the same behavior
Finagle had prior to classification — responses that are `Returns` are
successful and `Throws` are failures.

### Rad. How do I write a custom classifier?


To do this we should understand the few classes used. A
`ResponseClassifier` is a `PartialFunction` from [`ReqRep`][reqrep] to
[`ResponseClass`][responseclass].

Let’s work our way backwards through those, beginning with
`ResponseClass`. This can be either `Successful` or `Failed` and those
values are self-explanatory. There are three constants which will
cover the vast majority of usage: `Success`, `NonRetryableFailure` and
`RetryableFailure`. While as of today there is no distinction made
between retryable and non-retryable failures, it was a good
opportunity to lay the groundwork for use in the future.

A `ReqRep` is a request/response struct with a request of type `Any`
and a response of type `Try[Any]`. While the lack of typing may
initially disturb you, our hope is that it is not an issue in
practice. While all of this functionality is called response
classification, you’ll note that classifiers make judgements on both a
request and response.

Writing a custom `PartialFunction` is easy in Scala given its syntactic
sugar. As with many things it is a bit more work from Java but is
doable. Here is an example that counts HTTP 503s as failures (for Java
examples, take a look at [`HttpResponseClassifierCompilationTest`][javaexample1]
and [`ResponseClassifierCompilationTest`][javaexample2]):

```scala
// Scala
import com.twitter.finagle.http
import com.twitter.finagle.service.{ReqRep, ResponseClass, ResponseClassifier}
import com.twitter.util.Return
val classifier: ResponseClassifier = {
  case ReqRep(_, Return(r: http.Response)) if r.statusCode == 503 =>
    ResponseClass.NonRetryableFailure
}
```

Note that this `PartialFunction` isn’t total which is ok due to
Finagle always using user defined classifiers in combination with
`ResponseClassifier.Default` which will cover all cases.

Thrift and ThriftMux classifiers require a bit more care as the
request and response types are not as obvious. This is because there
is only a single `Service` from `Array[Byte]` to `Array[Byte]` for all the
methods of an IDL’s service. To make this workable, there is support
in [Scrooge][scrooge] and `Thrift`/`ThriftMux.newService` and
`Thrift`/`ThriftMux.newClient` code to deserialize the responses into the
expected application types so that classifiers can be written in terms
of the Scrooge generated request type, `$Service.$Method.Args`, and the
method's response type. Given an IDL:

```
exception NotFoundException { 1: string reason }

service SocialGraph {
  i32 follow(1: i64 follower, 2: i64 followee) throws (1: NotFoundException ex)
}
```

One possible classifier would be:

```scala
val classifier: ResponseClassifier = {
  // #1
  case ReqRep(_, Throw(_: NotFoundException)) =>
    ResponseClass.NonRetryableFailure
  // #2
  case ReqRep(_, Return(x: Int)) if x == 0 =>
    ResponseClass.NonRetryableFailure
  // #3
  case ReqRep(SocialGraph.Follow.Args(a, b), _) if a <= 0 =>
    ResponseClass.NonRetryableFailure
}
```

If you examine that classifier you’ll note a few things. First (#1),
the deserialized `NotFoundException` can be treated as a failure. Next
(#2), a “successful” response can be examined to enable services using
status codes to classify errors. Lastly (#3), the request can be
  introspected to make the decision.

### But what’s it really gonna do?

It’s important to understand what the impact will be if you customize
response classification for your client. Perhaps most importantly,
when responses are classified as failures, this affects how failure
accrual sees responses. In the past, you may have had a Thrift service
returning nothing but exceptions, but this node would continue getting
traffic due to failure accrual’s lack of visibility. While this
changes lets you fix this visibility, you should consider what causes
those responses. For example, if the service is simply proxying a
failure from its downstream service, you may not want to count that as
a failure.

There isn’t a strict rule on what is the right thing to do with
classification. However, with some minimal thought, many services can
improve their success rate both in terms of how it’s reported as well
as through avoidance of bad nodes.

### Alright.

We’re really hopeful that this makes a significant difference in how
well Finagle works for you but it needs you, the application
developers, to make these choices.

If you have any questions on how to use this or feedback on how it’s working,
please get in touch through [@finagle](https://twitter.com/finagle) or the
[Finaglers mailing list](https://groups.google.com/forum/#!forum/finaglers).

[release633]: http://finagle.github.io/blog/2016/02/05/release-notes-6-33/
[Try]: https://github.com/twitter/util/blob/8e33b34a0379f920ccb2dfae531a5c003db36152/util-core/src/main/scala/com/twitter/util/Try.scala#L64-L68
[failureaccrual]: http://twitter.github.io/finagle/guide/Clients.html#failure-accrual
[successrates]: http://twitter.github.io/finagle/guide/Metrics.html#statsfilter
[brownout]: http://www.control.lth.se/media/Staff/AlessandroPapadopoulos/publications/2014-SRDS-KPDDMAHRE.pdf
[responseclassifier]: https://github.com/twitter/finagle/blob/bb91e967618f8884af98e655eb989dd20cd79e61/finagle-core/src/main/scala/com/twitter/finagle/service/package.scala#L5-L35
[httpsrverrors]: https://github.com/twitter/finagle/blob/bb91e967618f8884af98e655eb989dd20cd79e61/finagle-http/src/main/scala/com/twitter/finagle/http/service/HttpResponseClassifier.scala#L15-L19
[thriftexceptions]: https://github.com/twitter/finagle/blob/develop/finagle-thriftmux/src/main/scala/com/twitter/finagle/thriftmux/service/ThriftMuxResponseClassifier.scala
[defaultclassifier]: https://github.com/twitter/finagle/blob/246986aa055e865f521eba0e09d7c0b42880e0ac/finagle-core/src/main/scala/com/twitter/finagle/service/ResponseClassifier.scala#L18-L36
[reqrep]: https://github.com/twitter/finagle/blob/develop/finagle-core/src/main/scala/com/twitter/finagle/service/ReqRep.scala
[responseclass]: https://github.com/twitter/finagle/blob/develop/finagle-core/src/main/scala/com/twitter/finagle/service/ResponseClass.scala
[javaexample1]: https://github.com/twitter/finagle/blob/develop/finagle-http/src/test/java/com/twitter/finagle/http/service/HttpResponseClassifierCompilationTest.java
[javaexample2]: https://github.com/twitter/finagle/blob/develop/finagle-core/src/test/java/com/twitter/finagle/service/ResponseClassifierCompilationTest.java
[scrooge]: http://twitter.github.io/scrooge/

---
layout: post
title: November 2018 Relase Notes - Version 18.11.0
published: true
post_author:
  display_name: Dave Rusek
  twitter: davidjrusek
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Halloween has come and gone and it's already snowing here in the Rockies. Time to cuddle up with a warm compiler and check out the new edition of Twitter's open source libraries!

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

* finagle-base-http: Add `Message.httpDateFormat(millis)` to format the epoch millis into
  an RFC 7231 formatted String representation. [eb9bec0e](https://github.com/twitter/finagle/commit/eb9bec0ec83792a1bfb1e1fc94ecd214efdf0c48)

* finagle-core: Introduce an `StackClient.withStack` overload that
  makes modifying the existing `Stack` easier when using method chaining.
  [8f69e833](https://github.com/twitter/finagle/commit/8f69e83366c7e275fbe1cbf7671f04e0e3daab70)

* finagle-mysql: Introduce `session` to be able to perform multiple operations that require
  session state on a guaranteed single connection. [a06f7d67](https://github.com/twitter/finagle/commit/a06f7d672dce4b9e131356634f18e168e68f3692)

* finagle-netty4: When using the native epoll transport, finagle now publishes the TCP window size
  and number of retransmits based on the `tcpInfo` provided by from the channel.  These stats are
  published with a debug verbosity level.  [16071088](https://github.com/twitter/finagle/commit/160710883174e35d01f8460a80c4ad616653961a)

* finagle-http: HTTP clients and servers now accept `fixedLengthStreamedAfter` param in their
  `withStreaming` configuration (default: 5 MB when streaming is enabled). This new parameter
  controls the limit after which Finagle will stop aggregating messages with known `Content-Length`
  (payload will be available at `.content`) and switch into a streaming mode (payload will be
  available at `.reader`). Note messages with `Transfer-Encoding: chunked` never aggregated.
  [842e5e1a](https://github.com/twitter/finagle/commit/842e5e1a2b5613307add41fd064ebb589cc22bef)

#### Breaking API Changes

* finagle-http: `c.t.f.http.param.MaxChunkSize` has been removed. There is no good reason to
  configure it with anything but `Int.MaxValue` (unlimited). [990c8650](https://github.com/twitter/finagle/commit/990c8650366e5374ea062c753a4628c5971fc40e)

* finagle-exp: Update `DarkTrafficFilter#handleFailedInvocation` to accept the request type
  for more fidelity in handling the failure. [b247f941](https://github.com/twitter/finagle/commit/b247f941e97fe5c3bcf667ae69c27128f3cf1c52)

#### Runtime Behavior Changes

* finagle-http: Unset `maxChunkSize` limit in Netty HTTP codecs. Now both clients and servers
  emit all available data as a single chunk so we can put it into use quicker.
  [990c8650](https://github.com/twitter/finagle/commit/990c8650366e5374ea062c753a4628c5971fc40e)

* finagle-http: Streaming clients (`withStreaming(true)`) now aggregate inbound messages with known
  `Content-Length` if their payloads are less than 5mb (8k before). Use `withStreaming(true, 32.kb)`
  to override it with a different value. [24271b29](https://github.com/twitter/finagle/commit/24271b29e5030230e16d9b628de1a7ab029e99e5)

* finagle-http2: HTTP/2 servers perform a more graceful shutdown where an initial
  GOAWAY is sent with the maximum possible stream id and waits for either the client
  to hang up or for the close deadline, at which time a second GOAWAY is sent with
  the true last processed stream and the connection is then closed.
  [93fee499](https://github.com/twitter/finagle/commit/93fee4994e3ac83078a4342be5d8a31f921a094f)

#### Deprecations

* finagle-core: Deprecate
  `EndpointerStackClient.transformed(Stack[ServiceFactory[Req, Rep]] => Stack[ServiceFactory[Req, Rep]])`
  in favor of the `withStack` variant. [8f69e833](https://github.com/twitter/finagle/commit/8f69e83366c7e275fbe1cbf7671f04e0e3daab70)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed

* finatra-thrift: Fixes and improvements for better Java support. ExceptionMappingFilter now
  works properly with generated Java controllers, added an exception mapper for the exceptions
  defined in `finatra_thrift_exceptions.thrift` which works on the geneated Java code for these
  exceptions. Better Java API separation to make usage less error prone and confusing.
  [f6c44cab](https://github.com/twitter/finatra/commit/f6c44cab87d1f9023e6028b76c61ce1920710a7b)

* finatra-thrift: (BREAKING API CHANGE) Update `DarkTrafficFilter#handleFailedInvocation` to accept
  the request type for more fidelity in handling the failure. [20bd33ac](https://github.com/twitter/finatra/commit/20bd33acdb443545d65a68fec2032c764564a2d4)

* finatra-http: Move `request.ContentType` and `response.Mustache` Java annotations to
  `com.twitter.finatra.http` package namespace. [ef135610](https://github.com/twitter/finatra/commit/ef13561030cb38d56c15c6030974eda0e1131c40)

* finatra-jackson: Move away from deprecated code and update error handling and exceptions post
  Jackson 2.9.x upgrade. [f1e5c96e](https://github.com/twitter/finatra/commit/f1e5c96ebc6b6baaf244df382f764ae028b5abd3)

* inject-core: (BREAKING API CHANGE) Remove `c.t.inject.TestMixin#sleep`. We do not want to
  promote this usage of Thread blocking in testing utilities. Add a new testing function:
  `c.t.inject.TestMixin#await` which will perform `Await.result` on a given `c.t.util.Awaitable`.
  This function was duplicated across tests in the codebase. We also introduce an overridable default
  timeout on the underlying `Await.result` call: `c.t.inject.TestMixin#defaultAwaitTimeout`.
  [4aee1051](https://github.com/twitter/finatra/commit/4aee1051fd3656486e0c7c2d910cf90c2179871a)

#### Fixed

* finatra-http: Fix registration of HTTP Routes in the Library registry to properly account
  for Routes that duplicate a URI with a different HTTP verb. That is, a Route should be considered
  unique per URI + HTTP verb combination. [6a715075](https://github.com/twitter/finatra/commit/6a7150759e7ccb9ae9c77269223bda182bb19d13)

### [Scrooge](https://github.com/twitter/scrooge/) ###

* scrooge-generator: Allow for `Filter.TypeAgnostic` filters to be applied to a generated
  Java `Service` via a new constructor that takes an additional argument of a `Filter.TypeAgnostic`.
  This filter is then applied per generated method service. [19c7d58b](https://github.com/twitter/scrooge/commit/19c7d58b907006e3403fdc9828abe55cb843c276)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

No Changes

### [Util](https://github.com/twitter/util/) ###

#### Breaking API Changes

* util-core: `c.t.u.Future.raiseWithin` methods now take the timeout exception as a call-by-name
  parameter instead of a strict exception. While Scala programs should compile as usual, Java
  users will need to use a `scala.Function0` as the second parameter. The helper
  `c.t.u.Function.func0` can be helpful. [9bde57ca](https://github.com/twitter/util/commit/9bde57caffa7e127967fb2452beab3d09fd9888e)

* util-core: Rename `c.t.io.Reader.ReaderDiscarded` to `c.t.io.ReaderDiscardedException`.
  [a970c5b5](https://github.com/twitter/util/commit/a970c5b5ddf9cb66a63693aa5cf7709d177a234a)

#### Runtime Behavior Changes

* util-core: Made Stopwatch.timeNanos monotone. [8d35b496](https://github.com/twitter/util/commit/8d35b496756172e9bb29c473d77e32f6414806e6)



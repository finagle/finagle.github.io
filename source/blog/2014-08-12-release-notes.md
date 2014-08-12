---
layout: post
title: Release notes
published: true
post_author:
  display_name: Moses Nakamura
  gravatar: 118a9dff389cc10a8914f8f91a5e96e5
  twitter: mnnakamura
tags: ReleaseNotes, Finagle, Util
---

We're experimenting with a new form of release notes, so that it's easier to get context on what's going on in Finagle-land, especially with an eye to letting consumers see what the latest and greatest features are, and providing a little more context around what's going on.
READMORE

If you have questions about something you see in the changelogs that we didn't mention in the expanded release notes, please feel free to email me and ask for a clarification.

At a broader level, we'd also like to mention that we're interested in improving Java compatibility, so if you're having trouble using one of our APIs from Java, please let us know.

## New versions

* [`util`](#util-section): 6.19.0
* [`finagle`](#finagle-section): 6.20.0
* [`scrooge`](#scrooge-section): 3.16.3
* [`twitter-server`](#twitter-server-section): 1.7.3

## <a name="util-section" href="https://github.com/twitter/util">Util</a>

### Announcements

We made a couple of big changes to `Buf`, our byte array abstraction, and
`Reader`, our byte streaming abstraction.  Previously, we had a special `Buf`
called `Buf.Eof` to denote the end of a byte Stream, but it occurred to us that
it didn't make sense to have this in the byte array abstraction—it made more
sense to model it in the byte stream abstraction, so now the semantic lies in
the `Reader`.  `Reader` is experimental, and not used widely, so we didn't bump
the major version.  We apologize if this causes you problems.

At long last, we've deprecated `com.twitter.util.Bijection`. This has been a
long time coming, since there's now a [fully-fledged open source
project](https://github.com/twitter/bijection) built
around `Bijection` that does everything that `c.t.u.Bijection` did, and a whole
lot more!

### New features

We've added several new features to Buf, our byte array abstraction.  In part,
this is to prepare to start exposing [Netty](http://netty.io/)-free interfaces,
so that we can swap Netty 3 out for other backends.  Some of those features are
that we now have a `Buf.ByteBuffer` to wrap `java.nio.ByteBuffer`, `Buf`s now
support reading and writing `U(32|64)(BE|LE)` integers with `Buf`s, and we've
significantly improved the performance of concatenating `Buf`s, with
`ConcatBuf`.

There are two new features on spools as we think more about object streaming.
`Spool` now has take, useful for batching, and mapFuture, useful when you want
to apply a function which returns an asynchronous result to every item in your
spool.

We've modified the `Logging` trait so that it's more extensible, making it
easier to change the handlers for your logger.  We hope that this will simplify
having a unified way of logging across a project or organization.

### Java compatibility

`LoggerFactory` has been hard to use from Java for a long time.  We just created
a `LoggerFactoryBuilder`, which should be much easier to use from Java.  There's
an example in the [`LoggerFactoryBuilder` compilation
test](https://github.com/twitter/util/blob/master/util-logging/src/test/java/com/twitter/logging/LoggerFactoryTest.java).
We're excited about making Finagle easier to use from Java, so please let us
know if you continue to run into trouble consuming Finagle from Java, so we can
work with you to make Finagle more Java-friendly.

### Docs

The Scaladocs for [`Flag` and friends](http://twitter.github.io/util/docs/#com.twitter.app.Flaggable)
have been significantly improved.  If you ever wondered how `util-flags` worked,
the Scaladocs are now an even better place to learn the nitty gritty details.

### Open source

[George Leontiev](https://github.com/folone) singlehandedly replaced all of our
old [specs](https://code.google.com/p/specs/) tests with [ScalaTest](http://www.scalatest.org/)
ones, paving the way for Util to be published against Scala 2.11.  We weren't
able to publish util against 2.11 in this most recent release, but watch this
space!  We're also making big strides in 2.11-ification for Finagle, in large
part inspired by George's work.

### Changelog

6.19.0  2014-08-05

 * `util`: smattering of minor cleanups in util and finagle
 * `util-core`: Reader and getContent symmetry

6.18.4  2014-07-31

 * `util-core`: Remove confusing NOOP 0.until(5) in Future.collect().
 * `util-app`: Fix a bug in global flag parsing

6.18.2  2014-07-23

 * `util-core`: Fixes a broken sbt test
 * `util-core`: Log exceptions caught by ChannelStatsHandler
 * `util-core`: Satisfy promise on fatal exception in FuturePool task
 * `util-core`: small perf improvements to Future.collect, Throw, Flag
 * `util-logging`: Java-friendly LoggerFactory API

6.18.1  2014-07-08

 * `util`: Update README to reflect correct storage units.
 * `util-*`: Convert all tests in util to ScalaTest
 * `util-app`: Simplifies the logic to get the appname
 * `util-io`: Buf, Reader: remove Buf.Eof; end-of-stream is None
 * `util-io`: Create Buf.ByteBuffer to wrap java.nio.ByteBuffer

6.18.0  2014-06-23

 * `util-app`: Don't kill the JVM on flag-parsing failure
 * `util-app`: Improve the Scaladocs for com.twitter.app.Flag and friends
 * `util-core`: Add U(32|64)(BE|LE) to Buf
 * `util-core`: Add com.twitter.util.NilStopwatch
 * `util-core`: Add src/main/java dependency on src/main/scala
 * `util-core`: Catch InterruptedException in Closable collector thread
 * `util-core`: Fix MockTimer#schedule(Duration)(=> Unit)'s cancel
 * `util-core`: Fix update-after-interrupt race condition in AsyncSemaphore
 * `util-core`: Signal the deprecation of com.twitter.util.Bijection.
 * `util-logging`: Add additional handlers to Logging trait

6.17.0  2014-06-04

 * `util`: Upgrade dependency versions
 * `util-core`: Scheduler productivity = cpuTime/wallTime
 * `util-core`: Add a `take` method to `Spool`
 * `util-core`: Introduce `ConcatBuf`
 * `util-core`: add `Spool.collectFuture`

## <a name="finagle-section" href="https://github.com/twitter/finagle">Finagle</a>

### Announcements

We've renamed Finagle threads, so that they are now called “finagle/netty3”.
This should make it easier to figure out what is going on in your stack traces.

### New features

`finagle-http` now supports streaming the request body. This is not yet
documented, but there is [a pull request](https://github.com/twitter/finagle/pull/284/files)
to add documentation to the Finagle user guide.  We'd love to hear what you
think.

`getContent` and `Reader` are two ways to retrieve the body of the HTTP message.
The previous behavior was that when the message was chunked, calling
`reader.read(n)` retrieved n bytes of the message body, and `getContent`
returned an empty `ChannelBuffer`. When the message was not chunked,
`getContent` returned a `ChannelBuffer` filled with the message body, and
calling `reader.read(n)` was a future that never resolved.  The new behavior is
that when the message is chunked, the behavior remains the same, but when not
chunked, calling `reader.read(n)` retrieves `n` bytes of the message body. We
think this is behavior is much more aligned with expectations.

The previous default for inet! resolution in Finagle was to never refresh the
DNS lookup, so people had to do terrible hacks to get it to work properly.  Part
of the problem was that Twitter doesn't change DNS entries frequently, so we
don't rely on DNS for service discovery often.  However, the new Finagle
supports timer-based DNS resolution as default in `InetResolver`.  Thanks a ton
to [Alex Gleyzer](https://github.com/agleyzer), who came up with the original
implementation, and [Cobb](https://github.com/jixu), who got it ready to merge
into Finagle.

Per-host stats can be too noisy to turn on in production, and will entail
significant GC pressure if you have many downstream hosts.  We've added a new
flag that you can enable to turn on per host stats,
`com.twitter.finagle.loadbalancer.perHostStats`, since they are often useful for
debugging problems locally, or in staging environments.

`finagle-thriftmux` now supports the experimental feature GC Avoidance if you
turn on the right flags.  We're beginning to load test it now, but it's not
ready for prime time yet.  If you're trying to use GC Avoidance outside of
Twitter, you might have a hard time.  In some parts it depends upon having a JDK
which supports `System.minorGc`, an extra call on `System` which will only
trigger a minor GC.  We've discussed other ways of forcing a minor GC, like
allocating a lot of big arrays very quickly, but haven't implemented them yet.
Please get in contact if you're interested in working on this.

### Docs

We've significantly improved the documentation around HTTP streaming, and also
added a bunch of examples.  This hasn't been merged yet, but can be found at the
[pull request](https://github.com/twitter/finagle/pull/284/files) to add
documentation to the Finagle user guide.  We'd love to hear what you think.

### New stats

We've added several new stats to Finagle, to generally improve insight into
Finagle.  We've added a `marked_dead` counter to the `FailFastFactory`, so that
you can see when your client perceives that downstream endpoints are flapping.

We've also added a couple of counters in `WatermarkPool`, to make it easier to
see when you're having queueing problems, and are asked to wait in line for a
connection, namedly `pool_num_waited`, and `pool_num_too_many_waiters`.  

We've added a service acquisition latency stat to `StatsFactoryWrapper`, which
gives insight into how long it takes to acquire a service.  Since TCP
connections are usually quite fast, and should mostly be cached, this usually
measures how long you spend queueing for a connection.

### Open source

Inspired in large part by the great work in Util to get ready for Scala 2.11,
we've started making Finagle ready for Scala 2.11.  A large part of this is
paying down technical debt that we've accrued, like having half of our tests
still be on specs, which is super deprecated.  Because of this, we're trying to
move as much as possible onto ScalaTest, which is what we use now. 
[Pierre-Antoine Ganaye](https://github.com/p-antoine), the author of the very
cool [finagle-zookeeper](https://github.com/finagle/finagle-zookeeper) project,
stepped up and migrated the `finagle-core` tests over, while getting up to speed
on Finagle, and the Finagle community took on the mantle for the [rest of the
tests](https://github.com/twitter/finagle/issues/290).  We're over halfway
there, and we're beginning to think about how to switch over our other projects,
like Scrooge and Twitter-server.

In order to make it easier to get new contributors started with Finagle, we've
added sections about review process and starter issues.  Also, so that open
source users can see how many other open source users there are and have more
confidence in our commitment to open source, we've started an adopters list.

### Changelog

6.20.0

* `finagle`: Smattering of minor cleanups in util and finagle
* `finagle`: Upgrade sbt to 0.13
* `finagle`: Upgrade to Netty 3.9.1.1.Final
* `finagle-core`: Add NameTree.Fail to permit failing a name without fallback
* `finagle-core`: Add a generic DtabStatsFilter
* `finagle-core`: Add a singleton exception and a counter in WatermarkPool
* `finagle-core`: DefaultClient in terms of StackClient
* `finagle-core`: Disable Netty's thread renaming
* `finagle-core`: Fix CumulativeGauge memory leak
* `finagle-core`: Fix negative resolution in Namer.global
* `finagle-core`: Fixed ChannelStatsHandler to properly filter exceptions
* `finagle-core`: Forces finagle-core to use ipv4 network stack
* `finagle-core`: Improve `Failure.toString`
* `finagle-core`: Include path and Dtab.local in NoBrokersAvailableException
* `finagle-core`: Log exceptions caught by ChannelStatsHandler
* `finagle-core`: Make timer-based DNS resolution as default of InetResolver
* `finagle-core`: Reader and getContent symmetry
* `finagle-core`: Reduces log level for common exceptions
* `finagle-core`: Register clients centrally
* `finagle-doc`: Add fintop to companion projects list on Finagle website
* `finagle-http`: Don't emit (illegal) newlines in lengthy dtab header values
* `finagle-http`: Fix code style from an open-source contribution
* `finagle-http`: Migrate from specs to ScalaTest
* `finagle-kestrel`: Make transaction abort timeout configurable in MultiReader
* `finagle-mux`: Added extra client logging
* `finagle-mux`: Fix broken draining behavior
* `finagle-mux`: Improve granularity of rate to bytes/millisecond
* `finagle-serversets`: Handle errors that occur when fetching endpoints
* `finagle-serversets`: Increase ZK session timeout to 10 seconds
* `finagle-serversets`: Merge WeightedSocketAddresses with same host:port but different weight in Stabilizer
* `finagle-serversets`: Synchronize bug fixes & test coverage across ZK facades
* `finagle-swift`: Fixes pants build warning
* `finagle-thrift`: Add explicit dependency on libthrift
* `finagle-thrift`: Remove usage of java_sources, should be able to depend on it normally

6.19.0

* `finagle-core`: Allow trailing semicolons in dtabs
* `finagle-core`: Rescue exceptions thrown by filter in `Filter.andthen(Filter)`
* `finagle-core`: StackClient, StackClientLike don't leak underlying In, Out types
* `finagle-doc`: Clarify cancellation
* `finagle-doc`: Fix broken link in document
* `finagle-doc`: Fix name footnote in finagle Names docs
* `finagle-http`: Buf, Reader remove Buf.Eof; end-of-stream is None
* `finagle-http`: Prepend comment to JSONP callbacks
* `finagle-http`: Removing specs from the CookieMapSpec test.
* `finagle-kestrel`: Make failFast configurable in Kestrel codec
* `finagle-mysql`: Ensure mysql specific tracing is composed.
* `finagle-mysql`: Finagle MySQL PreparedStatement accepts Value types as params.
* `finagle-serversets`: Identity Providers for Serverset2
* `finagle-thriftmux`: Add withProtocolFactory API endpoint
* `finagle-thriftmux`: Don't reuse InMemoryStatsReceiver in the same test

6.18.0

* `finagle-*`: release scrooge v3.16.0
* `finagle-*`: release util v6.18.0
* `finagle-core`: Add `description` field to com.twitter.finagle.Stackable trait
* `finagle-core`: Add a Flag to turn on per-host stats
* `finagle-core`: Add a service acquisition latency stat to StatsFactoryWrapper
* `finagle-core`: Don't support empty path elements in com.twitter.finagle.Path
* `finagle-core`: Improves FailFastFactory documentation
* `finagle-core`: Make c.t.f.Failure a direct subclass of Exception
* `finagle-core`: Skip SOCKS proxy when connecting to loopback address
* `finagle-core`: Use Monitor from caller's context in DefaultTimer
* `finagle-http`: Add "Enhance Your Calm" and "Too Many Requests" HTTP status codes
* `finagle-http`: Add exp.HttpServer, which allows request limits to be configured
* `finagle-http`: Change Request#params to a memoized def
* `finagle-http`: Stream request body
* `finagle-kestrel`: Add Name-based methods for MultiReader construction
* `finagle-memcached`: Expose the client type `KetamaClient` in the `build()` API
* `finagle-mux`: GC Avoidance Algorithm
* `finagle-mux`: Hook up GC avoidance to servers
* `finagle-mux`: Move UseMux.java to the correct directory
* `finagle-serversets`: Randomizes backoff interval in ZK2
* `finagle-serversets`: Start resolution eagerly in ZK2
* `finagle-stats`: Add a stat-filtration GlobalFlag
* `finagle-*`: release ostrich v9.5.2
* `user guide`: Add Google Analytics tracking code
* `user guide`: Add sections about review process and starter issues
* `user guide`: Update Finagle adopter list on user guide website
* `wily`: Add Dtab expansion

6.17.0

* `finagle`: Add list of Finagle adopters
* `finagle`: Upgrade third-party dependencies
* `finagle-core`: Add `Addr.Neg` to the user guide's list of Addr types
* `finagle-core`: Added Failure support for sourcing to finagle
* `finagle-core`: ClientBuilder should turn per-host stats off by default (matching new Client building API).
* `finagle-core`: Implement DefaultServer in terms of StackServer
* `finagle-core`: Improve the Dtab API
* `finagle-core`: Prevent scoping stats with the empty-string
* `finagle-core`: Rolls up the /tries scope properly
* `finagle-core`: ServerStatsReceiver and ClientStatsReceiver can now update their root scope
* `finagle-core`: fix race case in DelayedFactory
* `finagle-core`: introduce AbstractResolver
* `finagle-core`: remove need for hostConnectionLimit when using ClientBuilder#stack
* `finagle-core`: widen to type for ServerBuilder#stack
* `finagle-core`: widen type of ClientBuilder#stack
* `finagle-doc`: Removed a line from conf.py
* `finagle-http`: DtabFilter should always clear dtab headers
* `finagle-http`: add HOST header for CONNECT method
* `finagle-http`: scala 2.10 compatible tests
* `finagle-memcached`: filter out one more cancelling request exception in failure accrual
* `finagle-memcached`: remove empty test
* `finagle-mux`: Improve Mux server close behavior, control messages to non-Mux clients
* `finagle-mux`: Marked a gc test as flaky
* `finagle-mux`: Modifies MuxService to essentially be a Service[Spool[Buf], Spool[Buf]] Problem
* `finagle-mux`: Rm ClientHangupException in favor of CancelledRequestException
* `finagle-mysql`: Retrieving a timestamp from the DB nw creates a timestamp in UTC
* `finagle-mysql`: fix for issue where time was not being returned in UTC for binary protocol
* `finagle-serversets`: Prevent gauges from being garbage collected
* `finagle-thrift`: Blackhole control messages sent to non-mux Thrift clients
* `finagle-thriftmux`: Add per-connection protocol-usage stats
* `finagle-thriftmux`: Add stats to identify ThriftMux clients and servers
* `finagle-thriftmux`: Propagate Contexts from non-ThriftMux clients
* `finagle-thriftmux`: add ClientBuilder#stack compatibility and make APIs symmetric
* `finagle-thriftmux`: pass along ClientId with ClientBuilder API

## <a name="scrooge-section" href="https://github.com/twitter/scrooge">Scrooge</a>

### New features
We wrote a [scrooge-linter](https://twitter.github.io/scrooge/Linter.html),
which we're really excited about.  If you're at a company that has a lot of
Thrift IDL files, you know the pain of trying to get everyone to write them in a
standard way, especially since the tooling is so anemic.  `scrooge-linter`
begins to fix that problem, by linting your IDL files so you can catch
non-conforming thrift quickly and systematically.

### Docs
The docs on how to use the scrooge tool from the command line have long been out
of date.  We just did a big refresher of them, and it's much easier to get up
and running with a new Scrooge project now.

### Changelog

3.16.3

* `scrooge-core`: Add union metadata for reflection
* `scrooge-doc`: Clarify docs on CLI usage
* `scrooge-generator`: Fix error message for missing required field
* `scrooge-generator`: Modify compiler to accept a Scaladoc comment at the end of Thrift file
* `scrooge-generator`: Normalize scalatest versions between poms and 3rdparty
* `scrooge-generator`: Stricter checks for invalid Thrift filenames
* `scrooge-ostrich`: Default to using `Protocols.binaryFactory`

3.16.1

* `scrooge-*`: release finagle 6.18.0
* `scrooge-*`: release util 6.18.0
* `scrooge-linter`: Fix multiple arguments to linter + pants/mvn fixes
* `scrooge`: Separate flow for linter
* `scrooge`: Skip includes when linting

3.16.0

* `scrooge-*`: Upgrade dependencies to latest versions
* `scrooge`: Move scrooge-linter into scrooge
* `scrooge`: Add SimpleID.originalName for enum fields

## <a name="twitter-server-section" href="https://github.com/twitter/twitter-server">Twitter Server</a>

### New features

It has historically been difficult to understand how your client is configured,
even though all clients are configured very similarly, usually with only small
changes in parameters.  However, when debugging, users sometimes need to know
how long timeouts have been set to, what kind of load balancer is being used,
and other configuration parameters, so that we can debug problems more quickly.
Now, we have a neat admin endpoint where users can gain insight into each client
individually.

Having logging at multiple granularities is a real luxury, but sometimes you
realize that you've set the log level incorrectly, and you need to be able to
see more granular logs on a box that's already in an interesting state, in
production.  To that end, we've added a logging handler to the Twitter-server
admin service, which can both tell you about the current log levels, but can
also be used to change logging granularities on the fly.

We added a new admin handler to display the base dtab, so that it's easier to
reason about what will happen to a service when it receives a new dtab.  Instead
of having to guess based on its behavior, or try to figure it out through
inspecting the code, you can just query now, and know the right answer
immediately.

Built-in metrics are one of the coolest features of Finagle, but there are
really a ton of them, especially if you have many downstreams, or you use per
host stats.  In order to make this problem easier to deal with, we added a flag,
`com.twitter.finagle.stats.statsFilter`, which you can pass in to filter out
some stats that you know you will never use.

### Changelog

1.7.3

* Add admin endpoint for per-client configuration
* Add trace ID to twitter-server logging
* Create a logging handler for on-the-fly logging updates

1.7.2

* release finagle v6.18.0
* release util v6.18.0
* user guide: Add blurb about filtering out stats

1.7.1

* Upgrade versions of all dependencies
* Admin dtab handler: display base dtab
* Change productivity stat to cpuTime/wallTime

---
layout: post
title: May 2019 Release Notes - Version 19.5.1
published: true
post_author:
  display_name: Ryan O'Neill
  twitter: ryanoneill
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

With it being late May, the beginning of summer is right around the corner. Along with that comes a
new release of libraries.  Unfortunately, there was an
[issue](https://github.com/twitter/finatra/issues/502)
with our first attempt (19.5.0) so we created a point release (19.5.1), which fixes the problem.
Here are the changes for both 19.5.0 and 19.5.1

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-http: Add two new methods to `com.twitter.finagle.http.MediaType`,
    `MediaType#typeEquals` for checking if two media types have the same type and
    subtype, ignoring their charset, and `MediaType#addUtf8Charset` for easily
    setting a utf-8 charset. [ec0953f1](https://github.com/twitter/finagle/commit/ec0953f12acd85485994c009c4a349caf776f268)

#### Bug Fixes

-   finagle-http: Ensure server returns 400 Bad Request when
    non-ASCII characters are present in the HTTP request URI path. [a7dae7ea](https://github.com/twitter/finagle/commit/a7dae7ea84f828313cdf37cabf2b792435661ec7)

#### Runtime Behavior Changes

-   finagle-core: Deterministic aperture (d-aperture) load balancers no longer export
    "loadband" scoped metrics: "widen", "narrow", "offered\_load\_ema". These were not
    necessary as d-aperture does not change the aperture size at runtime. [20029ac5](https://github.com/twitter/finagle/commit/20029ac5437dba59eb580398cbf2207e43de020e)
-   finagle-core: Request logging now defaults to disabled. Enable it by configuring the
    `RequestLogger` Stack parameter on your `Client` or `Server`. [ee9cb4ec](https://github.com/twitter/finagle/commit/ee9cb4ec2c17b810354b36ff97816fc97efb6394)
-   finagle-core: Subtree binding failures in `NameTree.Union`'s are ignored in the
    final binding result. [2fde4d2d](https://github.com/twitter/finagle/commit/2fde4d2d023503a7ced1a1793cedd4f0de97c6bc)

#### Breaking API Changes

-   finagle-core: The `c.t.f.client.EndpointerModule` and `c.t.f.pushsession.PushStackClient` public
    and protected APIs have been changed to use the abstract `java.net.SocketAddress` instead of the
    concrete `java.net.InetSocketAddress` as relying on the concrete implementation was not
    necessary. [77a3cdfd](https://github.com/twitter/finagle/commit/77a3cdfd17695e814d9263cff3ad888ab4646a59)
-   finagle-http: For Finagle HTTP clients, the `withMaxRequestSize(size)` API
    method has been removed. For Finagle HTTP servers, the
    `withMaxResponseSize(size)` method has been removed. The underlying Stack
    params which are set by these methods are respectively HTTP server and HTTP
    client side params only. Using these removed methods had no effect on the
    setup of Finagle HTTP clients and servers. [5eb3ae24](https://github.com/twitter/finagle/commit/5eb3ae242289b074771deef2bd574636959e4d56)
-   finagle-mysql: HandshakeResponse has been removed from finagle-mysql's public
    API. It is expected that users of the library are relying entirely on
    finagle-mysql for handshaking. [f0ab09a6](https://github.com/twitter/finagle/commit/f0ab09a6504925893e82400d10531817e6dd9d01)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

-   inject-server/http/thrift: Allow users to specify a `StatsReceiver` implementation to use in the
    underlying `EmbeddedTwitterServer` instead of always providing an `InMemoryStatsReceiver`
    implementation. [7a486fd2](https://github.com/twitter/finatra/commit/7a486fd28b3126ecb62ec209c51dd06721b24d5a)
-   finatra-http: Add ability for Java HTTP Controllers to use the RouteDSL for per-route filtering
    and for route prefixing. [c2733158](https://github.com/twitter/finatra/commit/c27331587276678771c2c25f3d6f4a690768b964)
-   inject-request-scope: Add a `Filter.TypeAgnostic` implementation for the `FinagleRequestScopeFilter`
    for better compatibility with Thrift servers. Update the FinagleRequestScope to make more idiomatic
    use of Context locals. [451cff77](https://github.com/twitter/finatra/commit/451cff77e3207394d3e007b77c39e10617667296)
-   finatra-http: Route params are now URL-decoded automatically. [a79f5634](https://github.com/twitter/finatra/commit/a79f56347acd2194e415975ab125e2509c8e91e5)
-   finatra-jackson: Add ability to bypass case class validation using the
    `NullValidationFinatraJacksonModule`. [401d7285](https://github.com/twitter/finatra/commit/401d72859980fc9d29abe02fa1f62f906bb90351)
-   inject-app: Add `c.t.inject.app.DtabResolution` to help users apply supplemental Dtabs added by
    setting the dtab.add flag. This will append the supplemental Dtabs to the
    Dtab.base in a premain function. [6c4eeda0](https://github.com/twitter/finatra/commit/6c4eeda034e40337e73fdec79cea15bc71a83282)

#### Changed

-   finatra-http: Move when admin routes are added to the AdminHttpServer to the `postInjectorStartup`
    phase, such that any admin routes are available to be hit during server warmup. Simplify `HttpWarmup`
    utility to make it clear that it can and should only be used for sending requests to endpoints added
    to the server's configured `HttpRouter`. The `forceRouteToAdminHttpMuxers` param has been renamed
    to admin to signal that the request should be sent to the `HttpRouter#adminRoutingService` instead
    of the `HttpRouter#externalRoutingService`. Routing to TwitterServer HTTP Admin Interface via this
    utility never worked properly and the (broken) support has been dropped. [0cd3ed69](https://github.com/twitter/finatra/commit/0cd3ed691d4d86b5500dfddb858e0f25f9dc5058)
-   finatra-kafka: Update `com.twitter.finatra.kafka.test.KafkaTopic`, and
    `com.twitter.finatra.kafka.test.utils.PollUtils` methods to take
    `com.twitter.util.Duration` instead of `org.joda.time.Duration`. [94c051b3](https://github.com/twitter/finatra/commit/94c051b382865685620b4def6cba12cbc7e286c4)
-   finatra: Removed Commons IO as a dependency. [4b6e4726](https://github.com/twitter/finatra/commit/4b6e4726f48ab2845427c5b418ea92f69fa8a0c6)
-   finatra-http: `com.twitter.finatra.http.EmbeddedHttpServer` methods which previously used the
    `routeToAdminServer` parameter have been changed to use a `RouteHint` instead for added
    flexibility in controlling where a test request is sent. [4653992c](https://github.com/twitter/finatra/commit/4653992cf0d14481aa3faeae4071c873b6a81a5d)
-   finatra-inject: Feature tests no longer default to printing metrics after tests.
    This can be enabled on a per-test basis by overriding `FeatureTestMixin.printStats`
    and setting it to true. [28eecabe](https://github.com/twitter/finatra/commit/28eecabe149de6b046055d4db162ca46d19d42e4)
-   finatra-inject: Update `com.twitter.inject.utils.RetryPolicyUtils`,
    `com.twitter.inject.thrift.modules.FilteredThriftClientModule`, and
    `com.twitter.inject.thrift.filters.ThriftClientFilterChain` methods to take
    `com.twitter.util.Duration` instead of `org.joda.time.Duration`. [c295efb0](https://github.com/twitter/finatra/commit/c295efb043fe9f4f1c3cb01a8ec47ea5899c79be)
-   finatra: Fix Commons FileUpload vulnerability. Update `org.apache.commons-fileupload` from version
    1.3.1 to version 1.4. This closes \#PR-497. [d5d32737](https://github.com/twitter/finatra/commit/d5d3273729d526e610f9f3c7f8c2bce976d971dc)
-   finatra-http: Replace all usages of guava's `com.google.common.net.MediaType` with String.
    You can migrate by calling `MediaType#toString` everywhere you passed a `MediaType` before. [826fabb2](https://github.com/twitter/finatra/commit/826fabb251f06844ad75e65091cda657cb956c01)
-   finatra-http: Add `http` scope to `shutdown.time` flag, making it `http.shutdown.time`.
    [2abb46f8](https://github.com/twitter/finatra/commit/2abb46f833e1852f027f857683cf9c6e6a162022)
-   finatra-http: Remove deprecated `DefaultExceptionMapper`. Extend
    `c.t.finatra.http.exceptions.ExceptionMapper[Throwable]` directly instead. [cd2d5be3](https://github.com/twitter/finatra/commit/cd2d5be357218e76204fcbbb15751119d05f826e)
-   inject-app: Move override of `com.twitter.app.App#failfastOnFlagsNotParsed` up from
    `c.t.inject.server.TwitterServer` to `com.twitter.inject.app.App` such that all Finatra-based
    applications default to this behavior. [feb887e0](https://github.com/twitter/finatra/commit/feb887e0e3e7c88d5c36a87d4aed9b08a8d794c8)
-   inject-app|server: change capturing of flag ordering from Modules for adding to the App's `c.t.app.Flags`
    instance to match the semantics of directly calling `c.t.app.Flags#add`. Prefer `AtomicBoolean`
    instances over where we currently use mutable Boolean instances in `c.t.inject.app.App`, `c.t.inject.app.TestInjector`,
    and `c.t.inject.server.EmbeddedTwitterServer`. [2dfd33b5](https://github.com/twitter/finatra/commit/2dfd33b58d2855fa14d8800555518ee314db314a)
-   finatra-examples: Update "twitter-clone" example to use Dtabs instead of the deprecated resolverMap.
    Move the "hello-world" example to "http-server". [6c4eeda0](https://github.com/twitter/finatra/commit/6c4eeda034e40337e73fdec79cea15bc71a83282)

#### Fixed

-   finatra: The added `c.t.finatra.http.RouteHint` was missing from the test-jar sources and has
    been added. [7945d128](https://github.com/twitter/finatra/commit/7945d128c3de8ecd9f2c8c890fd39600262df11f)
-   finatra-jackson: Properly account for timezone in Joda `DateTime` deserialization. [abb17d5a](https://github.com/twitter/finatra/commit/abb17d5ac1150f4a94014bfa56e8a8c2c0d386e5)
-   finatra-http: `EmbeddedHttpServer`'s `httpGetJson` method now properly passes
    all parameters through to the underlying client call. [068cd440](https://github.com/twitter/finatra/commit/068cd440dc17d6671e0d075ba7f13af74d0e56a6)

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   scrooge-generator: Extensions of `(ReqRep)ServicePerEndpoint` now provide a proper filtered
    method by default. [e46b2785](https://github.com/twitter/scrooge/commit/e46b2785d036b2f6920eea9aefb5a93307618231)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

-   twitter-server: Add `DuplicateFlagDefinitions` lint rule which is violated when multiple `Flags` with the same
    name are added to the underlying com.twitter.app.App#flag com.twitter.app.Flags instance. [fe231c9a](https://github.com/twitter/twitter-server/commit/fe231c9a1034f526584ef1cbb30d1313abf78eae)

### [Util](https://github.com/twitter/util/) ###

-   util-app: Track the registration of duplicated `Flag` names. Currently, we print a warning to
    stderr but do not track the duplicated `Flag` names. Tracking them allows us to inspect and
    warn over the entire set. [4875552e](https://github.com/twitter/util/commit/4875552e3bf5752a389b9af524831d6bb3507c57)


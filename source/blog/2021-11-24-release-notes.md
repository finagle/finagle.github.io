---
layout: post
title: November 2021 Release Notes - Version 21.11.0
published: true
post_author:
  display_name: Dorothy Ordogh
  twitter: dordogh
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The winter ❄️ holidays are coming, so here is an early gift 🎁 from us to you: the November release ☃️

[Util](https://github.com/twitter/util/)
========================================

Breaking API Changes
--------------------

-   util-security: Use snakeyaml to parse yaml instead of a buggy custom yaml
    parser. This means that thrown IOExceptions have been replaced by
    YAMLExceptions. Additionally, the parser member has been limited to private visibility. [3643e1e8](https://github.com/twitter/util/commit/3643e1e870c1a6d6fb521a5f0e00c0b9e1e7d4fe)

New Features
------------

-   util-security: Any valid yaml / json file with string keys and values can
    be loaded with com.twitter.util.security.Credentials. [3643e1e8](https://github.com/twitter/util/commit/3643e1e870c1a6d6fb521a5f0e00c0b9e1e7d4fe)

Runtime Behavior Changes
------------------------

-   util-cache: Update Caffeine cache library to version 2.9.2 [c1d62105](https://github.com/twitter/util/commit/c1d62105bfe7b951b7c65d95fafc5f08e0d16bdb)
-   util-jackson: Enable BLOCK\_UNSAFE\_POLYMORPHIC\_BASE\_TYPES in ScalaObjectMapper to
    guard against Remote Code Execution (RCE) security vulnerability. This blocks
    polymorphic deserialization from unsafe base types. [35f262f2](https://github.com/twitter/util/commit/35f262f23aaad1301ccf563210d4af670051ec95)


[Scrooge](https://github.com/twitter/scrooge/)
==============================================

Runtime Behavior Changes
------------------------

-   scrooge-serializer: concrete implementations of the ThriftStructSerializer
    trait in the c.t.scrooge. package now cache the value of its maxReusableBufferSize
    flag for the duration of the application. This improves performance but also makes them
    not observe changes to the flag. The value of this flag typically does not change during
    run time of an application, so this is deemed an acceptable tradeoff. [064e1535](https://github.com/twitter/scrooge/commit/064e1535ca50b4d7510e2d76fec8901b79a7d0e6)


[Finagle](https://github.com/twitter/finagle/)
==============================================

Changed
-------

-   finagle-base-http: Promote several classes out of exp experimental package:
    c.t.f.http.{GenStreamingSerialServerDispatcher, IdentityStreamTransport, StreamTransport} along
    with internal support classes. [81169d53](https://github.com/twitter/finagle/commit/81169d5372442e5781fd1a62894eded080c0ac1d)

Breaking API Changes
--------------------

-   finagle-core: Remove c.t.f.loadbalancer.Balancer.maxEffort. Remove the maxEffort
    argument from Balancers.{p2c, p2cPeakEwma, aperture, aperturePeakEwmaUse, roundRobin}.
    [25f01f77](https://github.com/twitter/finagle/commit/25f01f771d0f7cc513f64168aa20003791045776)
-   finagle-core: c.t.f.tracing.ClientRequestTracingFilter has been removed.
    Record relevant tracing information in your service or client directly. [bcd89491](https://github.com/twitter/finagle/commit/bcd89491ade6668c82143c0ea64ad09c68db12fa)
-   finagle: Remove com.twitter.finagle.Group, and other rarely used and deprecated pieces that depend on it
    com.twitter.finagle.memcached.TwitterCacheResolver, com.twitter.finagle.memcached.CacheNodeGroup,
    com.twitter.finagle.memcached.RubyMemCacheClient, and com.twitter.finagle.memcached.PHPMemCacheClient.
    Instead of Group, please use Var\[Set\[T\]\] or Activity\[Set\[T\]\] directly instead. [f6021319](https://github.com/twitter/finagle/commit/f60213199359efaf5492d461471e71058c76a1d9)

Runtime Behavior Changes
------------------------

-   finagle: Update Caffeine cache library to version 2.9.2 [7c91f966](https://github.com/twitter/finagle/commit/7c91f966612dfc839824e144b08c80cfbf160532)


[Finatra](https://github.com/twitter/finatra/)
==============================================

Added
-----

-   inject-core: Introduce a runAfterAll hook in c.t.inject.IntegrationTestMixin to allow for
    running logic to clean-up test resources in the org.scalatest.BeforeAndAfterAll\#afterAll without
    needing to 1) override org.scalatest.BeforeAndAfterAll\#afterAll, 2) ensure super is called for
    other resources clean-up, and 3) ensure all resources get cleaned up, regardless of non-fatal
    exceptions thrown as part of the clean-up logic and otherwise fail the TestSuite run.
    [42c17b87](https://github.com/twitter/finatra/commit/42c17b87a8df306999d7fdd0ea73b85ebdcd4071)

Changed
-------

-   http-server (BREAKING API CHANGE): Will now serialize many self-referential Jackson types as "{}"
    instead of returning a serialization error. See <https://github.com/FasterXML/jackson-databind/commit/765e2fe1b7f6cdbc6855b32b39ba876fdff9fbcc>
    for more details. [044293fe](https://github.com/twitter/finatra/commit/044293fe14009791aa0e0c78edbaa7c8d1ac24da)

[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

No Changes

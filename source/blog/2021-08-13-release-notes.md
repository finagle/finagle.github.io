---
layout: post
title: August 2021 Release Notes - Version 21.8.0
published: true
post_author:
  display_name: Hamdi Allam
  twitter: allam_hamdi
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

August release, hot off the press:

[Util](https://github.com/twitter/util/)
========================================


New Features
------------

-   util-stats: add getAllExpressionsWithLabel utility to InMemoryStatsReceiver. [29602592](https://github.com/twitter/util/commit/29602592800306e0ff34aa79fd6d17c03162ee8b)
-   util-app: Experimentally crossbuilds with Scala 3. [94f1fa37](https://github.com/twitter/util/commit/94f1fa3738fdbb5866571e83d303c65bd507de49)
-   util-app-lifecycle: Experimentally crossbuilds with Scala 3. [5f67cddb](https://github.com/twitter/util/commit/5f67cddb366e0fe906930740652bae64c486dc37)
-   util-codec: Experimentally crossbuilds with Scala 3. [35b00359](https://github.com/twitter/util/commit/35b00359cf397c3f070f2ed2ba5c1affbd9a06b2)
-   util-hashing: Experimentally crossbuilds with Scala 3. [b9ef5d06](https://github.com/twitter/util/commit/b9ef5d06153c7f4459cdf57ebec8852ec3a0a59c)
-   util-lint: Experimentally crossbuilds with Scala 3. [5b960dd1](https://github.com/twitter/util/commit/5b960dd148ed0f23e75731259088cf3ae0d6b378)
-   util-registry: Experimentally crossbuilds with Scala 3. [39b0355d](https://github.com/twitter/util/commit/39b0355db188fa24bac09bc6a6661f462c9301b4)
-   util-thrift: Experimentally crossbuilds with Scala 3. [3a93c8c7](https://github.com/twitter/util/commit/3a93c8c78a9085ecbc92022602dfc1aa95109a82)
-   util-app: Introduce a new Command class which provides a Reader interface to the output
    of a shell command. [8b88bcc6](https://github.com/twitter/util/commit/8b88bcc60c20315ce3a7c3a6a342aba76e095de7)
-   util-core: Experimentally crossbuilds with Scala 3. [d84bfbaa](https://github.com/twitter/util/commit/d84bfbaaef6cea6db889a249bf756cc31f62c124)

Breaking API Changes
--------------------

-   util-app: Flags and GlobalFlag now use ClassTag instead of Manifest. [94f1fa37](https://github.com/twitter/util/commit/94f1fa3738fdbb5866571e83d303c65bd507de49)
-   util-thrift: ThriftCodec now uses ClassTag instead of Manifest. In
    scala3 Manifest is intended for use by the compiler and should not be used in
    client code. [3a93c8c7](https://github.com/twitter/util/commit/3a93c8c78a9085ecbc92022602dfc1aa95109a82)
-   util-core (BREAKING): Remove AbstractSpool. Java users should use Spools static class or
    the Spool companion object to create instances of Spool. [d84bfbaa](https://github.com/twitter/util/commit/d84bfbaaef6cea6db889a249bf756cc31f62c124)

Runtime Behavior Changes
------------------------

-   util: Update ScalaCheck to version 1.15.4 [1efeb9d9](https://github.com/twitter/util/commit/1efeb9d91e8f790c736a768582ce65834cb0263c)
-   util-jackson: JsonDiff\#toSortedString now includes null-type nodes, so that
    JsonDiff.Result\#toString shows differences in objects due to such nodes. [cd03cf0d](https://github.com/twitter/util/commit/cd03cf0df51de25ccbe442e9ffb5a602ce892025)


[Scrooge](https://github.com/twitter/scrooge/)
==============================================


Runtime Behavior Changes
------------------------

-   scrooge: Update ScalaCheck to version 1.15.4. scrooge-sbt-plugin and
    scrooge-generator still use the older version 1.14.3 because they compile
    with Scala 2.10. [ad063665](https://github.com/twitter/scrooge/commit/ad0636650964b79fb0a43afacb0c3663135aa750)


[Finagle](https://github.com/twitter/finagle/)
==============================================


New Features
------------

-   finagle-mysql: introduce newRichClient(dest: String, label: String) method, which removes the
    need for extra boilerplate to convert the destination String to a c.t.finagle.Name when
    specifying both dest and label in String form. [c211bfbe](https://github.com/twitter/finagle/commit/c211bfbed7d0345ef52a7b08419eba9ba3de00d0)
-   finagle-http, finagle-thriftmux: introduce client.withSni() API. Use this api to specify an
    SNI hostname for TLS clients. [a8ec457b](https://github.com/twitter/finagle/commit/a8ec457be41271dbfb27f99cdbbe6465961c78c0)

Runtime Behavior Changes
------------------------

-   finagle: Update Caffeine cache library to version 2.9.1 [d9e551a3](https://github.com/twitter/finagle/commit/d9e551a3e68014fc74735b7fd8b59e46e115dd23)
-   finagle: Update ScalaCheck to version 1.15.4 [145ab4aa](https://github.com/twitter/finagle/commit/145ab4aacea1ecba6a3741b56f0e692362dec224)
-   finagle-core: change ServiceClosedException to extend FailureFlags and to be
    universally retryable [e621e5ff](https://github.com/twitter/finagle/commit/e621e5ffc6d6c8ae46413ac17a06d61c71fdf9cc)
-   finagle-http: remove the com.twitter.finagle.http.UseH2,
    com.twitter.finagle.http.UseH2CClients2, com.twitter.finagle.http.UseH2CServers and
    com.twitter.finagle.http.UseHttp2MultiplexCodecClient toggles. The configuration for
    c.t.finagle.Http.client and c.t.finagle.Http.server now default to using the HTTP/2 based
    implementation. To disable this behavior, use c.t.finagle.Http.client.withNoHttp2 and
    c.t.finagle.Http.server.withNoHttp2 respectively.

    Alternatively, new GlobalFlag's have been introduced to modify the default behavior of clients
    and servers that have not been explicitly configured, where
    the com.twitter.finagle.http.defaultClientProtocol
    and com.twitter.finagle.http.defaultServerProtocol flags can be set to HTTP/1.1 to modify
    the default client or server configuration, respectively. PHAB\_ID=D625880\`

-   finagle-netty4: Finagle now reuses Netty "boss" (or parent) threads instead of creating a new
    thread per server. Netty parent threads are servicing the server acceptor, a relatively
    lightweight component that listens for new incoming connections before handing them out to the
    global worker pool. [5e9998fc](https://github.com/twitter/finagle/commit/5e9998fc3bf7dbea074945cce4ceda5c94fc885e)
-   finagle-http2: introduce optional parameter NackRstFrameHandling to enable or disable NACK
    conversion to RST\_STREAM frames. [728aed03](https://github.com/twitter/finagle/commit/728aed039f885b37e6bd56044d721e776079fa27)
-   finagle-thrift, finagle-thriftmux: clients may start reporting (correctly) lower success rate.
    Previously server exceptions not declared in IDL were erroneously considered as successes.
    The fgix also improves failure detection and thus nodes previously considered as healthy
    by failure accrual policy may be considered as unhealthy. [3bba41c6](https://github.com/twitter/finagle/commit/3bba41c67ab9a292fc1f2f98391604d15a87a7b4)

Bug Fixes
---------

-   finagle-core: Add BackupRequestFilter to client registry when configured. [56092e96](https://github.com/twitter/finagle/commit/56092e96246cb40de707941d5e397d948f23ba7f)
-   finagle-thrift, finagle-thriftmux: clients now treat server exceptions
    not declared in IDL as failures, rather than successes,
    and do not skip the configured response classifier for failure accrual.
    [3bba41c6](https://github.com/twitter/finagle/commit/3bba41c67ab9a292fc1f2f98391604d15a87a7b4)


[Finatra](https://github.com/twitter/finatra/)
==============================================


Fixed
-----

-   inject-core: Fixed a bug where c.t.inject.TestMixin\#assertFailedFuture would incorrectly pass
    for non-failed c.t.util.Future in some cases where the tested failure is a supertype of
    org.scalatest.exceptions.TestFailedException. [b1f14ebb](https://github.com/twitter/finatra/commit/b1f14ebbfc0c12784fd752ff98f54c20744eca78)

Breaking API Change
-------------------

-   inject-utils: Removed deprecated c.t.inject.conversions.string, use
    c.t.conversions.StringOps in the util/util-core project instead.  [ceed4f4a](https://github.com/twitter/finatra/commit/ceed4f4aacc7c5534d557d4899f28e2f971eb87f)
-   inject-utils: Removed deprecated c.t.inject.conversions.tuple, use
    c.t.conversions.TupleOps in the util/util-core project instead. [0c95c240](https://github.com/twitter/finatra/commit/0c95c2407f4771b5ef1411286ed1c35ec8cd4ad7)
-   inject-utils: Removed deprecated c.t.inject.conversions.seq, use
    c.t.conversions.SeqOps in the util/util-core project instead. [8bd42557](https://github.com/twitter/finatra/commit/8bd425572d3c134bf40e7a5f0bbab1667e7dbb4c)
-   inject-utils: Removed implicit class RichMap from c.t.inject.conversions.map,
    use c.t.conversions.MapOps in the util/util-core project instead. [19ad496a](https://github.com/twitter/finatra/commit/19ad496a7546e262ae7b0711f0503464d85ca3b8)

Changed
-------

-   thrift: Update the test c.t.finatra.thrift.ThriftClient to close client and clean-up resources
    during the EmbeddedTwitterServer close. [e6c792ed](https://github.com/twitter/finatra/commit/e6c792ed66cb8b6a5f9463aeda66ebe5ebbd3dea)
-   finatra: Update ScalaCheck to version 1.15.4 [f40869cd](https://github.com/twitter/finatra/commit/f40869cd9252e2c5235a66f5de21a1598ae3017f)


[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================


Admin Endpoint Versions
-----------------------

-   Bump metric\_metadata.json to version 3.2: CounterishGauge now exports with
    "kind": "counterish\_gauge", instead of "counterish\_gauge": "true"
    [93121600](https://github.com/twitter/twitter-server/commit/93121600ffe8e8a68b0eed1e5763ab93366082d3).
-   Bump expressions.json to version 1.1: the labels field in the Metric
    Metadata Expressions output to return a dictionary instead of a well-defined
    JSON object. However, the existing fields in labels will be preserved for
    now. [4cda5ed0](https://github.com/twitter/twitter-server/commit/4cda5ed07a36075690d238cf97b32122ec16d5dc)

Runtime Behavior Changes
------------------------

-   Update ScalaCheck to version 1.15.4 [2bd4d8b5](https://github.com/twitter/twitter-server/commit/2bd4d8b53fa6bdeb3646d9aae89fd4fa3bba9194)

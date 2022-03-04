---
layout: post
title: February 2022 Release Notes - Version 22.2.0
published: true
post_author:
  display_name: Moses Nakamura
  twitter: mnnakamura
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

One of the joys of winter is drinking a mug of hot cocoa, curling up in a nook, and warming yourself by the heat of your computer compiling Scala code ☕🖥️🔥

We have a new release, and no houses were burned down in electrical fires while getting it to you.

[Util](https://github.com/twitter/util/)
========================================

New Features
------------

-   util-core: Added Memoize.classValue as a Scala-friendly API for java.lang.ClassValue. [b696fdfd](https://github.com/twitter/util/commit/b696fdfd9082fc7dfb3468f7aea84ce24677ef82)
-   util-jvm: Register JVM expression including memory pool usages (including code cache, compressed class space,
    eden space, sheap, metaspace, survivor space, and old gen) and open file descriptors count in StatsReceiver.
    [ad617fe9](https://github.com/twitter/util/commit/ad617fe92445371dc5647add7a7143450492c137)
-   util-slf4j-jul-bridge: Add Slf4jBridge trait which can be mixed into extensions of c.t.app.App in
    order to attempt installation of the SLF4JBridgeHandler via the Slf4jBridgeUtility in the constructor
    of the c.t.app.App instance. [ab73d64f](https://github.com/twitter/util/commit/ab73d64f95ceea48899e7561429d781ad8da5929)

Runtime Behavior Changes
------------------------

-   util-slf4j-api: Update the Logger API to include "call-by-name" method
    variations akin to the Logging trait. When creating a Logger from a
    Scala singleton object class, the resultant logger name will no longer include
    the \$ suffix. Remove the deprecated Loggers object which is no longer
    needed for Java compatibility as users can now directly use the Logger
    apply functions with no additional ceremony. [cd99f165](https://github.com/twitter/util/commit/cd99f16542959d926d43a5f5b498c2627038664b)
-   util: Bump version of Caffeine to 2.9.3. [07b5c2ef](https://github.com/twitter/util/commit/07b5c2ef2f7843cc1c8e3cf7b017a98ee1f0d0bc)

Breaking API Changes
--------------------

-   util-core: The c.t.util.Responder trait has been removed. [88d3c95a](https://github.com/twitter/util/commit/88d3c95a30888d26f1c9bf8f6bf3b2d7f5e80ec2)

[Scrooge](https://github.com/twitter/scrooge/)
==============================================

New Features
------------

-   scrooge-core: c.t.scrooge.ThriftStructCodec.forStructClassTag API for retrieving
    the codec for a struct or union class given a class tag or manifest and
    c.t.scrooge.ThriftStructMetadata.forStructClassTag for retrieving its metadata.
    [ba1a97bc](https://github.com/twitter/scrooge/commit/ba1a97bc9549416b1d34e7c1550c38386bdaab42)
-   scrooge-core: c.t.scrooge.ThriftStructCodec.forStructClass API for retrieving codec
    for a struct or union class and c.t.scrooge.ThriftStructMetadata.forStructClass for
    similarly retrieving its metadata. `PHAB_ID=_D825675`
-   scrooge-generator: for each method defined in a service in the Thrift IDL, if any request arg
    of a method has annotations started with validation., generate a new trait
    ServerValidationMixin with a new API violationReturning&lt;method\_name&gt; which validates incoming
    request (of Struct, Union, Exception types) and return any violations (as method parameters
    &lt;request\_variable&gt;Violations) back to the users in the method API. [aa83a3f5](https://github.com/twitter/scrooge/commit/aa83a3f5886cae3d4ef96f379192d906daaab7a7)

Breaking API Changes
--------------------

-   scrooge-generator: the c.t.scrooge.frontend.ThriftParser now always throws exceptions
    rather than warnings when a fieldname matches a reserved keyword. See
    c.t.scrooge.frontend.ThriftKeywords for the full list of disallowed
    keywords. [33767856](https://github.com/twitter/scrooge/commit/33767856287a8fadcf3838478889909cf0c08bfb)

[Finagle](https://github.com/twitter/finagle/)
==============================================

New Features
------------

-   finagle-logging: Introduced finagle-logging, a new module for SLF4J-integrated
    filters. [0e6a3b68](https://github.com/twitter/finagle/commit/0e6a3b681f3a6988728d518dbd355b193164bfd3)
-   finagle-logging: Introduced SlowTracesFilter, which observes your requests and
    logs the slowest ones that are also sampled for tracing. [0e6a3b68](https://github.com/twitter/finagle/commit/0e6a3b681f3a6988728d518dbd355b193164bfd3)
-   finagle-core: Introduced MinSendBackupAfterMs to the stack param Configured in
    BackupRequestFilter and propagated changes to MethodBuilder by adding new versions of idempotent
    function. When traffic load is low, this is useful to increase the delay when backup requests are
    sent and prevent the client from sending unnecessary backup requests. [b0b8a6bb](https://github.com/twitter/finagle/commit/b0b8a6bb321f8ec528457bd7da43ad705216d178)
-   finagle-core: Added a new annotation clnt/has\_dark\_request in tracing and Finagle
    Local context. The new annotation can be used to indicate whether or not the request
    has a span that is sent to dark service. [dab1e48d](https://github.com/twitter/finagle/commit/dab1e48d03336a50820c1c7419d1683f9b67f004)

Bug Fixes
---------

-   finagle-netty4-http: On a Request, adding multiple cookies with the same name
    to a CookieMap preserves all of them. Only cookies on Responses are
    deduplicated. Previously, adding a Request cookie with the same name would
    overwrite the old value with the new value. [6a49bfda](https://github.com/twitter/finagle/commit/6a49bfda74f433fa2b9cc2dca71c350e10cb6bc9)
-   finagle-postgres: Fixed a bug where a single framer instance was shared across all
    connections to a host when using TLS. [185e2115](https://github.com/twitter/finagle/commit/185e21158aaea876f82d5878e1d701bd0dc497c0)

Breaking API Changes
--------------------

-   finagle-core: Changed the shouldInvoke parameter in method serviceConcurrently
    and sendDarkRequest in AbstractDarkRequestFilter to be a Boolean instead of a
    function of (Req =&gt; Boolean). [dab1e48d](https://github.com/twitter/finagle/commit/dab1e48d03336a50820c1c7419d1683f9b67f004)
-   finagle-core: Renamed the existing clnt/dark\_request to clnt/is\_dark\_request in
    c.t.finagle.filter.DarkTrafficFilter[dab1e48d](https://github.com/twitter/finagle/commit/dab1e48d03336a50820c1c7419d1683f9b67f004)

Runtime Behavior Changes
------------------------

-   finagle: Bump version of Caffeine to 2.9.3. [c42cea2c](https://github.com/twitter/finagle/commit/c42cea2c7b7c3bfaede6724fc3466d315952e89f)
-   finagle: Upgrade to Netty 4.1.73.Final and netty-tcnative 2.0.46.Final.[cccbae40](https://github.com/twitter/finagle/commit/cccbae40f6139eb15009d5dfc1f4c47ddba15862)
-   finagle-core: in TimeoutFilter, only transform a timeout exception caused by TimeoutFilter. This also
    changes the type of exception raised by the TimeoutFilter from a java.util.concurrent.TimeoutException
    to a com.twitter.finagle.RequestTimeoutException. [6a95f37d](https://github.com/twitter/finagle/commit/6a95f37d36db9f22908e571ecda342e9b62290fc)
-   finagle-mux: Exceptions raised when Mux negotiation has failed have been
    moved to a Debug log level as the stack trace is generally long and not
    necessarily helpful. The logged message now includes the remote address and
    that is logged at both the Debug level (with the exception and stack trace)
    and Warning level (without). [712878ef](https://github.com/twitter/finagle/commit/712878ef392c2304fc371d4c439546702f1c18cd)
-   finagle-core: c.t.f.ssl.SslConfigurations.initializeSslContext now creates an engine which includes TLSv1.3 as a supported protocol. [cc6c9db8](https://github.com/twitter/finagle/commit/cc6c9db8afb615600950a201043c8b89eb4833eb)
-   finagle-netty4: c.t.f.n.ssl.client.Netty4ClientSslConfigurations.createClientContext and c.t.f.n.ssl.server.Netty4ServerSslConfigurations.createServerCont
ext now create contexts using the provided cipher suites. [9c6898ef](https://github.com/twitter/finagle/commit/9c6898efbc885629b0a6b073c9ab39910473ccf8)

[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

No Changes

[Finatra](https://github.com/twitter/finatra/)
==============================================

-   inject-modules: Deprecate c.t.inject.modules.LoggerModule. Update c.t.inject.app.App to
    mix in the util/util-slf4j-jul-bridge Slf4jBridge trait. The LoggerModule does
    not provide a solution inline with the best practices for bridging JUL to the SLF4J-API
    and users are encouraged to instead mix in the c.t.util.logging.Slf4jBridge into the
    main class of their application if necessary. The updates to c.t.inject.app.App will now
    properly bridge JUL to the SLF4J-API early in the constructor of the application catching any
    log messages emitted to JUL before where the bridging would have been attempted when using
    the LoggerModule.

    Note that Slf4jBridge trait is already mixed into the c.t.server.TwitterServer trait and
    thus no further action is necessary forbridging JUL to the SLF4J-API in extensions of
    c.t.server.TwitterServer. [83360745](https://github.com/twitter/finatra/commit/83360745f91ee5dace446c99378c64c76dc0b6b9)

-   inject-slf4j: Deprecate c.t.inject.logging.Logging trait and methods. Users are encouraged
    to use the c.t.util.logging.Logging trait directly. There are no replacements for
    c.t.inject.logging.Logging\#debugFutureResult and c.t.inject.logging.Logging\#time.
    [084257a9](https://github.com/twitter/finatra/commit/084257a95dc529b6ef71a47c9bd1f44b7d26bc74)


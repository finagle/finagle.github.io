---
layout: post
title: December 2019 Release Notes - Version 19.12.0
published: true
post_author:
  display_name: Bryce Anderson
  twitter: brycelanderson
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

The seasons changed and depending on which hemisphere you're in it's time to enjoy either the snow ❄️ or the sun ☀️!


### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-core, finagle-exp: Add annotations to `DarkTrafficFilter` to identify which span
    is dark, as well as which light span it correlates with. [ba351f4d](https://github.com/twitter/finagle/commit/ba351f4d180faa49a6f0bbd0884338605f3b9c6b)
-   finagle-core: Introduce Trace\#traceLocal for creating local spans within a trace context.
    [1c6d5d24](https://github.com/twitter/finagle/commit/1c6d5d2482521b81d0ce80a823654591910381fa)

#### Runtime Behavior Changes

-   finagle: Upgrade to jackson 2.9.10 and jackson-databind 2.9.10.1 [e333c839](https://github.com/twitter/finagle/commit/e333c839604021893ada0c8d03f3f51843d5a55c)
-   finagle-core: Per-method metrics on MethodBuilder are now created lazily, so if you have
    methods that you don't use, the associated metrics won't be exported. [6be5dc48](https://github.com/twitter/finagle/commit/6be5dc48b0f7655cd06c5a8747116407cb381ccd)
-   finagle-mysql: The RollbackFactory no longer attempts to roll back if the underlying
    session is closed since it is highly unlikely to succeed. It now simply poisons the
    session and calls close. [99135e00](https://github.com/twitter/finagle/commit/99135e00d57fd232286ee7a019fbfea480bcc704)
-   finagle-netty4: Change the 'connection\_requests' metric to debug verbosity.
    [a6dc1296](https://github.com/twitter/finagle/commit/a6dc1296d8bc7007291f8d1f356ee021d91571a1)
-   finagle-serversets: Ensure ZkSession\#retrying is resilient to ZK host resolution failure.
    [7125026a](https://github.com/twitter/finagle/commit/7125026a02af34075d4523212389a333aeab87cf)
-   finagle-thrift: Per-method metrics are now created lazily, so if you have methods on a Thrift
    service that you don't use, the associated metrics won't be exported. [6be5dc48](https://github.com/twitter/finagle/commit/6be5dc48b0f7655cd06c5a8747116407cb381ccd)
-   finagle-zipkin-core: Tracing produces microsecond resolution timestamps in JDK9 or later.
    [08a926c6](https://github.com/twitter/finagle/commit/08a926c6a10c87072adde2b9d15e367009fde129)
-   finagle-core: Trace\#time and Trace\#timeFuture no longer generate timestamped annotations or
    silently discard timing information. They now instead generate a BinaryAnnotation containing
    the timing information. In order to also get timestamped Annotations for when the operation
    began and ended, use in conjunction with Trace\#traceLocal. [1c6d5d24](https://github.com/twitter/finagle/commit/1c6d5d2482521b81d0ce80a823654591910381fa)

#### Breaking API Changes

-   finagle-core: The RetryPolicy companion object is no longer a JavaSingleton.
    [9ffb3d13](https://github.com/twitter/finagle/commit/9ffb3d1396070541634d965feb57dfc58068ae45)
-   finagle-thrift: The RichClientParam constructors are now all either
    deprecated, so to construct it, you must call one of the RichClientParam.apply
    methods. [6be5dc48](https://github.com/twitter/finagle/commit/6be5dc48b0f7655cd06c5a8747116407cb381ccd)

#### Deprecations

-   finagle-core: Deprecate Tracing\#record(message, duration) as it does not have the intended
    effect and silently discards any duration information in the resulting trace. Instead you should
    use either Tracing\#recordBinary or a combination of Trace\#traceLocal and Trace\#time.
    [1c6d5d24](https://github.com/twitter/finagle/commit/1c6d5d2482521b81d0ce80a823654591910381fa)

#### Bug Fixes

-   finagle-core: ClosableService client stack module that prevents the reuse of closed services
    when FactoryToService is not set. This is important for clients making use of the newClient
    api. [c64bea09](https://github.com/twitter/finagle/commit/c64bea0939a2c41dcc2addd8fcea3ad6f2af63e2)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed

-   finatra: Upgrade to jackson 2.9.10 and jackson-databind 2.9.10.1 [14fc3714](https://github.com/twitter/finatra/commit/14fc3714e6a6239db0c392264259ddfa52cf2b79)
-   finatra: Correctly track Ignorable Exceptions in per-method StatsFilter. Responses
    marked as Ignorable are tracked in the global requests and exceptions metrics but
    were not counted under the per-method metrics. There are now counts of ignored
    and total requests as well as ignored requests by Exception for each method. E.g.

    per\_method\_stats/foo/ignored 1
    per\_method\_stats/foo/ignored/java.lang.Exception 1
    per\_method\_stats/foo/requests 1

    [80946f4d](https://github.com/twitter/finatra/commit/80946f4dd3deeb86e6a1d95c0e9776e37623e094)

-   finatra-http|jackson (BREAKING API CHANGE): Move parsing of message body contents
    from finatra/jackson via the FinatraObjectMapper \#parseMessageBody, \#parseRequestBody,
    and \#parseResponseBody methods to finatra/http with functionality replicated via an
    implicit which enhances a given FinatraObjectMapper. Additionally we have updated
    finatra-http the MessageBodyComponent API to use c.t.finagle.http.Message instead
    of c.t.finagle.http.Request and c.t.finagle.http.Response. This means that users can use the
    MessageBodyComponent API to read the body of Finagle HTTP requests or responses and all HTTP
    concerns are co-located in finatra-http instead of being partially implemented in finatra-jackson.

    In updating the MessageBodyComponent API we have removed support for polymorphic MessageBodyReader
    types, that is we have simplified the MessageBodyReader API to no longer express the \#parse
    method parameterized to a subtype of the class type. This API allowed parsing a message body
    into a subtype solely through the presence of a given type parameter but the resulting API has
    proven to be extremely clunky. We feel that the same behavior is achievable in other ways (such
    as adapting the type after parsing) and the improvement and simplification of the
    MessageBodyReader API to be worth removing the awkward method signature.

    Lastly, we have fixed the returned charset encoding on response content-type header to be
    applicable only where appropriate instead of always being added when the
    http.response.charset.enabled flag is set to true. [4c6283b2](https://github.com/twitter/finatra/commit/4c6283b229fba43fa4a180cef6656fb0b66a92ef)

-   finatra: (BREAKING API CHANGE) move DarkTrafficFilter and related modules
    from finatra/thrift to inject/inject-thrift-client. The modules now extend
    from c.t.inject.thrift.modules.ThriftClientModuleTrait for more uniform configuration.
    The following changes were made:

    > -   c.t.finatra.thrift.filters.DarkTrafficFilter -&gt;
    >     c.t.inject.thrift.filters.DarkTrafficFilter
    > -   c.t.finatra.thrift.modules.DarkTrafficFilterModule -&gt;
    >     c.t.inject.thrift.modules.DarkTrafficFilterModule
    > -   c.t.finatra.thrift.modules.ReqRepDarkTrafficFilterModule -&gt;
    >     c.t.inject.thrift.modules.ReqRepDarkTrafficFilterModule
    > -   c.t.finatra.thrift.modules.JavaDarkTrafficFilterModule -&gt;
    >     c.t.inject.thrift.modules.JavaDarkTrafficFilterModule

    [a8e54f34](https://github.com/twitter/finatra/commit/a8e54f343e81823e2370977ffc1cf19905f0f910)

-   finatra: Update Google Guice version to 4.1.0, update ScalaTest to 3.0.8, and ScalaCheck
    to 1.14.0. [1bc3e889](https://github.com/twitter/finatra/commit/1bc3e8891750fbcf12cdfbfb0c6a2a3639ee84f3)
-   finatra-http: Remove deprecated c.t.finatra.http.HttpHeaders. Users should use
    com.twitter.finagle.http.Fields instead. [e9e5d4e2](https://github.com/twitter/finatra/commit/e9e5d4e20f09186049db9526ee66f598fe216fc2)
-   finatra-http: Remove deprecated DocRootModule. [6163e7f7](https://github.com/twitter/finatra/commit/6163e7f7bfbf8c204132745204f42d74316fd33b)
-   finatra-http: (BREAKING CHANGE) Remove automatic handling of Mustache rendering from
    finatra/http and break Mustache support into two separate libraries: finatra/mustache
    and finatra/http-mustache.

    HTTP services that want the framework to automatically negotiate Mustache template rendering
    via the Finatra HTTP MessageBodyComponents framework must now bring this concern into their
    HTTP services via the finatra/http-mustache c.t.finatra.http.modules.MustacheModule as the
    HTTP framework support for specifying a MustacheModule in the HttpServer has been removed.
    I.e., add this module to the server's list of modules.

    Additionally, it is also now possible to use Mustache templating completely independent of
    Finatra HTTP concerns by consuming and using only the finatra/mustache library which will
    render Strings via defined Mustache templates. [e6aaa19f](https://github.com/twitter/finatra/commit/e6aaa19f40d0249ff897104c7ca2625359006f72)

#### Fixed

-   finatra-http: Fixed issue in the DefaultMessageBodyReaderImpl that determines if the incoming
    message is "json encoded". [c1f1a093](https://github.com/twitter/finatra/commit/c1f1a093762fff74f83db8c3adbdf6cf0eb2494a)
-   inject-modules: Removed the extra registration for closing a client, which used to log false
    warnings when startup a ClientModule. Only register close after materialized clients.
    [ddda0b12](https://github.com/twitter/finatra/commit/ddda0b12ce6be14d6832e800764da190ca7f5745)
-   inject-server: Addressed a race condition that could allow for an AdminHttpServer to be
    started, even when the disableAdminHttpServer property was set. The AdminHttpServer will
    no longer start prior to the warm-up phase if disabled. The disableAdminHttpServer property
    has also been moved to com.twitter.server.AdminHttpServer. [113b7d8d](https://github.com/twitter/finatra/commit/113b7d8da050fde6b28b84c1b83b12c93712084a)
-   finatra: Remove com.sun.activation dependency from build.sbt file. The dependency
    duplicates the javax.activation dependency and as a result can cause a uber-JAR to fail
    to build. [fd67b836](https://github.com/twitter/finatra/commit/fd67b83644b001890abaa117172983f370904617)

#### Added

-   finatra-jackson: (BREAKING API CHANGE) Move all Case Class annotation validation related logic to
    a new library in finatra-validation. Please update your library dependencies to the new library if
    you are using case class validations. [ba5a0451](https://github.com/twitter/finatra/commit/ba5a045142b5f7c4829704f213c567bb0e118908)

### [Util](https://github.com/twitter/util/) ###

#### New Features

-   util-stats: Introduces c.t.f.stats.LazyStatsReceiver which ensures that counters and histograms
    don't export metrics until after they have been incred or added at least once. [36d82071](https://github.com/twitter/util/commit/36d820712635a14d9545f2834341744e9932035d)
-   util-core: Introduce Time\#nowNanoPrecision to produce nanosecond resolution timestamps in JDK9
    or later. [e6f39b07](https://github.com/twitter/util/commit/e6f39b077cf0ad04c7add22ab6a39a90855c2339)
-   util-core: Introduce Future\#toCompletableFuture, which derives a CompletableFuture from
    a com.twitter.util.Future to make integrating with Java APIs simpler. [26427919](https://github.com/twitter/util/commit/2642791962dc34812a3da75be5906e62f495982a)

#### Runtime Behavior Changes

-   util: Upgrade to jackson 2.9.10 and jackson-databind 2.9.10.1 [c6e3f317](https://github.com/twitter/util/commit/c6e3f31772f1b6a8fb9abc039e446cbf0678ce89)

#### Breaking API Changes

-   util-core: The lightly used com.twitter.util.JavaSingleton trait has been removed. It
    did not work as intended. Users should provide Java friendly objects, classes, and methods
    instead. [19a6af44](https://github.com/twitter/util/commit/19a6af44759e775c33106f95295954f6e6e0cd10)

#### Deprecations

-   util-test: The c.t.logging.TestLogging mixin has been deprecated. Users are encouraged to
    move to slf4j for logging and minimize dependencies on com.twitter.logging in general, as
    it is intended to be replaced entirely by slf4j. [0dc6641c](https://github.com/twitter/util/commit/0dc6641cba19c87a1d8c3e888f3d5187310650e2)

#### Bug Fixes


-   util-core: Future\#toJavaFuture incorrectly threw the exception responsible for failing it,
    instead of a j.u.c.ExecutionException wrapping the exception responsible for failing it.
    [26427919](https://github.com/twitter/util/commit/2642791962dc34812a3da75be5906e62f495982a)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

-   Upgrade to jackson 2.9.10 and jackson-databind 2.9.10.1 [acf7e010](https://github.com/twitter/twitter-server/commit/acf7e01034902769eb128103a613155bcfc943c3)
-   Multiple changes have happened around query parameter retrieval in order
    to remove duplicated functionality from Twitter Server that exists in
    Finagle. Users are encouraged to use finagle-http's Uri class within their
    own code to retrieve params. [b538228c](https://github.com/twitter/twitter-server/commit/b538228c4401842a76a758e038f4a2ed73e98f5d)
    -   The parse method of HttpUtils has been removed.
    -   The protected getParams method of TwitterHandler has been removed.
    -   The signature of the getGraceParam method of ShutdownHandler has
        been changed to take a Request.
-   Add a disableAdminHttpServer property to the AdminHttpServer that can be used to
    prevent the AdminHttpServer from starting by default on a TwitterServer. [ecef399a](https://github.com/twitter/twitter-server/commit/ecef399ad98f5386cd75c031a8a2e73d2159a575)
-   The ResourceHandler companion object is no longer a JavaSingleton.
    [c9defbf6](https://github.com/twitter/twitter-server/commit/c9defbf60202595e2840e9869fc94f6815ad52b9)
-   Update ScalaTest to 3.0.8, and ScalaCheck to 1.14.0. [d9b1fc04](https://github.com/twitter/twitter-server/commit/d9b1fc044a2f59abea6a1c6924c1ad25d834b083)

### [Scrooge](https://github.com/twitter/scrooge/) ###

No Changes


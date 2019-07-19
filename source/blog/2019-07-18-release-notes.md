---
layout: post
title: July 2019 Release Notes - Version 19.7.0
published: true
post_author:
  display_name: Dorothy Ordogh
  twitter: dordogh
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-http: Measure streaming (message.isChunked) chunk payload size with two new histograms:
    stream/request/chunk\_payload\_bytes and stream/response/chunk\_payload\_bytes, they are
    published with a debug verbosity level. These chunk payload sizes are also traced via the same
    trace keys. [11f4e32c](https://github.com/twitter/finagle/commit/11f4e32cd8e5fcab9fc0de998f3e844f37ab741c)
-   finagle-base-http: Add support for new "b3" tracing header. [87218372](https://github.com/twitter/finagle/commit/87218372d0ae81d93c551a0752aec57b3fdaf60d)
-   finagle-core: Allow to not bypass SOCKS proxy for localhost by using the GlobalFlag
    -com.twitter.finagle.socks.socksProxyForLocalhost [5521bc83](https://github.com/twitter/finagle/commit/5521bc830f792862bb2aa06847f3f8493c673412)
-   finagle-core: OffloadFilter flag to reduce network contention. [2bd4d61b](https://github.com/twitter/finagle/commit/2bd4d61b896d261b3928ce5b6858e7d250e2be39)
-   finagle-exp: Add private c.t.f.exp.ConcurrencyLimitFilter for rejecting requests
    that exceed estimated concurrency limit [e331491c](https://github.com/twitter/finagle/commit/e331491cb7c9013ac0292e1d39b6fd9f16374b99)

#### Runtime Behavior Changes

-   finagle-http: c.t.f.http.Cors has been changed to no longer use the c.t.f.http.Response
    associated with the passed in c.t.f.http.Request. [455718a5](https://github.com/twitter/finagle/commit/455718a5bec275452d904d09351d10ab0727973a)
-   finagle-http: c.t.f.http.filter.ExceptionFilter has been changed to no longer
    use the c.t.f.http.Response associated with the passed in c.t.f.http.Request.
    [54d4acf1](https://github.com/twitter/finagle/commit/54d4acf1918fba9d1711f3591f667fd62fc4e2da)
-   finagle-http: Optimize creation of new Http Dispatchers by re-using created metrics and loggers.
    [9156f0f8](https://github.com/twitter/finagle/commit/9156f0f82c31b0df689a851712cefcce490aa50f)

#### Breaking API Changes

-   finagle-base-http: Removed the methods setStatusCode and getStatusCode from
    c.t.f.http.Response which have been deprecated since 2017. [20b37b0b](https://github.com/twitter/finagle/commit/20b37b0be21b345622ebe48ad1b16fabd58b7f03)
-   finagle-core: All deprecated c.t.f.builder.ServerBuilder\#build methods have
    been removed. Users should migrate to using the build method which takes a
    ServiceFactory\[Req, Rep\] as a parameter. [7ae208df](https://github.com/twitter/finagle/commit/7ae208df0499b89bc3e632502a36463303172074)
-   finagle-core: The c.t.f.ssl.client.SslClientEngineFactory\#getHostname method has been removed.
    All uses should be changed to use the getHostString method of SslClientEngineFactory instead.
    `PHAB_ID=DD334087`
-   finagle-http: The setOriginAndCredentials, setMaxAge, setMethod, and setHeaders methods
    of c.t.f.http.Cors.HttpFilter are no longer overridable. [455718a5](https://github.com/twitter/finagle/commit/455718a5bec275452d904d09351d10ab0727973a)
-   finagle-http: The details of the c.t.f.Http.HttpImpl class are meant to be implementation
    details so the class constructor was made private along with the fields. Along these same lines
    the c.t.f.Http.H2ClientImpl.transporter method has been moved to a private location.
    [1338e508](https://github.com/twitter/finagle/commit/1338e508dff6517a1801454cdcad95c1a4b94779)

#### Bug Fixes

-   finagle-core: Ensure ClientDispatcher queueSize gauge is removed on transport
    close, instead of waiting for clean-up at GC time. [963e9b84](https://github.com/twitter/finagle/commit/963e9b84153584184fc47c03c32b5cd5feda8bdc)
-   finagle-http2: Don't propagate stream dependency information for the H2 client.
    [a2e6c0ba](https://github.com/twitter/finagle/commit/a2e6c0ba5a1e9381fe7306ae128acca92df16021)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

-   finatra-kafka-streams: Adding test/sample for FinatraDslWindowedAggregations.aggregate. [ae433fc9](https://github.com/twitter/finatra/commit/ae433fc982e7676eacb6cdc18dd53586bb725adf)
-   finatra-jackson: Add com.twitter.util.Time deserializer with JsonFormat support.
    [ed3d666a](https://github.com/twitter/finatra/commit/ed3d666a78fc80ab2cbac61bff2f5d4b522ebbd4)

#### Changed

-   finatra-kafka: BUILD file update compile and runtime deps.
    [8241cd7c](https://github.com/twitter/finatra/commit/8241cd7c959536be953fb2767aa09e4a80ebd1b6)
-   finatra-httpclient: introduce new HttpClientModuleTrait and deprecate HttpClientModule.
    The HttpClientModule has been modified to extend from HttpClientModuleTrait to allow
    for bridging the two implementations. c.t.f.httpclient.RichHttpClient has also been deprecated
    as part of this change. The new HttpClientModuleTrait allows for direct configuration of the
    underling c.t.finagle.Http.Client. The new HttpClientModuleTrait does not provide any
    default bindings, so it is up to users to supply them - this allows for custom binding
    annotations and binding multiple HttpClients, which was not previously possible with
    HttpClientModule. [fe0c94aa](https://github.com/twitter/finatra/commit/fe0c94aaa616c0f1a63516a3278437ac549850c3)

    To migrate,

    `` ` class MyHttpClientModule extends HttpClientModule {   override val dest = "flag!mydest"   override val sslHostname = Some("sslHost") } ``\`

    becomes

    `` ` class MyHttpClientModule extends HttpClientModuleTrait {   override val dest = "flag!mydest"   override val label = "myhttpclient"   val sslHostname = "sslHost"    // we only override in this example for TLS configuration with the `sslHostname`   override def configureClient(     injector: Injector,     client: Http.Client   ): Http.Client = client.withTls(sslHostname)    @Singleton   @Provides   final def provideHttpClient(     injector: Injector,     statsReceiver: StatsReceiver,     mapper: FinatraObjectMapper   ): HttpClient = newHttpClient(injector, statsReceiver, mapper)    // Note that `provideHttpClient` no longer needs an injected `Service[Request, Response]` so   // the following is only needed if you require a `Service[Request, Response]` elsewhere:    @Singleton   @Provides   final def provideHttpService(     injector: Injector,     statsReceiver: StatsReceiver   ): Service[Request, Response] = newService(injector, statsReceiver)  } ``\`

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   scrooge-generator: A deprecated \$FinagleClient constructor which does not
    use RichClientParam has been removed. [28061ba9](https://github.com/twitter/scrooge/commit/28061ba9a6879e80946c1ae0a46b0e255fef2372)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

#### Changes

-   Remove c.t.server.util.TwitterStats as it is dead code. [55d6d288](https://github.com/twitter/twitter-server/commit/55d6d28862f7f260f3171342ad8ca363553bac40)

### [Util](https://github.com/twitter/util/) ###

#### Breaking API Changes

-   util-core: Removed deprecated c.t.concurrent.Scheduler methods usrTime,
    cpuTime, and wallTime. These were deprecated in 2015 and have no
    replacement. [0d77572c](https://github.com/twitter/util/commit/0d77572c76c7c54c0b10a1d25856af16148fe3c4)
-   util-core: Removed deprecated com.twitter.logging.config classes SyslogFormatterConfig,
    ThrottledHandlerConfig, SyslogHandlerConfig. These were deprecated in 2012 and have
    no replacement. Users are encouraged to use 'util-slf4j-api' where possible. [28d9de59](https://github.com/twitter/util/commit/28d9de59eea2adeac82691a57c1954dffb9596fa)


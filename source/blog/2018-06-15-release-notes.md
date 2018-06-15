---
layout: post
title: ☀️ June 2018 Release Notes - Version 18.6.0
published: true
post_author:
  display_name: Christopher Coco
  twitter: cacoco
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Just in time for the official start to summer 🏝 our June releases are here!

[Finagle 18.6.0](https://github.com/twitter/finagle/releases/tag/finagle-18.6.0),
[Finatra 18.6.0](https://github.com/twitter/finatra/releases/tag/finatra-18.6.0),
[Scrooge 18.6.0](https://github.com/twitter/scrooge/releases/tag/scrooge-18.6.0),
[TwitterServer 18.6.0](https://github.com/twitter/twitter-server/releases/tag/twitter-server-18.6.0),
and [Util 18.6.0](https://github.com/twitter/util/releases/tag/util-18.6.0).

### [Finagle](https://github.com/twitter/finagle/) ###

Runtime Behavior Changes:

  * finagle-core: By default, the deterministic aperture load balancer doesn't expand
    based on the loadband. This is because the loadband is influenced by a degree of
    randomness, and this breaks the deterministic part of deterministic aperture and
    can lead to aggressive banding on backends. [3d84e297](https://github.com/twitter/finagle/commit/3d84e2975fb46982d5cedeb1f43e2c9c89221840)

  * finagle-http2: Unprocessed streams are retryable in case of GOAWAY.
    [2c89cb9e](https://github.com/twitter/finagle/commit/2c89cb9eff9a2d2ed2f7bd8cef747128b5d6b89e)

New Features:

  * finagle-core: Add `PropagateDeadlines` `Stack.Param` to `TimeoutFilter` for
    disabling propagation of deadlines to outbound requests.
    [8041fbb9](https://github.com/twitter/finagle/commit/8041fbb958b28b17d61e6fd28c6049cd0a9121b0)

  * finagle-core: Add `toString` implementations to `c.t.finagle.Service` and
    `c.t.finagle.Filter`. Update in `Filter#andThen` composition to expose a
    useful `toString` for composed Filters and a composed Service (a Filter chain
    with a terminal Service or ServiceFactory).

    The default implementation for `Filter` and `Service` is `getClass.getName`. When
    composing filters, the `andThen` composition method correctly tracks the composed
    parts to produce a useful `toString`, e.g.,

```
  package com.foo

  import com.twitter.finagle.{Filter, Service}
  import com.twitter.util.Future

  class MyFilter1 extends Filter[Int, Int, Int, Int] {
     def apply(request: Int, service: Service[Int, Int]): Future[Int] = ???
  }

  ...

  package com.foo

  import com.twitter.finagle.{Filter, Service}
  import com.twitter.util.Future

  class MyFilter2 extends Filter[Int, Int, Int, Int] {
    def apply(request: Int, service: Service[Int, Int]): Future[Int] = ???
  }

  val filters = (new MyFilter1).andThen(new MyFilter2)
```

`filters.toString` would emit the String "com.foo.MyFilter1.andThen(com.foo.MyFilter2)"

If a Service (or ServiceFactory) were then added:

```
  import com.twitter.finagle.{Filter, Service}
  import com.twitter.finagle.service.ConstantService
  import com.twitter.util.Future

  ...

  val svc: Service[Int, Int] = filters.andThen(new ConstantService[Int, Int](Future.value(2)))
```

Then, `svc.toString` would thus return the String:
"com.foo.MyFilter1.andThen(com.foo.MyFilter2).andThen(com.twitter.finagle.service.ConstantService(ConstFuture(2)))"

Filter implementations are permitted to override their `toString` implementations which would
replace the default of `getClass.getName`. [25474da1](https://github.com/twitter/finagle/commit/25474da16ff5cbaf18a764f199e42e569c152452)

  * finagle-core: Make `Filter.TypeAgnostic` an abstract class for Java usability.
    [6534e459](https://github.com/twitter/finagle/commit/6534e459302f48ba252cd7729eb57653c3b49b93)

  * finagle-core: `c.t.f.filter.NackAdmissionFilter` is now public. [1855566d](https://github.com/twitter/finagle/commit/1855566d418f11d6159266a0ee767b12f454acab)

  * finagle-core: Extended `c.t.f.ssl.KeyCredentials` and `c.t.f.ssl.TrustCredentials` to work
    with `javax.net.ssl.KeyManagerFactory` and `javax.net.ssl.TrustManagerFactory` respectively.
    [c863ca0b](https://github.com/twitter/finagle/commit/c863ca0b606455d78350588595b3190165efe26b)

Breaking API Changes:

  * finagle-core: Rename `DeadlineFilter.Param(maxRejectFraction)` to
    `DeadlineFilter.MaxRejectFraction(maxRejectFraction)` to reduce confusion
    when adding additional params.
    [cb6975af](https://github.com/twitter/finagle/commit/cb6975af67c76d1fc917b68d5eba8939fd0a85bc)

Bug Fixes:

  * finagle-http2: `StreamTransportFactory` now marks itself as dead/closed when it runs out of
    HTTP/2 stream IDs instead of stalling. This allows the connection to be closed/reestablished in
    accordance with the spec [c5554673](https://github.com/twitter/finagle/commit/c555467350eb80c6894199c05942178625540a86)

  * finagle-netty4: `SslServerSessionVerifier` is now supplied with the proper peer address
    rather than `Address.failing`. [263e9786](https://github.com/twitter/finagle/commit/263e97866386d8d82f89838b045248daadad1564)

  * finagle-thrift/thriftmux: Disabled client side per-endpoint stats by default for client
    ServicePerEndpoint. It can be set via `c.t.f.thrift.RichClientParam` or a `with`-method
    as `Thrift{Mux}.client.withPerEndpointStats`. [0f1ff3eb](https://github.com/twitter/finagle/commit/0f1ff3eb88de7e270254956b8bf5f2936c7d9947)

  * finagle-netty4: Avoid NoClassDefFoundError if netty-transport-native-epoll is not available
    on the classpath.


### [Finatra](https://github.com/twitter/finatra/) ###

Added:

* finatra: Add HTTP route, Thrift method, and Filter information to the Library 
  registry. ``PHAB_ID=D177583``

* finatra-inject/inject-logback: Add an `c.t.inject.logback.AsyncAppender` to
  provide metrics about the underlying queue. ``PHAB_ID=D173278``

Changed:

* inject-slf4j: Move the SLF4J API logging bridges from `inject-slf4j` to `inject-app`
  and `inject-server`. This allows code in the inject framework to be mostly useful in
  environments where having the bridges on the classpath causes issues. ``PHAB_ID=D179652``

Fixed:

* finatra-http: Fail startup for incorrect Controller callback functions. Controller route callback
  functions that do not specify an input parameter or specify an incorrect input parameter should
  fail server startup but were not correctly detected when building routes in the `CallbackConverter`.
  The route building logic has been patched to correctly detect these routes which would fail at
  runtime to ensure we fail fast at server startup (and can thus be caught by StartupTests).
  ``PHAB_ID=D178330``

* finatra-http: Change exceptions emitted from `c.t.f.http.filter.HttpNackFilter` to not extend
  from `HttpException` and add a specific mapper over `HttpNackException` such that Nack 
  exceptions are handled distinctly from HttpExceptions and thus more specifically. Handling of
  Nack exceptions should not be conflated with handling of the more generic `HttpExceptions` and
  it should be clear if a new mapper is desired that it is specifically for changing how Nack
  exceptions are handled. ``PHAB_ID=D172456``

### [TwitterServer](https://github.com/twitter/twitter-server/) ###

New Features:

  * Added an admin page at "/admin/balancers.json" with details about client load balancers,
    including both configuration and current status. ``PHAB_ID=D171589``

### [Util](https://github.com/twitter/util/) ###

API Changes:

  * util-app: Allow users a way to override the argument parsing behavior in
    `c.t.app.App#nonExitingMain` which was inlined. Users can override `parseArgs`
    to define custom behavior. [cf7860e5](https://github.com/twitter/util/commit/cf7860e5c2037a496b596e1688bf5873875e3018)

  * util-core: Removed `c.t.u.NonFatal`, use `scala.util.control.NonFatal`
    instead. [57533b34](https://github.com/twitter/util/commit/57533b3473b50e944ae0ee9ff3375e9c2abc67b3)

  * util-class-preloader: This library has been removed since it deprecated. We
    no longer recommend that people do this. [af41e634](https://github.com/twitter/util/commit/af41e6343e46a1639e40d872102c6bc2e22d391a)

Bug Fixes:

  * util-app: Fix issue where in some environments, `URLClassLoader#getURLs` can
    return null, failing LoadService from initializing properly
    (see: https://github.com/google/guava/issues/2239). The `URLClassLoader` javadoc
    is not clear if a null can be returned when calling `URLClassLoader#getURLs` and for
    at least one application server, the default returned is null, thus we should be more
    resilient against this possibility. Fixes Finagle #695. [3adca94a](https://github.com/twitter/util/commit/3adca94a9e2b21a702aad619902ce5ef2e29de65)

Deprecations:

  * util-reflect: This library has been deprecated since it is legacy code and shouldn't
    be used for new services. We no longer think this facility is the right way to do it
    and encourage you to provide your own forwarders. [af41e634](https://github.com/twitter/util/commit/af41e6343e46a1639e40d872102c6bc2e22d391a)

New Features:

  * util-app: added #suppressGracefulShutdownErrors method to optionally suppress exceptions
    during graceful shutdown from bubbling up. [ab261b26](https://github.com/twitter/util/commit/ab261b2693083118fe39ad7147b7587630dfa981)


### Changelogs ###

 * [Finagle 18.6.0][finagle]
 * [Util 18.6.0][util]
 * [Scrooge 18.6.0][scrooge]
 * [TwitterServer 18.6.0][twitterserver]
 * [Finatra 18.6.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-18.6.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-18.6.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-18.6.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-18.6.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-18.6.0/CHANGELOG.md
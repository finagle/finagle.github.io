---
layout: post
title: 🎃 October 2017 Release Notes - Version 17.10.0
published: false
post_author:
  display_name: Jordan Parker
  twitter: nepthar
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The October releases have arrived! For this release and hereafter, Finagle, Finatra,
Scrooge, and TwitterServer will be versioned as $year.$month.$patch, as opposed to
$major.$minor.$patch. This means that all project versions will be in sync.

[Finagle 17.10.0][finagle], [Finatra 17.10.0][finatra], [Scrooge 17.10.0][scrooge], [TwitterServer 17.10.0][twitterserver], and [Util 17.10.0][util].

### Finagle ###

New Features:

* finagle-core: DeadlineFilter may now be created from the class and used as a
  regular Filter in addition to a stack module as before. [b80a1df4](https://github.com/twitter/finagle/commit/b80a1df4156fc6f7e4b35399d996bc46af465881)

* finagle-mysql: Add ability to toggle the `CLIENT_FOUND_ROWS` flag. [fae2e69d](https://github.com/twitter/finagle/commit/fae2e69d81faeef7cf0dee0340cb4ec27d2bcf10)

* finagle-http: Separated the DtabFilter.Extractor from the ServerContextFilter into
  a new module: ServerDtabContextFilter. While this is still enabled in the default
  Http server stack, it can be disabled independently of the ServerContextFilter.
  [335d639f](https://github.com/twitter/finagle/commit/335d639f2140f44948b914b931bd467774e72fc2)

Runtime Behavior Changes:

* finagle-netty4: `Netty4ClientEngineFactory` and `Netty4ServerEngineFactory` now
  validate loaded certificates in all cases to ensure that the current date
  range is within the validity range specified in the certificate. [dc3230e3](https://github.com/twitter/finagle/commit/dc3230e3a98fb6ec68f23f8fc00c703401db5738)

* finagle-netty4: `TrustCredentials.Insecure` now works with native SSL/TLS engines.
  [6b822e94](https://github.com/twitter/finagle/commit/6b822e94e309f0946ace6586095a511d47fa152b)

* finagle-http2: Upgraded to the new netty http/2 API in netty version 4.1.16.Final,
  which fixes several long-standing bugs but has some bugs around cleartext http/2.
  One of the work-arounds modifies the visibility of a private field, so it's incompatible
  with security managers.  This is only true for http/2--all other protocols will be unaffected.
  [bb01393f](https://github.com/twitter/finagle/commit/bb01393fc2a41a34e7ff92e1e7dc24bcadbef954)

* finagle-http: Netty 3 `HeaderMap` was replaced with our own implementation.
  [199dc51c](https://github.com/twitter/finagle/commit/199dc51cfcf573349fe436d7eaf594a857667657)

Deprecations:

* finagle-base-http: With the intention to make `c.t.f.http.Cookie` immutable,
  `set` methods on `c.t.f.http.Cookie` have been deprecated:
    - `comment_=`
    - `commentUrl_=`
    - `domain_=`
    - `maxAge_=`
    - `path_=`
    - `ports_=`
    - `value_=`
    - `version_=`
    - `httpOnly_=`
    - `isDiscard_=`
    - `isSecure_=`
  Use the `c.t.f.http.Cookie` constructor to set `domain`, `maxAge`, `path`, `value`, `httpOnly`,
  and `secure`. `comment`, `commentUrl`, `ports`, `version`, and `discard` have been removed
  per RFC-6265. [71760096](https://github.com/twitter/finagle/commit/717600969e4d4e7db047e758deae0ba30282461d).

  Alternatively, use the `domain`, `maxAge`, `path`, `httpOnly`, and `secure` methods to create a
  new `Cookie` with the existing fields set, and the respective field set to a given value.
  [14beb975](https://github.com/twitter/finagle/commit/14beb975d1c3aa4f57cf2ee3a0ab46c766496737)

* finagle-base-http: `c.t.f.http.Cookie.isSecure` and `c.t.f.http.Cookie.isDiscard`
  have been deprecated. Use `c.t.f.http.Cookie.secure` for `c.t.f.http.Cookie.isSecure`.
  `isDiscard` has been removed per RFC-6265. [71760096](https://github.com/twitter/finagle/commit/717600969e4d4e7db047e758deae0ba30282461d)

Breaking API Changes:

* finagle-mysql: Moved `Cursors.cursor` method to `Client` trait, and removed `Cursors` trait.
  This allows cursor queries to used with transactions. [1224721c](https://github.com/twitter/finagle/commit/1224721ccf25930e5f2cede3f4ecedfca219dee9)

* finagle-mux: Expose transport contexts in mux.Request and mux.Response. [f0f46785](https://github.com/twitter/finagle/commit/f0f46785a24daa09a68ebcf2f4b841474df31114)

* finagle-mux: The "leased" gauge has been removed from the mux client implementation since the
  metric is reported as the sum of the value over all clients which is unlikely to be useful.
  [1c31e384](https://github.com/twitter/finagle/commit/1c31e3848e337f3bc5b8bfd687daadffc64dbb94)

### Finatra ###

Added:

* inject-core: Remove deprecated `c.t.inject.TestMixin#resetMocks`. Properly
  use `c.t.inject.Mockito` trait in tests. Deprecate resetting of mocks and
  resettables in `c.t.inject.IntegrationTestMixin`. [b8cfeb65](https://github.com/twitter/finatra/commit/b8cfeb659b39cfb232a2c7142700ff437fe8adf2)

* finatra-http: Parameterize `@RouteParam`,`@QueryParam`,`@FormParam`, and
  `@Header` to allow specifying the field name to read from the params or
  header map. Previously these annotations only looked for values by the
  case class field name leading to possible ugliness when defining case
  class fields (especially with `@Header`). [9913a6cc](https://github.com/twitter/finatra/commit/9913a6cccc378c6ba286f91a317381db5b378059)

* finatra: Add support for using a `java.lang.annotation.Annotation` instance
  with the `#bind[T]` testing DSL. This adds a way to bind instances in tests
  that use the @Named binding annotation. [f9503c4c](https://github.com/twitter/finatra/commit/f9503c4ce1acda711abf093d941f489f614900ea)

* finatra-http: Allow setting the content type of a Mustache view.
  [2009159f](https://github.com/twitter/finatra/commit/2009159f5b6975d8f5aca7b3018356ebd90d08dd)

Changed:

* finatra-utils: Remove deprecated `ExternalServiceExceptionMatcher`. [9c78117a](https://github.com/twitter/finatra/commit/9c78117a1fe5a8731e4315d0ce7f60c3f47c419b)

* finatra-jackson: ScalaType's `isMap` and `isCollection` methods now check that
  the given object's class is a subclass of `scala.collection.Map[Any, Any]` and
  `scala.collection.Iterable[Any]`, respectively. Previously the superclasses'
  packages were unspecified. This is a runtime behavior change.
  [15a4e529](https://github.com/twitter/finatra/commit/15a4e529153437bb43ee65d38a8160d5ae137ff7)

* finatra-http: Require that route URIs and prefixes begin with forward slash (/).
  [9bd53557](https://github.com/twitter/finatra/commit/9bd53557a3fc24d4ae9ea98392388d9ac9d440f2)

* inject-utils: (BREAKING API CHANGE) RichOption toFutureOrFail, toTryOrFail, and
  toFutureOrElse signature changed to take the fail or else parameter by name.
  [a1efd13f](https://github.com/twitter/finatra/commit/a1efd13ff295051ce06679ce3bf7d99b20ccbd7b)

* inject-server: Remove usage of deprecated `c.t.inject.logging.Slf4jBridgeUtility`.
  Change usages to `c.t.util.logging.Slf4jBridgeUtility`. [4cf842ba](https://github.com/twitter/finatra/commit/4cf842ba4aaed545a897f60e546b25d5114960cb)

* finatra-http, inject-thrift-client: Remove netty3 specific types and dependency.
  In finatra-http, the code using these types is deprecated and can be removed allowing
  us to remove netty3-specific dependencies. In inject-thrift-client we can default to
  use the DefaultTimer for the backupRequestFilter method param instead of the
  HashedWheelTimer. [d8fb15fe](https://github.com/twitter/finatra/commit/d8fb15fe4fc7beb6ee7f1b85eef62af2f510a7af)

Fixed:

* finatra-jackson: Fix issue causing `IllegalArgumentException` from Validations to
  be swallowed. A catch clause in the `c.t.finatra.json.internal.caseclass.jackson.FinatraCaseClassDeserializer`
  is too broad as it catches thrown `IllegalArgumentException`s from field validations
  when the annotation is applied to a field of the incorrect type, e.g., when `@Max` is
  applied to a String field. [37ec7050](https://github.com/twitter/finatra/commit/37ec705095e2702a31dc1fb6d75f078746acbc5a)

### Util ###

API Changes:

* util-app: c.t.app.Flag.let and letClear are now generic in their return type.
  [a58db289](https://github.com/twitter/util/commit/a58db2892d82f68bbaa5b41c1394aca9011fd5ef)

Bug Fixes:

* util-core: Fix Buf.ByteArray.Shared.apply(bytes,begin,end) constructor function.
  [36377837](https://github.com/twitter/util/commit/363778374f8366e13ab0142ca549559a6ba5516c)

Runtime Behavior Changes:

* util-core: c.t.io.Buf.ByteArray.[Owned.Shared](Array[Byte], begin, end) now
  validates its input arguments. [36377837](https://github.com/twitter/util/commit/363778374f8366e13ab0142ca549559a6ba5516c)

* util-jvm: The `jvm/mem/postGC/{poolName}/max` metric has been removed
  because it is the same as the `jvm/mem/current/{poolName}/max` metric.
  [357912da](https://github.com/twitter/util/commit/357912dac0696cb77d77070ec95504145a0902ba)

* util-security: Assert validity of X.509 certificates when read from a file.
  Attempting to read a `c.t.util.security.X509CeritificateFile` will now assert
  that the certificate is valid, i.e., if the current date and time are within
  the validity period given in the certificate. [9dc859ef](https://github.com/twitter/util/commit/9dc859efef85d173aaefe08d9aa930fa7662006a)

### Scrooge ###

* scrooge-generator: For generated scala $FinagleService, moved per-endpoint statsFilter to the
  outermost of filter chain so it can capture all exceptions, added per-endpoint response
  classification in statsFilter. [853323dc](https://github.com/twitter/scrooge/commit/853323dce96d8e8d0d0c7f63d888dc969472f67a)

* scrooge-generator: Generated scala $FinagleClient takes a `RichClientParam` for all
  configuration params, such as `TProtocolFactory`, `ResponseClassifier`, `maxReusableBufferSize`,
  and `StatsReceiver`, $FinagleService takes a `RichServerParam`. [8bdf36cb](https://github.com/twitter/scrooge/commit/8bdf36cbd0297f45704ea48dc7a62872f0e581ce)

### Twitter Server ###

* All admin endpoints except ping + healthcheck are now by-default served outside
  the global worker pool. [acf13a2a](https://github.com/twitter/twitter-server/commit/acf13a2a933618fb3f719a1a4cf7b5b53ef23b7d)

* Rename AdminHttpServer#defaultHttpPort to AdminHttpServer#defaultAdminPort.
  [15e35a3a](https://github.com/twitter/twitter-server/commit/15e35a3a3070c50168ff55fd83a2dff28b09795c)

### Dependencies ###

* Netty has been updated to 4.1.16 [f28705d5](https://github.com/twitter/finagle/commit/f28705d556077cbd56b19ce90eba35be7203ad07)

### Changelogs ###

* [Finagle 17.10.0][finagle]
* [Util 17.10.0][util]
* [Scrooge 17.10.0][scrooge]
* [TwitterServer 17.10.0][twitterserver]
* [Finatra 17.10.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-17.10.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-17.10.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-17.10.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-17.10.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-17.10.0/CHANGELOG.md
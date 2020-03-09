---
layout: post
title: March 2020 Release Notes - Version 20.03.0
published: true
post_author:
  display_name: Yufan Gong
  twitter: yufangong
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Days are getting longer🌻, March has arrived. Here's what we have done in this release.

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

- finagle-opencensus-tracing: Add support for providing a custom TextFormat for header
  propagation. [a02d377a](https://github.com/twitter/finagle/commit/a02d377afb0118e448a60fd15c8fc3f351f8b2bb)

#### Runtime Behavior Changes

- finagle-netty4: When not using the JDK implementation, the Netty reference counted SSL
  types are used which move SSL cleanup out of the GC cycle, reducing pause durations.
  [466aa5bf](https://github.com/twitter/finagle/commit/466aa5bf191aba11e61777532ba452f5b7401729)

- finagle-base-http: Support for the `SameSite` cookie attribute is now on by default. This can
  be manipulated via the `com.twitter.finagle.http.cookie.supportSameSiteCodec` flag. This means
  that cookies that have a value other than `Unset` for the `sameSite` field will have the
  attribute encoded (by servers) and decoded (by clients). See this
  [Chromium blog post](https://blog.chromium.org/2019/10/developers-get-ready-for-new.html)
  for more information about the `SameSite` attribute. [f96c3729](https://github.com/twitter/finagle/commit/f96c3729db4785bb944cd152abd4813c95544f90)

- finagle-core: The default NullTracer for ClientBuilder has been removed. Affected clients may
  now see tracing enabled by default via the Java ServiceLoader, as described in the
  [Finagle User's Guide](http://twitter.github.io/finagle/guide/Tracing.html). [6b3f0940](https://github.com/twitter/finagle/commit/6b3f094009f1ba23558479fb5862b44972d6e5eb)

- finagle-http2: The HTTP/2 frame logging tools now log at level INFO. This is symmetric with
  the behavior of the `ChannelSnooper` tooling which serves a similar purpose which is to aid
  in debugging data flow and isn't intended to be enabled in production. [78e4596b](https://github.com/twitter/finagle/commit/78e4596be02a0af0fb5e3ff0df681a8c1317efcc)

#### Bug Fixes

- finagle-zipkin-scribe: add a logical retry mechanism to scribe's TRY_LATER response [23ff595b](https://github.com/twitter/finagle/commit/23ff595b0732ce4c55d50d4fe664d7ceb3cb2cac)

- finagle-http2: Initialize state in H2Pool before use in the gauge to avoid a
  NullPointerException. [289de8a3](https://github.com/twitter/finagle/commit/289de8a3f2dfd0920842943a9a7a530852b3dc81)

- finagle-http2: HTTP/2 server pipeline now traps close calls to ensure that
  events from the initial HTTP/1.x pipeline don't close the HTTP/2 session. For
  example, the initial pipeline was subject to session timeouts even though the
  tail of the socket pipeline was effectively dead. Closing of HTTP/2 server
  pipelines is now handled through the `H2ServerFilter`. [670dbf74](https://github.com/twitter/finagle/commit/670dbf7459d3e73433bd9e39df8c37163c0a9908)

- finagle-http2: HTTP/2 servers clean out unused channel handlers when upgrading
  from a HTTP/1.x pipeline, removing some traps such as unintended timeouts.
  [3dfe8226](https://github.com/twitter/finagle/commit/3dfe82267d8b3f48bd948c4e4d1b218be7c49fe7)

- finagle-opencensus-tracing: Fixed internal server error when invalid or no propagation headers
  are provided. [a02d377a](https://github.com/twitter/finagle/commit/a02d377afb0118e448a60fd15c8fc3f351f8b2bb)

- finagle-zipkin-scribe: export application metrics under a consistent `zipkin-scribe` scope. Finagle client
  stats under `clnt/zipkin-scribe` [a17659dd](https://github.com/twitter/finagle/commit/a17659ddab67919e8f09e895e5ae2c3465c91d20)

#### Breaking API Changes

- finagle-zipkin-scribe: update the deprecated `FutureIface` to `MethodPerEndpoint` [23ff595b](https://github.com/twitter/finagle/commit/23ff595b0732ce4c55d50d4fe664d7ceb3cb2cac)

- finagle-zipkin-scribe: Coalesce `ScribeRawZipkinTracer` apply methods into two simple ones. [a17659dd](https://github.com/twitter/finagle/commit/a17659ddab67919e8f09e895e5ae2c3465c91d20)

- finagle-zipkin-scribe: `DefaultSampler` moved to `c.t.f.zipkin.core` in finagle-zipkin-core. [ac9c7ec1](https://github.com/twitter/finagle/commit/ac9c7ec15b76739fc0a1e747b2a3023b21f7aad4)

- finagle-zipkin-scribe: `initialSampleRate` GlobalFlag is moved to finagle-zipkin-core, under the same package
  scope `c.t.f.zipkin`. [ac9c7ec1](https://github.com/twitter/finagle/commit/ac9c7ec15b76739fc0a1e747b2a3023b21f7aad4)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

- finatra-kafka-streams: Add method to `c.t.f.kafkastreams.test.TopologyTesterTopic` to write
  Kafka messages with custom headers to topics. [a9fef3dc](https://github.com/twitter/finatra/commit/a9fef3dcb4098074507603fb9fa1e70f176e40a6)

- finatra-http: Add `toBufReader` to get the underlying Reader of Buf from StreamingResponse.
  If the consumed Stream primitive is not Buf, the returned reader streams a serialized
  JSON array. [876d0ba9](https://github.com/twitter/finatra/commit/876d0ba9c594a1877bdb20f10020ab45b260350e)

- inject-app: Add functions to `c.t.inject.app.AbstractApp` to provide better
  ergonomics for Java users to call and use basic `App` lifecycle callbacks. 
  [f04772df](https://github.com/twitter/finatra/commit/f04772df4da0d53fa27714396a6a591f80de4e53)

- inject-server: Add functions to `c.t.inject.server.AbstractTwitterServer` to provide 
  better ergonomics for Java users to call and use basic `TwitterServer` lifecycle 
  callbacks. [f04772df](https://github.com/twitter/finatra/commit/f04772df4da0d53fa27714396a6a591f80de4e53)

- inject-slf4j: Add a way to retrieve the currently stored Local Context map backing the
  MDC. [12b9410e](https://github.com/twitter/finatra/commit/12b9410e7792da81c94e942964bbf822d0e0746c)

- finatra-jackson: Added new functionality in the `CaseClassDeserializer` to support more
  Jackson annotations during deserialization. See documentation for more information.
  [49014890](https://github.com/twitter/finatra/commit/490148909e913c71e0e2eb42fd0cdf52c89fe805)

- finatra: Add NullKafkaProducer for unit tests to avoid network connection failures in the log.
  [d8d4d5db](https://github.com/twitter/finatra/commit/d8d4d5db00c567715f25a7ccdf8b16bb7f3fa853)

#### Changed

- finatra-validation|jackson: Remove Jackson dependency from finatra/validation. This
  was for `ErrorCode` reporting but can be moved to finatra/jackson. [f024f929](https://github.com/twitter/finatra/commit/f024f9292ab141564aa8b1ef5d08b7705607ad6f)

- finatra-kafka-streams: (BREAKING API CHANGE) Update AsyncTransformer to preserve
  record context. [be5dd08f](https://github.com/twitter/finatra/commit/be5dd08f0daeb5c98569de7c8fbb6cd5fbbf195b)

- finatra-jackson: Better handling of Scala enumeration mapping errors. Currently, if mapping
  of a Scala enumeration during deserialization fails a `java.util.NoSuchElementException` is
  thrown which escapes deserialization error handling. Update to instead handle this failure case
  in order to correctly translate into a `CaseClassFieldMappingException` which will be wrapped
  into a `CaseClassMappingException`. [4753c6e8](https://github.com/twitter/finatra/commit/4753c6e8ccc03edbc94c9e5da6dd206b71a5ec3a)

- finatra: Update Google Guice version to 4.2.0 [76506c35](https://github.com/twitter/finatra/commit/76506c35961f0e8abe5e0897c43186e26b750de7)

- finatra: Bumped version of Joda to 2.10.2 and Joda-Convert to 1.5. [9adef421](https://github.com/twitter/finatra/commit/9adef42127e9efbb4d36cb114748a69bedd9e444)

- finatra-jackson|finatra-http-annotations: Move http-releated Jackson "injectablevalues"
  annotations from `finatra/jackson` to `finatra/http-annotations`.

  Specifically the follow have changed packages,
  `c.t.finatra.request.QueryParam`       --> `c.t.finatra.http.annotations.QueryParam`
  `c.t.finatra.request.RouteParam`        --> `c.t.finatra.http.annotations.RouteParam`
  `c.t.finatra.request.FormParam`         --> `c.t.finatra.http.annotations.FormParam`
  `c.t.finatra.request.Header`                --> `c.t.finatra.http.annotations.Header`
  `c.t.finatra.request.JsonIgnoreBody` --> `c.t.finatra.http.annotations.JsonIgnoreBody`

  Users should update from `finatra/jackson/src/main/java` (`finatra-jackson_2.12`)
  to `finatra/http-annotations/src/main/java` (`finatra-http-annotations_2.12`).
  [77469e17](https://github.com/twitter/finatra/commit/77469e17d62aab4edaf670ff1691401974449660)

- finatra-jackson: Updated Finatra Jackson integration to introduce a new `ScalaObjectMapper`
  and module to simplify configuration and creation of the mapper. See documentation for more
  information. [49014890](https://github.com/twitter/finatra/commit/490148909e913c71e0e2eb42fd0cdf52c89fe805)

- finatra-jackson: (BREAKING API CHANGE) Moved the java binding annotations, `CamelCaseMapper` and
  `SnakeCaseMapper` from `c.t.finatra.annotations` in `finatra/jackson` to
  `c.t.finatra.json.annotations` in `finatra/json-annotations`. Moved
  `c.t.finatra.response.JsonCamelCase` to `c.t.finatra.json.annotations.JsonCamelCase` which is also
  now deprecated. Users are encouraged to use the standard Jackson annotations or a mapper with
  the desired property naming strategy configured.

  Many exceptions for case class deserialization were meant to be internal to the framework but are
  useful or necessary outside of the internals of JSON deserialization. As such we have cleaned up
  and made most JSON deserialization exceptions public. As a result, all the exceptions have been moved
  from `c.t.finatra.json.internal.caseclass.exceptions` to `c.t.finatra.jackson.caseclass.exceptions`.

  `c.t.finatra.json.internal.caseclass.exceptions.CaseClassValidationException` has been renamed to
  `c.t.finatra.jackson.caseclass.exceptions.CaseClassFieldMappingException`. `JsonInjectException`,
  `JsonInjectionNotSupportedException`, and `RequestFieldInjectionNotSupportedException` have all been
  deleted and replaced with `c.t.finatra.jackson.caseclass.exceptions.InjectableValuesException`
  which represents the same error cases.

  The `FinatraJsonMappingException` has been removed. Users are encouraged to instead use the general
  Jackson `JsonMappingException` (which the `FinatraJsonMappingException` extends).

  `RepeatedCommaSeparatedQueryParameterException` has been moved tom finatra/http.
  [49014890](https://github.com/twitter/finatra/commit/490148909e913c71e0e2eb42fd0cdf52c89fe805)

#### Fixed

- finatra-jackson: Access to parameter names via Java reflection is not supported in Scala 2.11.
  Added a work around for the parsing of case class structures to support JSON deserialization in
  Scala 2.11 and forward. [59ec2c21](https://github.com/twitter/finatra/commit/59ec2c21627ce0e525fb55fb09582a4c62747e78)

- finatra-jackson: Fix for enforcing "fail on unknown properties" during deserialization. Previously,
  the `CaseClassDeserializer` was optimized to only read the fields in the case class constructor
  from the incoming JSON and thus ignored any unknown fields during deserialization. The fix will
  now properly fail if the `DeserializationFeature` is set or if the `JsonProperties` is configured
  accordingly. [49014890](https://github.com/twitter/finatra/commit/490148909e913c71e0e2eb42fd0cdf52c89fe805)
  
### [Util](https://github.com/twitter/util/) ###

#### Breaking API Changes

- util-core: The system property `com.twitter.util.UseLocalInInterruptible` no longer
  can be used to modulate which Local state is present when a Promise is interrupted.
  [da638942](https://github.com/twitter/util/commit/da6389421142b0d0f756abbf4508edf02812b9d9)

- util-core: `Future.unapply` has been removed. Use `Future.poll` to retrieve Future's
  state. [26beb347](https://github.com/twitter/util/commit/26beb347f7f24dbf42272c1344d5d59d9ebe896a)

#### Runtime Behavior Changes

- util-core: Promises now exclusively use the state local to setting the interrupt
  handler when raising on a Promise. [da638942](https://github.com/twitter/util/commit/da6389421142b0d0f756abbf4508edf02812b9d9)

#### New Features

- util-app: Add `c.t.util.app.App#onExitLast` to be able to provide better Java
  ergonomics for designating a final exit function. [d523c0c5](https://github.com/twitter/util/commit/d523c0c50de551814d4eb8485d68db52e8c14c51)

- util-core: Add `c.t.io.Reader.concat` to conveniently concatenate a collection
  of Reader to a single Reader. [68b28ac1](https://github.com/twitter/util/commit/68b28ac1835e920f5f0a0a17cdb33953032679ee)

#### Bug Fixes

- util-logging: Add a missing `_*` that could result in exceptions when using the
  `Logger.apply(Level, Throwable, String, Any*)` signature. [c875d359](https://github.com/twitter/util/commit/c875d359d6505a6979258f9fd596fa05ebd3c792)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

- Add `c.t.server.AbstractTwitterServer#onExitLast` to allow Java users to
  easily register a final exit function. [9a936b02](https://github.com/twitter/twitter-server/commit/9a936b0248e26fd9fc239af6436e25e9c96efac8)

### [Scrooge](https://github.com/twitter/scrooge/) ###

- scrooge-generator: Add the ability to use a type in a file before you declare it.
  [14148321](https://github.com/twitter/scrooge/commit/141483217354e75588af441c4731debbb78228c3)

- scrooge-linter: Removed the `TransitivePersistence` and `DocumentedPersisted` lint rules,
  as they aren't useful outside of Twitter. [80176dc0](https://github.com/twitter/scrooge/commit/80176dc08d9526af4474b9fd3f823b259e1584b3)

- scrooge-linter: Added the ability to load additional `LintRule` implementations dynamically
  via `com.twitter.app.LoadService`.  [80176dc0](https://github.com/twitter/scrooge/commit/80176dc08d9526af4474b9fd3f823b259e1584b3)

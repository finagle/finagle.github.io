---
layout: post
title: ☀️ May 2021 Release Notes - Version 21.5.0
published: true
post_author:
  display_name: Christopher Coco
  twitter: cacoco
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

As we head into the summer months and longer days, we've got a new release of the Twitter CSL libraries.

### NOTE

We've introduced a new case class validation library (util/util-validator) based on the Jakarta [Bean Validation specification](https://beanvalidation.org/). This library wraps the `Hibernate Validator <https://hibernate.org/validator/>`__ reference implementation for validating case classes. Check out the [user guide documentation](http://twitter.github.io/util/guide/util-validator/index.html)!


[Util](https://github.com/twitter/util/)
========================================

New Features
------------

-   util-validator: Introduce new library for case class validations (akin to Java bean validation)
    which follows the Jakarta [Bean Validation specification](https://beanvalidation.org/) by wrapping
    the Hibernate Validator library and thus supports jakarta.validation.Constraint annotations and
    validators for annotating and validating fields of Scala case classes. [5849d91c](https://github.com/twitter/util/commit/5849d91c49d036300af9ebaf40511f27b18ecb94)
-   util-app: Introduce a Java-friendly API c.t.app.App\#runOnExit(Runnable) and
    c.t.app.App\#runOnExitLast(Runnable) to allow Java 8 users to call c.t.app.App\#runOnExit
    and c.t.app.App\#runOnExitLast with lambda expressions. [c386ece8](https://github.com/twitter/util/commit/c386ece8fb7c04e7d3526ff10d8c33f86787bb33)

[Scrooge](https://github.com/twitter/scrooge/)
==============================================

-   scrooge-generator: Modify struct field names when they match Java keywords by adding
    an underscore prefix to the field name. [a33de276](https://github.com/twitter/scrooge/commit/a33de276a704a536f2cd7ea768acd327fd7d0103)

[Finagle](https://github.com/twitter/finagle/)
==============================================

New Features
------------

-   finagle-http2: Added c.t.f.http2.param.EnforceMaxConcurrentStreams which allows users to
    configure http2 clients to buffer streams once a connection has hit the max concurrent stream
    limit rather than rejecting them. A buffered\_streams gauge has been added to track the
    current number of buffered streams. [c6d5f520](https://github.com/twitter/finagle/commit/c6d5f5205f5f0345bcf9ffdd08735ce7cd5bca94)
-   finagle-mux: Added support for TLS snooping to the mux protocol. This allows a thriftmux
    server to start a connection as TLS or follow the existing upgrade pathway at the leisure of
    the client. This also allows the server to support opportunistic TLS and still downgrade to
    vanilla thrift. [60705fd2](https://github.com/twitter/finagle/commit/60705fd270a3ef85c2d31ae09626971cb12b77a8)
-   finagle-netty4: Added a new counter to keep track of the number of TLS connections that were
    started via snooping. [5569615e](https://github.com/twitter/finagle/commit/5569615e55c4b61f83da0df30e5a0bc1456d62f7)
-   finagle-thrift: Thrift(Mux) clients and servers now fill in a c.t.f.Thrift.param.ServiceClass
    stack param with the runtime class corresponding to a IDL-generated service stub.
    [04a2de2c](https://github.com/twitter/finagle/commit/04a2de2c3a4eeea5fd5d71d006dddee3e9f150ce)

Breaking API Changes
--------------------

-   finagle-core: c.t.f.param.Logger has been removed. Use external configuration supported by
    your logging backend to alter settings of com.twitter.finagle logger. [99982cda](https://github.com/twitter/finagle/commit/99982cda7e460bc29f62947bc16bf1d973658c68)

Runtime Behavior Changes
------------------------

-   finagle-http: Make handling of invalid URI consistent across client implementations. There are
    behavioral inconsistencies amongst the current HTTP client implementations:

    Our HTTP/1.x clients allow for submitting requests that contain non-ASCII characters and
    invalid character encoded sequences, while our HTTP/2 clients will either mangle
    the URI and strip out non-ASCII characters within the Netty pipeline or result in an
    UnknownChannelException when attempting to parse invalid character encoded sequences.
    With this change, we now consistently propagate an InvalidUriException result, which
    is marked as NonRetryable for all HTTP client implementations. All HTTP server implementations
    maintain behavior of returning a 400 Bad Request response status, but now also correctly
    handle invalid character encoded sequences. [fa58caab](https://github.com/twitter/finagle/commit/fa58caab1ffa82b2684e5cb1a7a64665f1adc932)

Bug Fixes
---------

-   finagle-core: Failed writes on Linux due to a remote peer disconnecting should now
    be properly seen as a c.t.f.ChannelClosedException instead of a
    c.t.f.UnknownChannelException. [6214e6ac](https://github.com/twitter/finagle/commit/6214e6acfe053308b69f07f79bed1918cfaf9ca4)
-   finagle-http2: The streams gauge is now correctly added for http2 connections over TLS.
    [c6d5f520](https://github.com/twitter/finagle/commit/c6d5f5205f5f0345bcf9ffdd08735ce7cd5bca94)
-   finagle-core: c.t.f.n.NameTreeFactory will now discard empty elements in
    c.t.f.NameTree.Unions with zero weight. [cf73946d](https://github.com/twitter/finagle/commit/cf73946df4273634ddd0786e2edd0ed508eb4207)
-   finagle-http: All HTTP server implementations consistently return a 400 Bad Request
    response status when encountering a URI with invalid character encoded sequences.
    [fa58caab](https://github.com/twitter/finagle/commit/fa58caab1ffa82b2684e5cb1a7a64665f1adc932)


[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

No Changes

[Finatra](https://github.com/twitter/finatra/)
==============================================


Fixed
-----

-   finatra-jackson: Do not enforce CaseClassDeserializer deserialization semantics for a
    field until after any deserializer annotation has been resolved. This fully allows a deserializer
    to specify how to deserialize a field completely independent of the CaseClassDeserializer
    requirements for fields. For example, if a user wanted to allow parsing of a JSON null value
    into a null field instance value, they could define a custom deserializer to do so and annotate
    the case class field with @JsonDeserialize(using = classOf\[CustomNullableDeserializer\]).

    Additionally, we fix a bug in how String case class fields are handled when the incoming JSON is
    not a String-type. The current code incorrectly returns an empty string when the field value is
    parsed into Jackson ContainerNode or ObjectNode types and an incorrect toString representation
    for a PojoNode type. We now correctly represent the field value as a string in these cases to
    deserialize into the case class field. [715890a4](https://github.com/twitter/finatra/commit/715890a4715a0f58448de0a77a4c7b085449baa5)

-   finatra-jackson: Properly handle Scala enumeration fields wrapped in an Option during
    deserialization failures in the CaseClassDeserializer\#isScalaEnumerationType method.
    [a6cb5a10](https://github.com/twitter/finatra/commit/a6cb5a10cacf4c6505583a99ffa53a6a7396a181)

Changed
-------

-   finatra-kafka: Deprecate c.t.finatra.kafka.consumers.TracingKafkaConsumer
    as it only produced single-span traces and there is no way to propagate the TraceId back to the
    caller without changing the entire API. Users should use the
    c.t.finatra.kafka.consumers.KafkaConsumerTracer.trace method instead to enable tracing for
    Kafka Consumers. Also added c.t.finatra.kafka.producers.KafkaProducerTraceAnnotator and
    c.t.finatra.kafka.consumers.KafkaConsumerTraceAnnotator services which will can be used to add
    custom trace annotations to the producer and consumer spans. [bba748e6](https://github.com/twitter/finatra/commit/bba748e6f2191d10bf9d8dba0f42fa5c3a270ddc)
-   finatra (BREAKING API CHANGE): Update to use the new util/util-validator ScalaValidator for case
    class field validations. We've removed the custom Finatra c.t.finatra.validation.Validator and
    instead now use the c.t.util.validation.ScalaValidator. Constraint annotations and validator
    implementations now use the standard jakarta.validation API interface classes instead of any
    custom Finatra types. We've deprecated the custom Finatra constraints as they are duplicative of
    already existing "standard" or otherwise provided constraints and validators. Additionally,
    c.t.finatra.validation.ErrorCode is deprecated with no replacement. The same data carried can be
    obtained via the standard jakarta.validation.ConstraintViolation\[T\].

    Adapting the Finatra framework to use the util/util-validator also includes the framework Jackson
    integration. We're also taking this opportunity to clean up the error reporting interface of
    the CaseClassFieldMappingException to define a CaseClassFieldMappingException.Reason type to
    replace the usage of the (removed) ValidationResult.Invalid type. The Reason carries a message
    String as well as a CaseClassFieldMappingException.Detail which can be one of several possible
    types including a CaseClassFieldMappingException.ValidationError which carries any failed validation
    information including the emitted ConstraintViolation\[T\].

    Lastly, we are deprecating support for JSON serialization/deserialization of JodaTime fields in
    case classes. This support will be dropped in an upcoming release. Users should prefer to use the
    JDK 8 java.time classes and we will be adding support for these types in the Finatra Jackson
    integration in the future. [0731782d](https://github.com/twitter/finatra/commit/0731782d8a3d9f3046af4fec071156de37fefd83)

-   finatra-jackson: (BREAKING API CHANGE) JsonLogging should use the lazy Scala SLF4J logger
    and no longer return the passed in argument that's logged as JSON. [67252f30](https://github.com/twitter/finatra/commit/67252f30dfcba16ad5de012abb0ed81390fb63db)


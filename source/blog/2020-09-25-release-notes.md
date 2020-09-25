---
layout: post
title: September 2020 Release Notes - Version 20.9.0
published: true
post_author:
  display_name: Hamdi Allam
  twitter: allam_hamdi
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

With the start of Fall 🍁, it is only right for a new release of our libraries! Here's the latest of Finagle, Finatra, Scrooge, TwitterServer, and Util!

### [Finagle](https://github.com/twitter/finagle/)

#### New Features

-   finagle-core: Add RelativeName field to Metric Metadata and populate it for
    client and server metrics. [de589ffa](https://github.com/twitter/finagle/commit/de589ffad1e51174f96a31e6a58d4123725b5f1c)
-   finagle-scribe: Add c.t.finagle.scribe.Publisher for publishing messages to a
    Scribe process. [7723a949](https://github.com/twitter/finagle/commit/7723a949eae3efa0d9a256a816712716e4f10ce5)

#### Runtime Behavior Changes

-   finagle: Bump version of Jackson to 2.11.2. [6c6c882a](https://github.com/twitter/finagle/commit/6c6c882a2044f752d3462fb619372060b3a92d8b)

#### Bug Fixes

-   finagle-core: The TraceId alternative constructor now forwards the traceIdHigh parameter to
    the primary constructor. [567e8d66](https://github.com/twitter/finagle/commit/567e8d66d5659feb876e3e96c4f2e7d257edc971)

### [Finatra](https://github.com/twitter/finatra/)

#### Added

-   finatra-inject: TestInjector has been reworked to allow users executing modules' lifecycle
    callbacks. Specifically, the TestInjector builder API has been moved under TestInjector.Builder
    to allow TestInjector extends Injector with two new methods: start() and close().
    [07bf53fa](https://github.com/twitter/finatra/commit/07bf53face428674b6d6fab97d81ebddaf14396a)

#### Changed

-   finatra-kafka-streams: Update and separate the Finatra kafka stream code base which has direct
    dependency on Kafka 2.2. Separate any code which cannot easily be upgraded to separate build
    target. [3c78c34d](https://github.com/twitter/finatra/commit/3c78c34df0c55f3b5dec9717d54749a3f5dc751e)
-   inject-core: c.t.inject.Injector is now an abstract class. Use Injector.apply to create
    a new instance (versus the new Injector(...) before). [64ba51e9](https://github.com/twitter/finatra/commit/64ba51e97a64f866d951b7e11afc03c5f6a0597b)
-   http: Ensure HttpWarmer creates the request exactly the number of times requested and
    mutates the correct objects. [0a3be376](https://github.com/twitter/finatra/commit/0a3be37679922dd7234c6cf5297170da87ca4063)
-   kafka: Replaced the com.twitter.finatra.kafka.TracingEnabled toggle with a GlobalFlag enabling
    Zipkin tracing for Kafka clients. [0e829aae](https://github.com/twitter/finatra/commit/0e829aae6326ed6a05582d069033094c62714e3f)
-   finatra: Bump version of Jackson to 2.11.2. [94bc773d](https://github.com/twitter/finatra/commit/94bc773dd2377d02f7c7b71b2581828aa336b55d)

#### Fixed

-   jackson: Fix issue in the handling of unknown properties. The CaseClassDeserializer only
    considered the case where the incoming JSON contained more fields than the case class and
    not the case where the incoming JSON contained less fields than specified in the case class.
    This has been fixed to ensure that when the fields of the JSON do not line up to the
    non-ignored case class fields the handling of unknown properties is properly invoked.
    [9762145d](https://github.com/twitter/finatra/commit/9762145d00cc679cd80d036d3465b63675f998d8)
-   validation: c.t.f.validation.Validator would throw an IndexOutOfBoundsException when
    trying to validate a case class which contained additional fields that are not included in the
    constructor parameters. [bb342c09](https://github.com/twitter/finatra/commit/bb342c096dfbf0d5de5e9c5b416d65177b37ca8b)

### [Scrooge](https://github.com/twitter/scrooge/)

No Changes

### [Twitter Server](https://github.com/twitter/twitter-server/)

-   Bump version of Jackson to 2.11.2. [86992eab](https://github.com/twitter/twitter-server/commit/86992eabf5197bed91bb0ebd277f66b39094f89b)
-   Encode the request URL names in /admin/clients/&lt;client\_name&gt; and /admin/servers/&lt;server\_name&gt;.
    [038ce648](https://github.com/twitter/twitter-server/commit/038ce6482d4b3bdd951dfb39abdd40039d87650a)
-   If a client connecting to an instance of TwitterServer is sending a client certificate,
    its expiry date (i.e. Not After) is now included as part of the information listed.
    [18b8b527](https://github.com/twitter/twitter-server/commit/18b8b5276ab9b6d6787fc7a6eb074ba41d20853d).

#### Breaking API Changes

-   Add relative\_name field to metrics in the Metrics Metadata endpoint and bump the
    endpoints version number to 2.0. [8b49adea](https://github.com/twitter/twitter-server/commit/8b49adea5ff2ddd05f45c4565877679f1b21d79f)


### [Util](https://github.com/twitter/util/)

#### New Features

-   util-app: Seq/Tuple2/Map flags can now operate on booleans. For example,
    Flag\[Seq\[Boolean\]\] now works as expected instead of throwing an assert exception (previous
    behaviour). [e4f54d3c](https://github.com/twitter/util/commit/e4f54d3c18b0ddc864a36b90ecbcbd7f1ed6b846)

#### Breaking API Changes

-   util-app: Flaggable.mandatory now takes implicit ClassTag\[T\] as an argument. This is change is
    source-compatible in Scala but requires Java users to pass argument explicitly via
    ClassTag\$.MODULE\$.apply(clazz). [b08a02ec](https://github.com/twitter/util/commit/b08a02ec68ca2e987ecec0cb5f7b177d9dccb831)

#### Runtime Behavior Changes

-   util: Bump version of Jackson to 2.11.2. [5d8877db](https://github.com/twitter/util/commit/5d8877dba7cdf278c105ab4747c7886d633dc38b)

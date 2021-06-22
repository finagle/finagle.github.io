---
layout: post
title: June 2021 Release Notes - Version 21.6.0
published: true
post_author:
  display_name: Ruben Oanta
  twitter: rubenoanta
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

June release, hot off the press:

[Util](https://github.com/twitter/util/)
========================================


New Features
------------

-   util-core: Add ClasspathResource, a utility for loading classpath resources as an
    optional InputStream. [c9da7c43](https://github.com/twitter/util/commit/c9da7c43e902550ea23ec28b700d8cb57542a8ab)
-   util-jackson: Add com.twitter.util.jackson.YAML for YAML serde operations with a
    default configured ScalaObjectMapper. Add more methods to com.twitter.util.jackson.JSON
    [8e964d9e](https://github.com/twitter/util/commit/8e964d9e14068d26de738220cbc4254be38f461e)
-   util-jackson: Introduce a new library for JSON serialization and deserialization based on the
    Jackson integration in [Finatra](https://twitter.github.io/finatra/user-guide/json/index.html).

    This includes a custom case class deserializer which "fails slow" to collect all mapping failures
    for error reporting. This deserializer is also natively integrated with the util-validator library
    to provide for performing case class validations during deserialization. [8aaf226e](https://github.com/twitter/util/commit/8aaf226e40243af920ea0632d11f8e10d27ad230)

Breaking API Changes
--------------------

-   util-stats: Removed MetricSchema trait (CounterSchema, GaugeSchema and HistogramSchema).
    StatReceiver derived classes use MetricBuilder directly to create counters, gauges and stats.
    [2fa17e27](https://github.com/twitter/util/commit/2fa17e27d018caec8b6e865fcadbc5d0d9f2950c)


[Scrooge](https://github.com/twitter/scrooge/)
==============================================

No Changes


[Finagle](https://github.com/twitter/finagle/)
==============================================


New Features
------------

-   finagle-core: Introduce Dtab.limited, which is a process-local Dtab that will
    NOT be remotely broadcast for any protocol, where Dtab.local will be
    broadcast for propagation on supported protocols. For path name resolution, the
    Dtab.local will take precedence over the Dtab.limited, if the same path is
    defined in both, and both take precedence over the Dtab.base. The existing
    Dtab.local request propagation behavior remains unchanged. [2e06c669](https://github.com/twitter/finagle/commit/2e06c669bae26a67fc84b32fbd50a6a5f9903d52)
-   finagle-core: Add descriptions to RequestDraining, PrepFactory, PrepConn, and
    protoTracing modules in StackClient. Add descriptions to preparer and
    protoTracing modules in StackServer. [1ea1a3eb](https://github.com/twitter/finagle/commit/1ea1a3ebb79639de795e2920f5e2c541428d18b1)

Breaking API Changes
--------------------

-   finagle-memcached: Ketama Partitioned Client has been removed and the Partition Aware
    Memcached Client has been made the default. As part of this change,
    com.twitter.finagle.memcached.UsePartitioningMemcachedClient toggle has been removed,
    and it no longer applies. [2628b84b](https://github.com/twitter/finagle/commit/2628b84bf2a8460954fc9eec4ebb1c9e1f275e85)

Runtime Behavior Changes
------------------------

-   finagle-core: Broadcast context keys lookups are now case insensitive. This change is backwards
    compatible as the marshalled key id is unchanged. Although enabled by default, this change will
    be temporarily sitting behind a toggle, com.twitter.finagle.context.MarshalledContextLookupId
    that can be used to turn off this change. [69c29093](https://github.com/twitter/finagle/commit/69c290933f442627470d1b03af5e5c93afabcf7e)

Deprecations
------------

-   finagle-core: The ServerBuilder pattern has been deprecated. Use the stack server pattern
    instead. [386171ad](https://github.com/twitter/finagle/commit/386171ad0d0a995f8c4812f819144a27bcad49e6)


[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================


Runtime Behavior Changes
------------------------

-   Sort sublinks from Admin UI alphabetically. [d8e915d9](https://github.com/twitter/twitter-server/commit/d8e915d9b6ab3c99ff4cd29d84cd939d8c19b1c5)
-   Added more information on how to enable/disable tracing in admin/tracing UI.
    [d3eb9be6](https://github.com/twitter/twitter-server/commit/d3eb9be60a77b7d816560ed478bf5e98ddef0784)
-   Resize stack module description table based on the width of the window in
    Downstream Clients and Listening Servers pages in Admin UI. [e7b47f37](https://github.com/twitter/twitter-server/commit/e7b47f37e7078462fc9683266c327c2e58e7d5ed)


[Finatra](https://github.com/twitter/finatra/)
==============================================


Changed
-------

-   inject-thrift-client (BREAKING API CHANGE): Removed the deprecated
    c.t.inject.thrift.modules.FilteredThriftClientModule. Please use its successor
    c.t.inject.thrift.modules.ThriftMethodBuilderClientModule for per-method configuration of a
    Thrift client. [008d8ca1](https://github.com/twitter/finatra/commit/008d8ca13b8f72222e7407d0d5372bafb55387fc)
-   thrift: Add service\_class to Finatra library thrift registry entry. [c5159208](https://github.com/twitter/finatra/commit/c5159208b64620b63712126c05471a705cafeda3)
-   finatra (BREAKING API CHANGE): Update to use the new util/util-jackson ScalaObjectMapper for
    case class object mapping. We've removed the custom Finatra c.t.finatra.jackson.ScalaObjectMapper
    and instead now use the c.t.util.jackson.ScalaObjectMapper. Since the c.t.util.jackson.ScalaObjectMapper
    does not support [Joda-Time](https://www.joda.org/joda-time/), backwards compatibility is
    maintained through usage of the Finatra ScalaObjectMapperModule for obtaining a configured
    ScalaObjectMapper which will be created with Joda-Time support, though support for Joda-Time in
    Finatra is deprecated and users should expect for Joda-Time support to be removed in an upcoming release.
    Users should prefer to use the JDK 8 java.time classes or java.util.Date.

    The finatra/inject c.t.inject.domain.WrappedValue has been removed and users should update to the
    util/util-core c.t.util.WrappedValue instead.

    The finatra/jackson JsonDiff utility is also removed. Users should switch to the improved version
    in util/util-jackson: c.t.util.jackson.JsonDiff.

    With the move to the util/util-jackson ScalaObjectMapper we're also able to clean up some awkward
    directory structures in Finatra which were necessary because of dependencies. Specifically, the
    finatra/json-annotations library no longer exists, as @InjectableValue is now an annotation in
    util/util-jackson-annotations, and the remaining binding annotations @CamelCaseMapper and @SnakeCaseMapper
    have been moved into finatra/jackson.

    Using the util/util-jackson ScalaObjectMapper also brings [Java 8 date/time](https://www.oracle.com/technical-resources/articles/java/jf14-date-time.html)
    (JSR310) support via inclusion of the Jackson [JavaTimeModule](https://github.com/FasterXML/jackson-modules-java8/tree/master/datetime)
    by default.

    Lastly, we've also added the YamlScalaObjectMapperModule which can be used in place of the
    ScalaObjectMapperModule in order to provide a YAMLFactory configured ScalaObjectMapper.
    [9a168a98](https://github.com/twitter/finatra/commit/9a168a981b46f04df87a6c5f2a1d0bfe42edd966)

-   inject-utils: Remove deprecated c.t.inject.utils.StringUtils. Users should prefer to use
    the corresponding methods in com.twitter.conversions.StringOps from util/util-core, instead.
    [3a063a9e](https://github.com/twitter/finatra/commit/3a063a9eec134db1b8f643d21b75984feafa1083)
-   inject-utils: Remove deprecated c.t.inject.utils.AnnotationUtils. Users should instead prefer
    c.t.util.reflect.Annotations from util/util-reflect. [35b58d34](https://github.com/twitter/finatra/commit/35b58d3494fb6aa727986f1ab6bd1ca5266f15b2)


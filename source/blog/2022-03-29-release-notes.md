---
layout: post
title: March 2022 Release Notes - Version 22.3.0
published: true
post_author:
  display_name: Yufan Gong
  twitter: yufangong
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

March is here ☀️, and Spring isn’t far behind 🌱. Enjoy this wonderful time of year with our March release 🥂.

[Util](https://github.com/twitter/util/)
========================================

Deprecations
-------------

-   util-stats: Deprecated methods on MetricBuilder for directly instantiating metrics so that we can
    eventually remove the statsReceiever field from MetricBuilder and let it just be the source of
    truth for defining a metric. [a7958355](https://github.com/twitter/util/commit/a7958355a4eb6f54229f56fc84bb1fa9546abcd3)

[Scrooge](https://github.com/twitter/scrooge/)
==============================================

New Features
--------------

-   scrooge-generator: for each method defined in a service in the Thrift IDL, if any request arg
    of a method has annotations started with validation., in Java template, generate a new trait
    `ServerValidationMixin` with a new API `violationReturning<method_name>`; which validates incoming
    request (of Struct, Union, Exception types) and return any violations (as method parameters
    `<request_variable>Violations`) back to the users in the method API. [aab91465](https://github.com/twitter/scrooge/commit/aab914658a44472b58ff8189374ecc1b0cecac10)

Breaking API Changes
----------------------

-   scrooge: ThriftUnion is now defined to extend ThriftStruct. In practice,
    this is not a significant change as all Scrooge-generated classes that
    implement ThriftUnion also implement ThriftStruct. We just made the
    invariant that unions are always structs explicit in the type system.
    [34ed2ec3](https://github.com/twitter/scrooge/commit/5c00d735e7f2c240103d9221b0474a4034ed2ec3)

Runtime Behavior Changes
---------------------------

-   scrooge: Bump version of Jackson to 2.13.2. [b283d341](https://github.com/twitter/scrooge/commit/b283d341501bd44fd6701672c51284bae73a7a22)

[Finagle](https://github.com/twitter/finagle/)
==============================================

Breaking API Changes
----------------------

-   finagle-core: Removed the stack param `WhenNoNodesOpenParam` from LoadBalancerFactory.
    Removed NoNodesOpenServiceFactory and NoNodesOpenException. When the majority of nodes
    are busy or closed (approx 60%), the load balancer will probabilistically fail open and
    pick a node at random. [1ec9ffa4](https://github.com/twitter/finagle/commit/c9c21bfea8035030329482c2888a3df11ec9ffa4)

Runtime Behavior Changes
---------------------------

-   finagle: Bump version of Jackson to 2.13.2. [0f83179d](https://github.com/twitter/finagle/commit/96459e3bebbde122db997a4503cb89980f83179d)

[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

Updates
--------

-   Update the twitter-server/slf4j-jdk14 Logging trait to ensure it defines a Logger to
    handle the cases where a class the trait is mixed into has redefined the logger. [b2ea1709](https://github.com/twitter/twitter-server/commit/b2ea17099b2d40239012c169dab7cc828453d4d7)

Runtime Behavior Changes
---------------------------

-   Bump version of Jackson to 2.13.2. [3bb02e43](https://github.com/twitter/twitter-server/commit/3bb02e4327c407e1ecf9f6f136038d83809941ae)

[Finatra](https://github.com/twitter/finatra/)
==============================================

Runtime Behavior Changes
---------------------------

-   inject-app: Remove the SLF4J-API logging bridges as dependencies. These were originally
    added as the framework was expressly opionated that users should use Logback as an SLF4J-API
    implementation, however specifying the bridges on the Finatra inject/inject-app library
    causes many issues with code that must use a different SLF4J-API logging implementation
    but still uses the Finatra framework. Users should note that if they do not include these
    bridges in some other manner that they may lose logging if they have any libraries which
    log with one of the formerly bridged implementations. Also note that servers using a
    TwitterServer logging implementation to support [dynamically changing log levels](https://twitter.github.io/twitter-server/Features.html#dynamically-change-log-levels) will get the proper bridges as dependencies.
    [a73a2957](https://github.com/twitter/finatra/commit/a73a29576c7010a9f653b572a9e650f6f0bd6721)

Runtime Behavior Changes
---------------------------

-   inject-server: Throw an UnsupportedOperationException when access to the c.t.inject.server.DeprecatedLogging\#log
    instance is attempted. This is a JUL Logger instance which was provided only as a backward-compatible
    shim for Finatra services when the c.t.server.TwitterServer framework was moved to the SLF4J-API.
    The instance was marked @deprecated in hopes of alerting users to not use it. We have now updated
    it to throw an exception when accessed. Please refer to the Finatra documentation for more information
    on using the SLF4J-API for logging with the Finatra framework: <https://twitter.github.io/finatra/user-guide/logging/index.html>.
    [e2f26752](https://github.com/twitter/finatra/commit/e2f267525f3526b79357aa028c9b63aa67ee63a1)

Added
------

-   inject-app: Introduce test-friendly c.t.inject.app.console.ConsoleWriter and
    c.t.inject.app.TestConsoleWriter, which can be used to inspect the output of a command-line
    style c.t.inject.app.App. [404f7eeb](https://github.com/twitter/finatra/commit/404f7eeb769074d42e258f62d7db5957195cbf60)

Changed
---------

-   inject-modules: Remove deprecated c.t.inject.modules.LoggerModule. [4fa62a88](https://github.com/twitter/finatra/commit/4fa62a88032f48e6aa5beb8eee348edd637a555d)
-   finatra: Bump version of Jackson to 2.13.2 [3e0bd999](https://github.com/twitter/finatra/commit/3e0bd9991dcaac629dd7e53debe54c18eb081c63)
-   inject-thrift-client: Deprecate c.t.inject.thrift.AndThenService, c.t.inject.thrift.modules.AndThenServiceModule,
    and c.t.inject.thrift.internal.DefaultAndThenServiceImpl. These were plumbing for unreleased
    experimental record/replay functionality and currently do nothing with no plan for implementation.
    [887c2ffb](https://github.com/twitter/finatra/commit/887c2ffb5bfa237dd41658c2646199961c47c547)

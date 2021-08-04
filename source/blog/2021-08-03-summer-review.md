---
layout: post
title: Summer Update 2021 🐬
published: true
post_author:
  display_name: Jing Yan
  twitter: freshlemonfish
tags: Finagle, Finatra, Util, TwitterServer
---

Shall I compare thee to a summer’s day? With blooms 🌸 and breezes 🍃, comes our Q2 update!

### Tech Debts Grooming
Every quarter, we spend a sprint to team up and kill tech debt ⚔️! This quarter, we set our minds on migrations, deprecations, and user API improvements. During this time, we migrated and removed the deadwood ServerBuilder, removed FilteredThriftClientModule in Finatra, cleaned up Finagle Memcached Client, and improved the overall user experience in TwitterServer Admin UI. 

### Centralized Serverset Weights in Finagle LoadBalancer
Introducing a new weight-aware load balancer, which allows serverset weights to work with dAperture.

### Finagle MySql
[Introduced](https://github.com/twitter/finagle/commit/77153aa4506cd21ff95255b6589fce7345a6933f#diff-65d61492e7d5230d9692f476502d9a6db87ec9da27ce18f2fd78e308c1c617ac) embedded MySql integration test utilities, which bootstrap the MySql instance programmatically when given the path to the respective mysqld binary. The package provides a fixture that allows integration tests/suite to easily make use of the bootstrapped instance. As a result, running integration suites in various environments only requires pointing to the location of the respective extracted mysql binaries. To further enhance the Finagle MySql testing framework, we [added](https://github.com/twitter/finagle/commit/4d925e736d29126d879f76b99963876b1da41700#diff-65d61492e7d5230d9692f476502d9a6db87ec9da27ce18f2fd78e308c1c617ac) an EmbeddedSimpleSuite to the test utilities to allow writing tests without creating a client for each test, and migrated Finagle MySql integration tests to the new testing framework! 

### HTTP/2
We removed all HTTP/2 related toggles within Finagle, making HTTP/2 the default HTTP implementation for Finagle clients and servers!

### New Util Validation and Util Jackson frameworks
Validation and Jackson are helpful frameworks to be used independently or as an integration in Finatra. Therefore, we have moved them from Finatra to Util to serve more use cases.The [new Util Validation](https://github.com/twitter/util/tree/14709f4c17d71a3bd4fd9941b8418b876e9324bc/util-validator) framework has been upgraded to be fully [JSR 380](https://beanvalidation.org/2.0-jsr380/) compatible by wrapping the [Hibernate Validator Java library](https://docs.jboss.org/hibernate/stable/validator/reference/en-US/html_single/). The [new Util Jackson](https://github.com/twitter/util/tree/14709f4c17d71a3bd4fd9941b8418b876e9324bc/util-jackson) framework has also been upgraded to support Bean 2.0 validation style, with better support for the JsonDiff API, as well as a new out-of-box support for YAML validation and deserialization by providing a YAML object mapper. As a result, Finatra Validation and Jackson are moved to depend on the Util Validation and Util Jackson frameworks respectively. There are no functional changes for existing Finatra services.

### Non broadcast version of Dtab.local
Introduce [Dtab.limited](https://twitter.github.io/finagle/guide/Names.html#the-dtab-api), a process-local Dtab that will NOT be remotely broadcasted for any protocol, whereas Dtab.local will be broadcasted for propagation on supported protocols. For path name resolution, the Dtab.local will take precedence over the Dtab.limited if the same path is defined in both, and both take precedence over the Dtab.base. The existing Dtab.local request propagation behavior remains unchanged.

### Metrics Metadata
Twitter-Server now bears an [expression endpoint](https://twitter.github.io/twitter-server/Admin.html#admin-metric-expressions-json) (version 1.0), which exports Finagle server's latency, throughput, success rate, and admission control expressions by default. It also provides versatile attributes to support use cases like multi-tenancy systems.
We have made many improvements to [Metric Metadata](https://twitter.github.io/twitter-server/Admin.html#admin-metric-metadata-json) and [Expression](https://twitter.github.io/twitter-server/Admin.html#admin-metric-expressions-json) endpoints, including hydrating richer data, enhancing query ability for consumers, and specifying more definite metric types. 

### Offload Admission Control
The Offload Admission Control project continues to show promise! The algorithm was [tweaked](https://github.com/twitter/finagle/commit/d966d552ec3c20a46ca6381f69503940fcef6e76) to use a surprisingly simple way to measure queue latency that appears to be a bit more responsive than queue depth, resulting in somewhat better performance but more importantly an easier model to reason about. It’s been turned on for a couple of interesting services so far. For one service that is entirely throughput focused, the new algorithm gives similar performance but with better response windows, lowering it from 5 seconds to 125 milliseconds. Perhaps even more exciting results observed during the adoption by another service. With some awesome [improvements](https://github.com/twitter/finagle/commit/710d806caef987dccfb08a95740e041bcdf38de5#diff-85e52b14cda7fac5d9e57d83f31004e36ef8d19fca0ecc085dd4b59770f0ce79) they were able to turn on offload admission control and see a 30% improvement in throughput over their previous configuration. Based on the great success we’re seeing so far, we're experimenting in Q3 to see if we can turn on OffloadFilter and OffloadAdmissionControl as the default configuration for services.

### TLS Snooping for Mux
We [added](https://github.com/twitter/finagle/commit/60705fd270a3ef85c2d31ae09626971cb12b77a8) support for TLS snooping to the mux protocol. This allows a thriftmux server to start a connection as TLS or follow the existing upgrade pathway at the leisure of the client. This allows the server to require encryption via mux opportunistic TLS and still be able to downgrade to vanilla thrift over TLS.

Till next time,
Jing (on behalf of CSL)

---
layout: post
title: 🍠 November 2017 Release Notes - Version 17.11.0
published: true
post_author:
  display_name: Moses Nakamura
  twitter: mnnakamura
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

It's November, and you know what that means!  Library releases!!!  We're now publishing
with sbt 1.0.x, and we now also publish sbt-scrooge-plugin for sbt 1.0.x.

[Finagle 17.11.0][finagle], [Finatra 17.11.0][finatra], [Scrooge 17.11.0][scrooge], [TwitterServer 17.11.0][twitterserver], and [Util 17.11.0][util].

### Finagle ###

New Features:

  * finagle-core: Add `ResponseClassifier`s, RetryOnTimeout and RetryOnChannelClosed,
    for exceptions that are commonly retried when building from ClientBuilder but had
    no MethodBuilder equivalents. [3d292b49](https://github.com/twitter/finagle/commit/3d292b49e737538babb387ae39e6ee9124a641ed)

  * finagle-netty4: `Netty4Transporter` and `Netty4Listener` are now accessible, which
    allows external users to create their own protocols for use with Finagle on Netty 4.
    [3ce475db](https://github.com/twitter/finagle/commit/3ce475dbdb800a635bbed944139b9690418e09d9)

Bug Fixes:

  * finagle-exp: Fix race condition in `LatencyHistogram` which could lead to the wrong
    value returned for `quantile`. [947884f5](https://github.com/twitter/finagle/commit/947884f5ad9119eb9f985c60607927cc7bcafeb2)

Breaking API Changes:

  * finagle-core: Numerous overloads of `c.t.f.Server.serve` have been marked final.
    [ea543806](https://github.com/twitter/finagle/commit/ea5438067e4db78bf5177a1dcde67f19fa8c185b)

  * finagle-thrift: Correctly send `mux.Request#contexts` in all cases. There were some
    cases in which `mux.Request#contexts` were not always propagated. The contexts are
    now always written across the transport. Note that there may be duplicated contexts
    between "local" context values and "broadcast" context values. Local values will
    precede broadcast values in sequence. [45832aad](https://github.com/twitter/finagle/commit/45832aad31aa33e9bddbe18c9e721e825617a159)

### Finatra ###

Changed:

* EmbeddedTwitterServer, EmbeddedHttpServer, and EmbeddedThriftServer flags
  and args parameters changed to call-by-name. [3276d4e9](https://github.com/twitter/finatra/commit/3276d4e99739949af2a691a9966512e86dab7715)

Fixed:

* inject-server: Ensure EmbeddedTwitterServer has started before trying to
  close httpAdminClient. [839afc3b](https://github.com/twitter/finatra/commit/839afc3b54a047185b6606e5ea5b39bb365e1c17)

### Util ###

New Features:

  * util-security: Added `c.t.util.security.PrivateKeyFile` for reading PKCS#8
    PEM formatted `PrivateKey` files. [23f4a6a0](https://github.com/twitter/util/commit/23f4a6a049c55121a4cda34be3b947f3ea4bfc46)

### Scrooge ###

* scrooge-generator: Deprecated some scala generated classes and use new ones
    `FutureIface`         -> `MethodPerEndpoint`,
    `MethodIface`         -> `MethodPerEndpoint.apply()`,
    `MethodIfaceBuilder`  -> `MethodPerEndpointBuilder`,
    `BaseServiceIface`    -> `ServicePerEndpoint`,
    `ServiceIface`        -> `ServicePerEndpoint`,
    `ServiceIfaceBuilder` -> `ServicePerEndpointBuilder`.
  To construct a client use `c.t.f.ThriftRichClient.servicePerEndpoint` instead of
  `newServiceIface`, to convert `ServicePerEndpoint` to `MethodPerEndpoint` use
  `c.t.f.ThriftRichClient.methodPerEndpoint` instead of `newMethodIface`. [26f86b2b](https://github.com/twitter/scrooge/commit/26f86b2b2ad31a6253af3659c12b587ff86ca6b6)

* scrooge-generator: (BREAKING API CHANGE) Change the java generator to no longer
  generate files with `org.slf4j` imports and remove limited usage of `org.slf4j`
  Logger in generated services. [bf5364be](https://github.com/twitter/scrooge/commit/bf5364be4aa0300276336fb2d5bdd3e3e44d7efe)

### Twitter Server ###

Breaking API Changes:

  * Change to apply JUL log format in the `c.t.server.logging.Logging` trait
    constructor instead of in `premain` to apply format as early in the logging
    stack as possible. However, this means that users overriding the
    `def defaultFormatter` will not be able to use any flags to configure their
    formatting, note: the default `LogFormatter` does not use flags.
    [ec674bc5](https://github.com/twitter/twitter-server/commit/ec674bc5b970ffcb267f19b951e28a33ee70ba7c)

### Changelogs ###

* [Finagle 17.11.0][finagle]
* [Util 17.11.0][util]
* [Scrooge 17.11.0][scrooge]
* [TwitterServer 17.11.0][twitterserver]
* [Finatra 17.11.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-17.11.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-17.11.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-17.11.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-17.11.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-17.11.0/CHANGELOG.md
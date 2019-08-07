---
layout: post
title: August 2019 Release Notes - Version 19.8.0
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Hot off the press — the August releases. Here's what's what.

### [Finagle](https://github.com/twitter/finagle/) ###

#### Breaking API Changes

-   finagle-core: The contents of the c.t.f.dispatch.GenSerialClientDispatcher object have been
    moved to the new c.t.f.dispatch.ClientDispatcher object. The stats receiver free constructors
    of GenSerialClientDispatcher and SerialClientDispatcher have been removed.
    [4b0493c6](https://github.com/twitter/finagle/commit/4b0493c6842c222cff71e3b4667fc8e958e3220c)
-   finagle-thrift: The deprecated ReqRepThriftServiceBuilder object has been
    removed. Users should migrate to ReqRepMethodPerEndpointBuilder. [f1c4d589](https://github.com/twitter/finagle/commit/f1c4d5890c14e2131d9543f1a5fa6dd59e908306)

#### Runtime Behavior Changes

-   finagle-core: Failed reads on Linux due to a remote peer disconnecting should now be properly
    seen as c.t.f.ChannelClosedException instead of a c.t.f.UnknownChannelException.
    [b06fab3e](https://github.com/twitter/finagle/commit/b06fab3edceabb010783c3d5ba86c16bfe3b7067)
-   finagle: Upgrade to Jackson 2.9.9. [464ae751](https://github.com/twitter/finagle/commit/464ae7516926d36bcd111266b26c09288648ff16)
-   finagle: Upgrade to Netty 4.1.38.Final. [23532f19](https://github.com/twitter/finagle/commit/23532f19a47ac931ca2ba32773b829a630396127)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Added

-   finatra-http: Introduce the new streaming request and response types:
    c.t.finatra.http.streaming.StreamingRequest [9687e2d7](https://github.com/twitter/finatra/commit/9687e2d7c4be2faf164d322974018cb3e49f0d5f),
    c.t.finatra.http.streaming.StreamingResponse [30fcb686](https://github.com/twitter/finatra/commit/30fcb6860221e2c252452d2c28c8d70f4782b872).
    Examples are located in finatra/examples/streaming-example/.
-   finatra-jackson: Add the ability to specify fields in the MethodValidation annotation.
    [545674e6](https://github.com/twitter/finatra/commit/545674e62195ba6d060f74a83cfb9956eeea3451)

#### Changed

-   inject-thrift-client: make ThriftClientModuleTrait extend StackClientModuleTrait for symmetry
    with other protocol client modules. [27105149](https://github.com/twitter/finatra/commit/271051494d9c9622a6a9eecb7a04cfd204633aa7)
-   finatra-http: Deprecated c.t.finatra.http.response.StreamingResponse, Use
    c.t.finatra.http.response.ResponseBuilder.streaming to construct a
    c.t.finatra.http.streaming.StreamingResponse instead. [30fcb686](https://github.com/twitter/finatra/commit/30fcb6860221e2c252452d2c28c8d70f4782b872)
-   finatra: Upgrade to Jackson 2.9.9. [f050be4f](https://github.com/twitter/finatra/commit/f050be4f65251bc0b6cc8cd9a9b3ab15e6448c76)

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   scrooge-generator: The deprecated ReqRepThriftServiceBuilder has been
    removed. [14d4b980](https://github.com/twitter/scrooge/commit/14d4b98084551822cda2a50159bab19cd0894338)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

#### Changes

-   Upgrade to Jackson 2.9.9. [2a185d94](https://github.com/twitter/twitter-server/commit/2a185d94a6cf6dd1130da839d2148bba7a4179c3)

### [Util](https://github.com/twitter/util/) ###

#### Breaking API Changes

-   util-logging: The namespace forwarders for Level and Policy in com.twitter.logging.config
    have been removed. Code should be updated to use com.twitter.logging.Level and
    com.twitter.logging.Policy where necessary. Users are encouraged to use 'util-slf4j-api' though
    where possible. [6ab4aeac](https://github.com/twitter/util/commit/6ab4aeac5e6b77dba8471b1b06ae4160a3feed56)
-   util-logging: The deprecated com.twitter.logging.config.LoggerConfig and associated
    classes have been removed. These have been deprecated since 2012. Code should be updated
    to use com.twitter.logging.LoggerFactory where necessary. Users are encouraged to use
    'util-slf4j-api' though where possible. [5d43773e](https://github.com/twitter/util/commit/5d43773eb14c73240d4b9424e880ebcff8ecfe20)

#### Runtime Behavior Changes

-   util: Upgrade to Jackson 2.9.9. [0f0bcd44](https://github.com/twitter/util/commit/0f0bcd44d8a241c8b2e14af568cbe83dec0c7fae)

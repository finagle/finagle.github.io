---
layout: post
title: ⛄December 2017 Release Notes - Version 17.12.0
published: true
post_author:
  display_name: Isabel Martin
  twitter: isabel_kmartin
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The December release has arrived!

[Finagle 17.12.0][finagle], [Finatra 17.12.0][finatra], [Scrooge 17.12.0][scrooge], [TwitterServer 17.12.0][twitterserver], and [Util 17.12.0][util].

### Finagle ###

New Features:

  * finagle-core: Expose Tunables for MethodBuilder timeout configuration. Update
    the http.MethodBuilder and thriftmux.MethodBuilder to accept Tunables for
    configuring total and per-request timeouts. [c912dd4b](https://github.com/twitter/finagle/commit/c912dd4bff6f11d587b7fd7f42d976a7b6762f14)

  * finagle-thrift, finagle-thriftmux: Add support for Scrooge
    `ReqRepServicePerEndpoint` functionality. [df5f10bd](https://github.com/twitter/finagle/commit/df5f10bd00b070809ea1f1995becc9bbac6c3089)

  * finagle-thriftmux: Add support for Scrooge `ServicePerEndpoint` and
    `ReqRepServicePerEndpoint` functionality to `thriftmux.MethodBuilder`.
    [3abaa524](https://github.com/twitter/finagle/commit/3abaa52437032c2bbc481e5819d9ca19e12a2b11)

Breaking API Changes:

  * finagle-base-http: Remove deprecated [Request|Response].[encode|decode][Bytes|String]
    methods. Use c.t.f.h.codec.HttpCodec methods instead. [006de6a3](https://github.com/twitter/finagle/commit/006de6a3e762f3725c0c26176145c2634fba3a65)

  * finagle-thrift: Move `ThriftRichClient` and `ThriftRichServer` to
    `c.t.finagle.thrift` package. [fcf66bae](https://github.com/twitter/finagle/commit/fcf66bae591ba1d2707bed97585186268c5b29ff)

Runtime Behavior Changes:

  * finagle-core: The "pipelining/pending" stat has been removed from protocols
    using `c.t.f.dispatch.PipeliningClientDispatcher`. Refer to the "pending" stat
    for the number of outstanding requests. [0d162d17](https://github.com/twitter/finagle/commit/0d162d17ab8de8f3dd8c317e3abcdbfc11b451f7)

  * finagle-thrift,thriftmux: Tracing of RPC method names has been removed. This
    concern has moved into Scrooge. [df161758](https://github.com/twitter/finagle/commit/df1617582fca5ed3832c18d440dae644d9500cb4)


### Finatra ###

Added:

  * finatra-thrift: Add tests for new Scrooge `ReqRepServicePerEndpoint`
    functionalty. [b8e919d3](https://github.com/twitter/finatra/commit/b8e919d3bca36bbdd031d75aedc849beb3c7941f)

Changed:

  * finatra-http: add a `multipart = true` arg to
    `EmbeddedHttpServer.httpMultipartFormPost`. [c139d95](https://github.com/twitter/finatra/commit/c139d95734f60dac9ebbad9b213ad9bfbbb78d9a)
  * inject-sever: Do not use the `c.t.inject.server.EmbeddedTwitterServer`
    `InMemoryStatsReceiver` for embedded http clients. The http client stats are
    emitted with the server under test stats which can be confusing, thus we now
    create a new `InMemoryStatsReceiver` when creating an embedded http client.
    [0c4a8ee5](https://github.com/twitter/finatra/commit/0c4a8ee591d4de7b50e1fd6bbfda0bb27d8fac4d)


### Util ###

API Changes:

  * util-collection: `c.t.util.SetMaker` has been removed.
    Direct usage of Guava is recommended if needed. [b8bd0d4f](https://github.com/twitter/util/commit/b8bd0d4f60303944455402fe9ac2759ab4b2f1c6)


### Scrooge ###

* scrooge: Introduce `scrooge.Request` and `scrooge.Response` envelopes which
  are used in `ReqRepServicePerEndpoint` interfaces and associated code. The
  scrooge `Request` and `Response` allow for passing "header" information (via
  ThriftMux Message contexts) between clients and servers. For instance, a
  server can implement a `ReqRepServicePerEndpoint`, and set response headers
  along with a method response, e.g.,

  ```
  class MyService extends MyService.ReqRepServicePerEndpoint {

    def foo: Service[Request[Foo.Args], Response[Foo.SuccessType]] = {
      Service.mk[Request[Foo.Args], Response[Foo.SuccessType]] { request: Request[Foo.Args] =>
        val result = ... // computations
        Future
          .value(
            Response(
              headers = Map("myservice.foo.header" -> Seq(Buf.Utf8("value1"))),
              result)
      }
    }
  }
  ```

  This `ServicePerEndpoint` can then be served using `ThriftMux`:

  ```
  ThriftMux.server.serveIface(":9999", new MyService().toThriftService)
  ```

  These response headers will be transported as `Mux#contexts` to the client. If
  the client is using the client-side `ReqRepServicePerEndpoint` it will be able
  to read the headers from the returned `Response` directly. E.g.,

  ```
  val client = ThriftMux.client.reqRepServicePerEndpoint[MyService.ReqRepServicePerEndpoint]

  val response: Response[Foo.SuccessType] = Await.result(client.foo(..))

  if (response.headers.contains("myservice.foo.header")) {
    ...
  ```

  Users can also choose to wrap the `ReqRepServicePerEndpoint` with a `MethodPerEndpoint`
  via `ThriftMux.client.reqRepMethodPerEndpoint(reqRepServicePerEndpoint)` in order to
  deal with methods instead of services. See the scrooge documentation for more information.
  [aa1fb0c0](https://github.com/twitter/scrooge/commit/aa1fb0c021f63c8b8880a829fe26efef27c144f5)

### Twitter Server ###

Bug Fixes:

  * Treat `io.netty.channel.epoll.Native.epollWait0` as an idle thread on
    "/admin/threads". This method is observed when using Netty 4's native
    transport. [f8f64a46](https://github.com/twitter/twitter-server/commit/f8f64a46e897782896770b2c5aff9595c6347c08)


### Changelogs ###

* [Finagle 17.12.0][finagle]
* [Util 17.12.0][util]
* [Scrooge 17.12.0][scrooge]
* [TwitterServer 17.12.0][twitterserver]
* [Finatra 17.12.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-17.12.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-17.12.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-17.12.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-17.12.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-17.12.0/CHANGELOG.md

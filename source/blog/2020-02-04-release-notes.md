---
layout: post
title: January 2020 Release Notes - Version 20.01.0
published: true
post_author:
  display_name: Moses Nakamura
  twitter: mnnakamura
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Welcome to the optometrically significant year--the year of perfect hindsight 🤓

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-memcached: Upgrade to Bijection 0.9.7. [de0ec2c6](https://github.com/twitter/finagle/commit/de0ec2c6714ae2c4d8bf76f72cccb9e35f3325da)
-   finagle-opencensus-tracing: Enables cross-build for 2.13.0. [fee83b10](https://github.com/twitter/finagle/commit/fee83b10b55558a8e237445ca4658d4e7858e649)
-   finagle-thriftmux: Add support for automatically negotiating compression between a client
    and server. Off by default, clients and servers must be configured to negotiate.
    [d42c87a9](https://github.com/twitter/finagle/commit/d42c87a97f25573759c1a6f605d0d2265f76619c)
-   finagle-stats: Enables cross-build for 2.13.0. [4144d73c](https://github.com/twitter/finagle/commit/4144d73c9e9f997e219e90888cce108861dc6046)
-   finagle-stats-core: Enables cross-build for 2.13.0. [4144d73c](https://github.com/twitter/finagle/commit/4144d73c9e9f997e219e90888cce108861dc6046)
-   finagle-serversets: Add generic metadata support in ServerSet. Add support for announcing the
    generic metadata via ZkAnnouncer. Add support to resolve the generic metadata via Zk2Resolver
    [180bb925](https://github.com/twitter/finagle/commit/180bb925c9996bd75b26ed0e91b8622623c5e37b)

#### Breaking API Changes

-   finagle-partitioning: ZKMetadata case class has a new default argument breaking API for
    Java users. [180bb925](https://github.com/twitter/finagle/commit/180bb925c9996bd75b26ed0e91b8622623c5e37b)
-   finagle-serversets: Endpoint case class has a new metadata argument. [180bb925](https://github.com/twitter/finagle/commit/180bb925c9996bd75b26ed0e91b8622623c5e37b)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Changed

-   finatra: Exposing Listening Server's bound address in Thrift and HTTP server traits
    [c17f55df](https://github.com/twitter/finatra/commit/c17f55df2dc6295b2801d80ffbb0bf32ffec2123)
-   finatra: Upgrade logback to 1.2.3 [445ddf89](https://github.com/twitter/finatra/commit/445ddf8974ce7a575f55020aceda118fea80cfc3)

#### Fixed

-   inject-server: Fix issue in c.t.inject.server.EmbeddedHttpClient where assertion of an
    empty response body was incorrectly disallowed. This prevented asserting that a server
    was not yet healthy as the /health endpoint returns an empty string, thus even a not yet
    healthy server would report as "healthy" to the testing infrastructure as long as the health
    endpoint returned a 200 - OK response. [e9aa2dac](https://github.com/twitter/finatra/commit/e9aa2dacd4ba2efd2db380135a10cf8ad10ee2b5)

### [Util](https://github.com/twitter/util/) ###

No Changes

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

#### Changed

-   Upgrade logback to 1.2.3 [02433e1e](https://github.com/twitter/twitter-server/commit/02433e1ee39b7bbbdf3300d23fc1b914c9c2afe4)

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   scrooge-core: Remove deprecated ServiceIfaceServiceType and toServiceIfaceService.
    [390ad812](https://github.com/twitter/scrooge/commit/390ad8127a43479f2c244ec209ffed68fbdf5f7e)

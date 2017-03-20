---
layout: post
title: 🌻 Spring Planning 🌻
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The team working on [Finagle](https://twitter.github.io/finagle/), [Finatra](https://twitter.github.io/finatra/), and related libraries met last week and did our planning for the next three months. These are high-level goals and as such, have varying degrees of confidence and certainty.

#### In the spirit of Spring cleaning:

* Remove Netty 3 support from most protocols. We expect to complete most protocols, however HTTP is a long shot.
* Upgrade [libthrift](https://thrift.apache.org/) to 0.10.0 from the ancient fork of 0.5.0.
* Deprecate and then remove modules that are unsupported or exist in a zombie-like state. This includes [ostrich](https://github.com/twitter/ostrich), [finagle-ostrich4](https://github.com/twitter/finagle/tree/develop/finagle-ostrich4), [finagle-kestrel](https://github.com/twitter/finagle/tree/develop/finagle-kestrel), [finagle-stream](https://github.com/twitter/finagle/tree/develop/finagle-stream), [finagle-native](https://github.com/twitter/finagle/tree/develop/finagle-native), [finagle-mdns](https://github.com/twitter/finagle/tree/develop/finagle-mdns), and [util-eval](https://github.com/twitter/util/tree/develop/util-eval).
* Minimize dependencies on [twitter-commons](https://github.com/twitter/commons) with the eventual goal of removing all of them.

#### For those interested in the shiny and new:

* Get HTTP/2 to production level quality so that it becomes the default HTTP implementation.
* Continued SSL/TLS work, including STARTTLS support.
* Finish the work on [Tunables](https://github.com/twitter/util/tree/develop/util-tunable) such that service owners can dynamically change configuration.
* Finish the work on [MethodBuilder](https://github.com/twitter/finagle/blob/develop/finagle-core/src/main/scala/com/twitter/finagle/client/MethodBuilder.scala) as a replacement for ClientBuilder and the foundation for more enhancements.

#### For those who like their tools polished:

* Throughput improvements via changes to Futures, defaulting to the Netty 4 native transport, Netty 4 buffer pooling, and more.
* Switch the default [load balancer](https://twitter.github.io/finagle/guide/Clients.html#load-balancing) to Aperture.
* Switch the default [failure accrual](https://twitter.github.io/finagle/guide/Clients.html#failure-accrual) policy to success rate instead of consecutive failures.
* Move TwitterServer to use [slf4j](https://www.slf4j.org/) for logging and begin the process of moving Util and Finagle.
* A handful of Scrooge changes to make the Scala generated code more composable, fixing [ResponseClassification](https://twitter.github.io/finagle/guide/Clients.html#response-classification) for servers for example.

I realize details here are sparse and certainly not comprehensive. Please ask questions on the mailing list and hopefully we can help clarify if you would like to know more.

Kevin Oliver and the Core Systems Libraries team

---
layout: post
title: Fall Update 🍂
published: true
post_author:
  display_name: Yufan Gong
  twitter: yufangong
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Hi Finaglers,

Fall has arrived in the Northern Hemisphere 🌍🌎🌏, and in San Francisco, we are enjoying the light breeze🎐and warm sunshine☀️. Here are some quick highlights of our work from July, August, and September. If you want to keep an 👁 on our most recent updates, please watch our changelogs ([Util](https://github.com/twitter/util/blob/develop/CHANGELOG.rst), [Scrooge](https://github.com/twitter/scrooge/blob/develop/CHANGELOG.rst), [Finagle](https://github.com/twitter/finagle/blob/develop/CHANGELOG.rst), [Twitter-Server](https://github.com/twitter/twitter-server/blob/develop/CHANGELOG.rst), [Finatra](https://github.com/twitter/finatra/blob/develop/CHANGELOG.rst)).

**Finatra**

We improved HTTP routing backed by a Trie-based data structure to support HTTP 405 (method not allowed) response code and to improve the overall routing performance.

The HTTP JSON `@MethodValidation` now supports specifying an optional parameter `fields` to state which fields are being evaluated in the validation.

We updated `c.t.inject.app.App` to ensure we recurse through the list of `TwitterModule`s for
an application only once with the results encapsulated into a new object. As a result, we are able to properly account for all modules and flags correctly and better Java support for creation of `TwitterModule`s which include other `TwitterModule`s.

**Finagle**

We have added Backpressure (Flow Control) support to Finagle HTTP/2 clients in order to improve resilience and reduce the likelihood of data overflow scenarios for HTTP/2 clients.

**Twitter Server**

A prototype of metric metadata endpoint has been shipped. The endpoint exposes type information such as counter, gauge, or histogram for the service metrics. It lives at `/admin/exp/metric_metadata`, please give us feedback, we will soon ship a more complete metric metadata endpoint!

**Streaming**

Introduced improved APIs for steaming JSON over HTTP in Finatra, `StreamingResponse` and `StreamingRequest`, they are streaming types that enable dynamically generating content and transmitting content in chunks, they read and write streams as JSON. The backing stream can be either Reader or AsyncStream. And the StreamingResponse and StreamingRequest also carry the metadata for the HTTP response and request.

**Scala 2.13 Migration and JDK 11 compatibility**

With Help from the Open Source Community, Util and Scrooge are upgraded to cross-build with Scala 2.13, see this [tweet](https://twitter.com/finagle/status/1183798168187592706). Finagle is currently in progress, [help wanted](https://github.com/twitter/finagle/issues/771)!

Util, Scrooge, Twitter-Server, Finagle and Finatra now are JDK 11 Compatible!

**Libraries Upgrade**

We upgraded several of our libraries to Jackson 2.9.9, and Finagle Netty4 dependency to Netty 4.1.39.Final. For Scala 2.13 compatibility, we also upgraded ScalaTest to 3.0.8, Scala Parser Combinator to 1.1.2 and added Scala Collection Compat as 2.1.2.

**Technical Debt**

Apache commons-lang is no longer a dependency of Finatra, replaced usages with alternative stdlib methods. 

Best,

Yufan and the Core Systems Libraries Team

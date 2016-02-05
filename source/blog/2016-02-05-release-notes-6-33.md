---
layout: post
title: Finagle 6.33 Release Notes
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Util, Ostrich, Scrooge, TwitterServer
---

In this milestone, we've been focusing on two major directions:

1. Improving users experience by providing friendly APIs and updating docs
2. Continuing to improve Finagle's resiliency

### Discoverable Params

There is new user-friendly API for configuring Finagle clients and servers using `with`-prefixed
methods (`.withClientId`, `.withStatsReceiver`, etc). Discoverable configuration parameters, are a
modern alternative to ClientBuilder/ServerBuilder which provides an easy to use, type safe, and IDE
discoverable API on top of `$Protocol.{client,server}.configure`d through a collection of
`with`-prefixed methods available on both clients and servers. It’s already in master and we
encourage you to open your favorite IDE and type `client.with` or `server.with` and start discovering.

Example:

```scala
import com.twitter.finagle.Http
import com.twitter.conversions.time._

Http.client
  .withLabel("http-client")
  .withSessionQualifier.noFailFast
  .withSession.acquisitionTimeout(10.seconds)
```

We thought carefully about how to make these clear and easy to use. If you're curious about the
design, please feel free to take a look at the [design principles][design-principles].

The new API is fully documented so that every method has an up-to-date scaladoc comment explaining
the parameters it configures as well as mentions its default values.

Also, it's worth mentioning that this is API is 100% Java-friendly. You can now forget about
`new Param(...).mk(...)` and focus on what’s important–values, not the wrappers around them.

### New User Guide

We updated/reworked [Finagle’s User Guide][user-guide] recently to capture the current state of
Finagle. For example, we updated both [Clients][clients] and [Servers][servers] with example
configurations of their modules.

### Response Classifiers

Finagle’s new [response classifiers][classifiers] improve client’s avoidance of faulty nodes thus
increasing your success rate. To get this benefit, you must wire up the application’s rules into your
clients. There is already basic classifiers in Finagle available for HTTP and Thrift.

For example, the following configuration advices a Finagle client treat 500s HTTP responses as
non-retriable failures.

```scala
import com.twitter.finagle.Http
import com.twitter.finagle.http.service.HttpResponseClassifier

Http.client
  .withResponseClassifier(HttpResponseClassifier.ServerErrorsAsFailures)
```

### Pending Requests Limit

As part of our work on client-side admission control, there is a new client module maintaining the
limit of pending requests (i.e., requests that haven't been yet written to a wire). The limit is
unbounded by default.

In the following example, an HTTP client is configured to have at most 100 pending requests in the
queue. All requests on top of 100 will be rejected by a client.

```scala
import com.twitter.finagle.Http

Http.client
  .withAdmissionControl.maxPendingRequests(100)
```

### Changelog

* [Finagle 6.33][finagle]
* [Util 6.32][util]
* [Scrooge 4.5][scrooge]
* [TwitterServer 1.18][ts]
* [Ostrich 9.16][ostrich]

[design-principles]: http://twitter.github.io/finagle/guide/Configuration.html#design-principles
[user-guide]: http://twitter.github.io/finagle/guide/
[clients]: http://twitter.github.io/finagle/guide/Clients.html
[servers]: http://twitter.github.io/finagle/guide/Servers.html
[classifiers]: http://twitter.github.io/finagle/guide/Clients.html#response-classification
[finagle]: https://github.com/twitter/finagle/blob/develop/CHANGES
[util]: https://github.com/twitter/util/blob/develop/CHANGES
[ts]: https://github.com/twitter/twitter-server/blob/develop/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/develop/CHANGES
[ostrich]: https://github.com/twitter/ostrich/blob/develop/CHANGES
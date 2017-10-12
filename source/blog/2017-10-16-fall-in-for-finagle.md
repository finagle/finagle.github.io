---
layout: post
title: 🍂 Fall-ing for Finagle 🍂
published: true 
post_author:
  display_name: Christopher Coco 
  twitter: cacoco
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

As we move headlong into Autumn we thought this might be a good time to take
a quick look back at some of the work from the previous quarter in [Finagle](https://twitter.github.io/finagle/), [Finatra](https://twitter.github.io/finatra/), [Scrooge](https://twitter.github.io/scrooge), [TwitterServer](https://twitter.github.io/twitter-server), and [Util](https://twitter.github.io/util) and preview what we're working on this quarter and beyond.

This covers the
[August](https://github.com/twitter/finagle/tree/finagle-7.0.0) and [September](https://github.com/twitter/finagle/tree/finagle-7.1.0) releases as well as the upcoming release planned for this month. As mentioned before, we plan to continue this review
regularly on a quarterly basis. You can start with a recap of what we were talking about [last time](https://finagle.github.io/blog/2017/07/12/summer-review/).

### News & Notes

------------

- Finagle's 7th "birthday" (7th anniversary of the [first public
commits](https://github.com/twitter/finagle/tree/e04e51645374f8d958d85de384142dd00f4b7574))
is approaching. Stay tuned for a celebratory blog post!

- We're retiring the [Finatra](https://github.com/twitter/finatra)-specific
blog, formerly available
[here](https://twitter.github.io/finatra/blog/archives/). This will happen with 
our next release scheduled in the next few weeks. Unfortunately, we won't be 
keeping any of the old posts but any new information will be shared on the 
finagle blog here.

---------

#### Efficiency

Metrics ‘verbosity’ level. Similar to logging levels in a logging API, we've
introduced the concept of a verbosity level for metrics exported by Finagle
([1](https://github.com/twitter/finagle/commit/6c666ab5c3363ae5bd22b0fbd96f33995fe36ac7),
[2](https://github.com/twitter/util/commit/5e03745015693bc61fa2aace8da5eb452ff6e53d),
[3](https://github.com/twitter/util/commit/d08661fe49377aafd8af60231d6112d546e55e01),
[4](https://github.com/twitter/util/commit/1b3ce1eddbb2a9af9fa4f97f1fc1b20ac3ee6a40))
with the ability for users to configure their service's verbosity and to
define a verbosity when creating a new metric.

For more information see the [Util](https://twitter.github.io/util) User's Guide section on [`Leveraging
Verbosity
Levels`](https://twitter.github.io/util/guide/util-stats/user_guide.html#leveraging-verbosity-levels).

Our internal roll-out of our new load balancer, [Deterministic
Aperture](https://github.com/twitter/finagle/blob/finagle-6.45.0/finagle-core/src/main/scala/com/twitter/finagle/loadbalancer/aperture/DeterministicOrdering.scala) continues and we’re excited about bringing this to the wider community soon!

### Resiliency

Transparently replacing HTTP/1.1 usage with HTTP/2 is continues internally. HTTP/2 gives you the resource reductions (a single multiplexed connection) and resiliency features (fast rolling restarts without a success rate drop) that services are already accustomed to with Mux.

### Operability

We’ll be open-sourcing the work done by our summer intern [@McKardah](https://twitter.com/McKardah) to wire
Twitter Futures into [IDEA’s async
stacktraces](https://blog.jetbrains.com/idea/2017/02/intellij-idea-2017-1-eap-extends-debugger-with-async-stacktraces/).

We’ve completed the internal rollout of [edge-triggered native
transport](https://github.com/twitter/finagle/search?utf8=%E2%9C%93&q=nativeEpoll&type=) using Netty’s JNI edge-triggered transport, instead of using the JDK’s NIO and are working to make it available to configure externally.

#### Security

Secure Mux (smux). We've added a
[STARTTLS](https://en.wikipedia.org/wiki/Opportunistic_TLS) command into the
Mux protocol in order to support opportunistic TLS for ThriftMux.

#### Logging Improvements

We've been working hard to move
[TwitterServer](https://github.com/twitter/twitter-server) to the [SLF4J
API](https://) and this should be merging in the near future. Stay tuned for
updates and documentation on the changes.

#### Scrooge Updates

We've been making lots of changes to improve the usability and performance of
Scrooge and Scrooge-generated code. This includes a set of refactorings to modernize the generated code so that it’s written in terms of Filters and Services!

This will allow us to address some long standing issues like server-side response classification and correctly stating on serialization/deserialization failures.

Additionally, we going to try to update to libthrift 0.10.0 from 0.5.0. This is still exploratory and we’re working to understand the ramifications.

#### Bringing Backup Requests Back

Finagle has had a
[BackupRequestFilter](https://github.com/twitter/finagle/blob/develop/finagle-exp/src/main/scala/com/twitter/finagle/exp/BackupRequestFilter.scala)
since [late
2012](https://github.com/twitter/finagle/commit/526e508579309711a9c56007eff2a783826d331c)
and evolved into its current form in [early
2013](https://github.com/twitter/finagle/commit/8ca92593aac1d3f5bd4741d6b8e6fcf26053dc44).
The filter has a variety of what we would consider flaws (too many
configuration knobs, less than ideal memory characteristics in many cases,
lack of integration into the Stack-APIs and ClientBuilder to name a few) which
has relegated it to Finagle's experimental module.

We're investigating what it would take to give users a single configuration
variable -- ideally the percentage of additional requests to send -- to
configure sending a backup request to another server.

#### ‘Push’ based API for Protocols

Modern multiplexing protocols are characteristically very stateful and event
driven making them challenging to implement with the current ‘pull’ based
abstractions available in Finagle.

We are currently working towards the introduction of a Finagle ‘push’ based
model which when coupled with a single threaded concurrency model would
provide a more efficient and natural foundation for implementing multiplexing
protocols.

#### Application-Level Streaming Research

Related to the above, Finagle has historically been dependent on
request-response style protocols: a single request would be sent by the client
and the server would reply with a single response. And then later multiplexing
protocols to alleviate head-of-line blocking. However, all the protocols in
Finagle are expressed as request-response APIs with some limited support for
streaming through using Reader and AsyncStream
[[1](https://github.com/twitter/finagle/blob/develop/finagle-example/src/main/scala/com/twitter/finagle/example/http/HttpStreamingServer.scala)].
These are somewhat low-level constructs and can be hard to use properly.

We are investigating the design of an API for bidirectional streaming of objects not just bytes. Stay tuned.

#### Blocking Code Detection

Our newest intern [@andrewmccree14](https://twitter.com/andrewmccree14) is
working on a project to help detect code that is blocking in Finagle. This
should not only help users of Finagle but also allow for instrumentation and
reporting (linting) of the blocking code. We're really excited about this
work and can't wait to share it with the community.

------------

Thanks for following along. As always, please feel free to ask questions on
either the [Finagle](https://groups.google.com/forum/#!forum/finaglers) or
[Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists
about anything that is unclear if you would just like to know more.

Christopher Coco and the Core Systems Libraries team

---
layout: post
title: 🏖️ Summertime Review
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

It’s time to take a look back at what went down in
[Finagle](https://twitter.github.io/finagle/),
[Finatra](https://twitter.github.io/finatra/) and related libraries
over the past few months and get an idea of what’s to come. This
covers the
[April](https://github.com/twitter/finagle/releases/tag/finagle-6.44.0) and
[June](https://github.com/twitter/finagle/releases/tag/finagle-6.45.0) releases
(apologies for missing May) as well as the upcoming 7.0.0 release
planned for the next week or two. We plan to continue this review
regularly, on a quarterly basis. You can start with a recap of what we
were talking about [last
time](https://finagle.github.io/blog/2017/03/20/spring-planning/).

#### Efficiency

Considerable effort at improving the throughput of Finagle services
was undertaken and your CPU cores and garbage collectors have spent
that extra time getting an early start on their summer beach reads.
This work was broad based and intended to help the majority of Finagle
users. Examples include our Tweet service which saw a 15% decrease in
CPU time and a 13% decrease in allocations while our User service saw
16% and 6% respectively.

The work began with a suite of optimizations to Twitter
Futures \[[1](https://github.com/twitter/util/commit/9261c493490b3b916fcb4fe1f704d9dda2192035),
[2](https://github.com/twitter/util/commit/da5bdcd02d94e35b194f1e923ce5cbc02d603865),
[3](https://github.com/twitter/util/commit/01eb1e4d3e5b1c76c91f8f2e8c963e95db6a86b6),
[4](https://github.com/twitter/util/commit/21747f6aa96a960ee4277af08bd028e042de0542),
[5](https://github.com/twitter/util/commit/90bdd298555ffd815f2f3f4de5277bb90fb5da65),
[6](https://github.com/twitter/util/commit/a914d536448b1e9d55881dee15a370ad3369c911),
[7](https://github.com/twitter/util/commit/a51c2d0cacce0ae4a7d5f99fad58e19fe3e6d670),
[8](https://github.com/twitter/util/commit/b86df6884a798e485bacac53d8f0f9e071413ced),
[9](https://github.com/twitter/util/commit/fe44b073cc188bf861fa91aecf71afabde9b72f7),
[10](https://github.com/twitter/util/commit/dbb7d1a56c4bd7f65f42b6c9a547c243201ba2cc),
[11](https://github.com/twitter/util/commit/20f7b5e9ae09595f149788a8c2c8e5cf9cf8dd73),
[12](https://github.com/twitter/util/commit/ea5ec99207307ba0bb4868754f22dc10d7d3774d),
[13](https://github.com/twitter/util/commit/76ea96225a9e03581f75d3a91dd86b6d09a77fbb)\] (these
ideas came courtesy of
[@flaviowbrasil](https://twitter.com/flaviowbrasil)).

Finagle’s memcached client got a tune
up \[[1](https://github.com/twitter/finagle/commit/f47ffdfa1f67d1c029e5dc7d782e8d22de2d56a6),
[2](https://github.com/twitter/finagle/commit/4a19d7d0102a18b30bb04ddc8a8b94ea199d2e5f),
[3](https://github.com/twitter/finagle/commit/66f14feb5d92bcdcce471b48d191c697935c4e8f),
[4](https://github.com/twitter/finagle/commit/7f4b052b10aac702d985d8288bf6c7afaec4e514),
[5](https://github.com/twitter/finagle/commit/5978d6bf6083cc778c8bcfe0f8ad0d63d8514226)\]
and microbenchmarks show decoding times decreased by a factor of four.

The move to Netty 4 allows us to take advantage of more optimizations
and internally we’ve toggled on [buffer
pooling](https://github.com/twitter/finagle/blob/finagle-6.45.0/finagle-netty4/src/main/resources/com/twitter/toggles/configs/com.twitter.finagle.netty4.json#L14) and
[refcounting](https://github.com/twitter/finagle/blob/finagle-6.45.0/finagle-netty4/src/main/resources/com/twitter/toggles/configs/com.twitter.finagle.netty4.json#L9) for
ThriftMux control messages while the rollout of the [edge-triggered
native
transport](https://github.com/twitter/finagle/blob/finagle-6.45.0/finagle-netty4/src/main/resources/com/twitter/toggles/configs/com.twitter.finagle.netty4.json#L4) is
in progress.

Our new load balancer, [Deterministic
Aperture](https://github.com/twitter/finagle/blob/finagle-6.45.0/finagle-core/src/main/scala/com/twitter/finagle/loadbalancer/aperture/DeterministicOrdering.scala),
has begun early production usage. It is early days, though the initial
results are promising and our goal is to promote it to Finagle’s
default load balancer.

Scrooge work included allocation reductions for
[Scala](https://github.com/twitter/scrooge/commit/ac5cd42ed751c351509d10ec959ed87985ca8672) and
[Java](https://github.com/twitter/scrooge/commit/4cd9ee7017d75cec068f5acf14b97bc2955474ec) generated
code. Investigations have begun to see if the generated code can be
more modularized which will unlock
 [ResponseClassification](https://twitter.github.io/finagle/guide/Clients.html#response-classification) on
the server-side among other wins.

The emphasis on efficiency will continue this summer with a few bets
we believe will payoff. The first is making ThriftMux+Scrooge operate
directly on off-heap buffer representations, unlocking zero-copy
payloads. Given the gains we’ve seen by leaving Mux control messages
off-heap, we expect big gains. The second bet is changing Mux’s
sessions to be “push based” instead of “pull”. This avoids the
conversions back and forth from Netty’s push model and early
prototyping has shown significant throughput improvements. Assuming
the new push based model performs as expected, we plan to deliver
similar changes for HTTP/2 and Memcached.

#### Resiliency

Transparently replacing HTTP/1.1 usage with HTTP/2 is underway. H2
gives you the resource reductions (a single multiplexed connection)
and resiliency features (fast rolling restarts without a success rate
drop) that services are already accustomed to with Mux.

#### Operability

While most of the spring was work on plumbing that you get for free, a
couple of user APIs were added in
[Tunables](https://twitter.github.io/finagle/guide/Configuration.html#tunables) and
[MethodBuilder](https://twitter.github.io/finagle/guide/MethodBuilder.html).

There is a rich tradition of our interns landing incredibly useful
functionality — TwitterServer’s admin pages UI, client-side nack
admission control, and histograms details. This summer is no different
with [@McKardah](https://twitter.com/McKardah) working to wire up
Twitter Futures into [IDEA’s async
stacktraces](https://blog.jetbrains.com/idea/2017/02/intellij-idea-2017-1-eap-extends-debugger-with-async-stacktraces/).

Converting logging in TwitterServer over to slf4j is a large change
that is in progress.

#### Security

A revamped set of APIs for SSL/TLS were shipped which is powering our
mTLS implementation. SSL/TLS work continues with a goal of adding
[STARTTLS](https://en.wikipedia.org/wiki/Opportunistic_TLS) support to
Mux.

#### Tech Debt

All of Finagle’s protocols have been migrated to Netty 4 (squeee!!!)
and the work to rip Netty 3 completely out of Finagle is pretty far
along. It has taken us years to get here and the benefits for
efficiency and features like HTTP/2 are good indicators of why it was
worth it.

Thanks for following along. Please feel free to ask questions on the
[mailing
list](https://groups.google.com/forum/#!forum/finaglers) about
anything that is unclear and we’ll help clarify if you would like to
know more.

Kevin Oliver and the Core Systems Libraries team

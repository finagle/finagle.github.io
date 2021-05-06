---
layout: post
title: Spring Update 2021 🚲
published: true
post_author:
  display_name: Hamdi Allam
  twitter: allam_hamdi
tags: Finagle, Finatra
---

Hey Finaglers,

Spring has sprung and the time has come ⏰ to update you on all of the exciting
changes we’ve been making. Here’s our quarterly review for Q1 2021, highlighting
our work in January, February, and March!

Without further ado, here’s our recap:

🎉 Our libraries all now cross-build with Scala 2.13! As of the 21.3.0 release,
we’ve dropped build support for 2.11, focusing on Scala 2.12+.


#### Finagle

Investing in our Offload Filter has paid large performance dividends.
And we are finding even more ways to make our services more performant! We’ve
introduced a new flag, c.t.f.offload.auto, that enables offloading functionality
with good defaults to avoid the tuning processes. Our latest efforts have
revolved around introducing an offload admission controller.

Finagle has been migrated to make use of the new Backoff APIs. Microbenchmarks
that traverse the new implementation have shown a 52% allocation improvement
compared to the Stream based implementation.

Finagle-Mysql has added support for opportunistic TLS! Mysql clients can fallback
to plain-text if the server does not support TLS connections.

Kerberos authentication can be incorporated more naturally in Finagle http clients
and servers with built-in configuration APIs.

Aperture eager connections is enabled by default for the aperture load
balancers! New configuration knobs were added to support eager connections in
balancers created due to request-level d-tabs.

We’re always looking to improve our APIs and add features to improve your
experience with Finagle. This included introducing a new ResponseClassifier to
treat request timeouts as ignorable, useful for low-timeout clients where
responses are “best-effort”. Finagle’s “failures” counter was changed to be
created eagerly so the counter’s value is 0 in the absence of failures. Stay
tuned for more!

#### Finatra

ThriftMethodBuilder added support for including per-method retry
configuration. Finatra kafka-streams AsyncTransformer supports using thread pools
for CPU-bound workloads.

We are committed to improving the user experience for our Finatra users and have
introduced the finatra/http-core project. Containing common artifacts for the
finatra/http-server and finatra/http-client project. The shared code will allow
us to provide greater feature parity between the client and server
implementations, as well as iterate and introduce new features for Finatra
services in a maintainable way.


Till next time,

Hamdi (on behalf of CSL)

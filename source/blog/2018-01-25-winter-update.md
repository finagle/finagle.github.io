---
layout: post
title:❄️ ❄️ ❄️ Winter Update ❄️ ❄️ ❄️
published: false 
post_author:
  display_name: Daniel Schobel
  twitter: dschobel
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

We've been running scalac around the clock to fend off the cold and bring you another quarter's
worth of features and improvements to Finagle and Friends: [Finagle](https://twitter.github.io/finagle/),
[Finatra](https://twitter.github.io/finatra/),
[Scrooge](https://twitter.github.io/scrooge),
[TwitterServer](https://twitter.github.io/twitter-server), 
[Util](https://twitter.github.io/util) 


#### Efficiency
Future received a more efficient [LIFO callback evaluation order](https://github.com/twitter/util/commit/e650dc5bd3dfbcee9a9ceb1bccf99ee591ea7101).

[ThriftMux](https://github.com/twitter/finagle/commit/d63186f147653b5c222e613ba50ae0686ab071e3) and [memcached](https://github.com/twitter/finagle/commit/2d37c2c1684132121f15423b2f08054785f8e29c) both received new push-based implementations bringing further cpu efficiency gains.

#### Resiliency

Our new load balancer [Deterministic Aperture](https://github.com/twitter/finagle/commit/1c1668da34f4dc5659fb3d872765c2b24fcc440e) continued getting refinements along the way.

#### Operability

ThriftMux now supports [response headers](https://github.com/twitter/finagle/commit/df5f10bd00b070809ea1f1995becc9bbac6c3089).

Our summer intern [@McKardah](https://twitter.com/mckardah) added the ability to wire Twitter Futures
into [IDEA’s async stacktraces](http://finagle.github.io/blog/2017/11/02/async-stack-traces/).

Finagle went on strict apache commons and [guava detoxes](http://finagle.github.io/blog/2017/12/12/guava-less/), significantly reducing the exposure of
these large dependencies.

Finatra, Macaw, and [Twitter-Server](https://github.com/twitter/twitter-server/commit/c458b88161f56768d0226c8419424f8365574b83) moved from util-logging to SLF4J.

Latency is one of the hardest things to diagnose in any system but it’s been made easier with the
introduction of [Trace level request logging](https://github.com/twitter/finagle/commit/203fed55335633173b2a36b98c30c55336baaf3a) which will identify both synchronous and asynchronous
latency.

#### Security
Twitter’s util library learned how to read [PKCS#8 PEM PrivateKey files](https://github.com/twitter/util/commit/23f4a6a049c55121a4cda34be3b947f3ea4bfc46) and Certificate Revocation List
PEM formatted [X509CRL files](https://github.com/twitter/util/commit/32d8cc8ac4fc4c1f9417df6ec6da392291eb4759).

------------

As always, please feel free to ask questions on
either the [Finagle](https://groups.google.com/forum/#!forum/finaglers) or
[Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists.


See you in the Spring!

Daniel Schobel and the Finagle team

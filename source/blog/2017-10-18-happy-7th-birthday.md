---
layout: post
title: 🎂 Finagle’s 7th Birthday
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Seven years ago a [simple commit][first_commit] got Finagle's open source repository
started. Finagle [began][blog_post] as a means of dealing with the complexity and
fragility of distributed systems issues here at Twitter. While
distributed systems remain complex and it is not a silver bullet,
Finagle has enabled a great many to build resilient, high throughput
applications.

The pace of development remains high — with over 1,600 commits in the
past year across [Finagle][finagle], [Finatra][finatra], [Util][util], [Scrooge][scrooge], and [TwitterServer][twitterserver].
It is unlikely to slow down with 13 devs on the core team. Externally
the community [adoption][adoption] is broad, spawned a [company][company], and inspired
versions in [C++][cpp] and [Rust][rust].

With a wide user base numbering into the hundreds of services, our
development philosophy has changed focus over the years. There has
been a shift to capabilities that service owners get for free — simply
redeploy with the latest version and voilà! Examples include retry
budgets, HTTP/2, improved throughput, and admission control with
automatic retries among others.

While you'd now consider a robust RPC library table stakes in
microservice deployments, that was not the case in 2010. We're proud of
Finagle's consistent progress and excited about Future\[Finagle\].

Here's to the next 7 years,

Kevin Oliver and the Core Systems Libraries team

[finagle]: https://github.com/twitter/finagle
[util]: https://github.com/twitter/util
[scrooge]: https://github.com/twitter/scrooge
[twitterserver]: https://github.com/twitter/twitter-server
[finatra]: https://github.com/twitter/finatra
[first_commit]: https://github.com/twitter/finagle/tree/e04e51645374f8d958d85de384142dd00f4b7574
[blog_post]: https://blog.twitter.com/engineering/en_us/a/2011/finagle-a-protocol-agnostic-rpc-system.html
[adoption]: https://github.com/twitter/finagle/blob/develop/ADOPTERS.md
[company]: https://buoyant.io/2016/02/18/linkerd-twitter-style-operability-for-microservices/
[cpp]: https://github.com/facebook/wangle
[rust]: https://medium.com/@carllerche/announcing-tokio-df6bb4ddb34

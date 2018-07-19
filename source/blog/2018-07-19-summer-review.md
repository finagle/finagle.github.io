---
layout: post
title: 🎇 Summertime Update 🎆
published: true
post_author:
  display_name: Jordan Parker
  twitter: nepthar
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Believe it or not, summer is in full swing and it's once again time to take stock of where we've been and where we're headed. For a full list of changes over the past quarter, check out the older posts on this blog.

#### Operability

We've continued to focus on mysql usability through various improvements to our API. ([1](https://github.com/twitter/finagle/commit/f3676d3186fb5dddb4fc2a833c79094af5fb460e), [2](https://github.com/twitter/finagle/commit/ebde8ebe203a88b8cba481c39033dac3c71e02e9), [3](https://github.com/twitter/finagle/commit/2f3650cf600f5a666a2e95fc6631f819b515d55d), [4](https://github.com/twitter/finagle/commit/f67978aaa48b7b65e20de787b0d84354cb5a968e), [5](https://github.com/twitter/finagle/commit/2f3650cf600f5a666a2e95fc6631f819b515d55d), [6](https://github.com/twitter/finagle/commit/5a54f45da4b78f22ccc001164f7c3df5314b34ce), [7](https://github.com/twitter/finagle/commit/c5bd6b975657782607ad33b73ea414661a54f544), [8](https://github.com/twitter/finagle/commit/48f688d1b52ed51499eb3c693a4fe253a5b67100), [9](https://github.com/twitter/finagle/commit/1b9111eb3e8576c41977b05447a3f17ef1c1a5f9))

TwitterServer's HTTP admin interface has a [new endpoint](https://twitter.github.io/twitter-server/Admin.html#admin-balancers-json), admin/balancers.json, which provides information about the state of each client's load balancers.

We've also focused attention on making all parts of our stack easier to use from Java and will continue to do so. Please let us know where we fall short here! ([1](https://github.com/twitter/finagle/commit/6534e459302f48ba252cd7729eb57653c3b49b93), [2](https://github.com/twitter/finagle/commit/16dbe1705303ec61e3cd75cf1f63957ef7f6405f), [3](https://github.com/twitter/finagle/commit/f67978aaa48b7b65e20de787b0d84354cb5a968e))

We've simplified our HTTP cookie API and added support for the SameSite attribute. We also continued work tracking down some broken HTTP/1.x & HTTP/2 corner cases. Work actively continues on HTTP/2.

Finally, we revamped the string representation of services and filters. This means looking at those objects in a debugger provides MUCH more useful information. [1](https://github.com/twitter/finagle/commit/25474da16ff5cbaf18a764f199e42e569c152452)

#### Resiliency

[Deadlines](https://twitter.github.io/finagle/docs/com/twitter/finagle/context/Deadline.html) are working their way back into production at Twitter and can be used to avoid doing unnecessary work for requests which are about to time out anyway. Expect to hear more about our rollout in the future.

Our newest loadbalancer, Deterministic Aperture, [got a bit more deterministic](https://github.com/twitter/finagle/commit/3d84e2975fb46982d5cedeb1f43e2c9c89221840). We found that allowing the aperture to expand based on load caused uneven load distribution, so we've disabled this feature by default.

------------

Want to know more or have a question? Ask away at our [Finagle](https://groups.google.com/forum/#!forum/finaglers) or
[Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists or hop on [Gitter](https://gitter.im/twitter/finagle)


Stay cool but keep your caches warm,

Jordan Parker and the Core Systems Libraries team

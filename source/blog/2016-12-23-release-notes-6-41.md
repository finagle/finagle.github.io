---
layout: post
title: Finagle 6.41 Release Notes
published: true
post_author:
  display_name: Jillian Crossley
  twitter: jillyfish
tags: Releases, Finagle, Util, Ostrich, Scrooge, TwitterServer
---

As the year ends, we've got an exciting new release for you! Here's a quick rundown
of what we've been up to.

### Scala 2.12 Support is Here

Finagle, Util, Ostrich, Scrooge, and Twitter-Server are all now cross-compiled for Scala 2.11 and 2.12(!)

### Dynamic Timeouts
The new [Dynamic Timeout module][dynamic timeouts] module allows clients to specify call-site specific timeouts. 

### Deadline Filter Rises from the Dead
We've resurrected [Deadline Filter][deadline filter] as an optional module that can be added to clients and servers to reject requests with expired deadlines. If your calling clients are
well-prepared to handle the resulting NACKs, check out this filter.

### Filtered ThriftMux Clients
You can now add filters (using the `.filtered` method) on ThriftMux stack clients.

### Turn it up to a 1.0
Toggles prove a convenient way to slowly roll out functionality. We've now promoted them
out of experimental. If you'd like to give them a go, check out the [guide][toggles].

### Next Year in....Finagle
The team is steadily working towards Netty 4. Since the last update, we've finished migrating
Memcached and MySQL, and Redis will come in the next release.

Here's to a great 2017!

### Changelog

* [Finagle 6.41][finagle]
* [Util 6.40][util]
* [Scrooge 4.13][scrooge]
* [TwitterServer 1.26][ts]
* [Finatra 2.7][finatra]
* Ostrich 9.24 (no changes, only dependency bump)

[finagle]: https://github.com/twitter/finagle/releases/tag/finagle-6.41.0
[util]: https://github.com/twitter/util/releases/tag/util-6.40.0
[scrooge]: https://github.com/twitter/scrooge/releases/tag/scrooge-4.13.0
[ts]: https://github.com/twitter/twitter-server/releases/tag/twitter-server-1.26.0
[finatra]: https://github.com/twitter/finatra/releases/tag/finatra-2.7.0
[toggles]: http://twitter.github.io/finagle/guide/Configuration.html#feature-toggles
[deadline filter]: https://github.com/twitter/finagle/blob/finagle-6.41.0/finagle-core/src/main/scala/com/twitter/finagle/service/DeadlineFilter.scala
[dynamic timeouts]: https://github.com/twitter/finagle/blob/finagle-6.41.0/finagle-core/src/main/scala/com/twitter/finagle/client/DynamicTimeout.scala
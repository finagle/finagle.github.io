---
layout: post
title: May 2018 Release Notes - Version 18.5.0
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Good news, everyone! Finagle & Finatra May releases are here!

As usual, all the corresponding Github projects for Finagle, Finatra, Util, Twitter Server, and
Scrooge have their release pages updated:

 * [Finagle 18.5.0][finagle]
 * [Util 18.5.0][util]
 * [Scrooge 18.5.0][scrooge]
 * [TwitterServer 18.5.0][twitterserver]
 * [Finatra 18.5.0][finatra]

Here are some notable changes:

 * Finagle's ThriftMux transport has been switched to a more efficient and simpler implementation: [cc333151]
 * We fixed a bug in Util's `AsyncSemaphore` so it no longer causes deadlocks: [b3b66cf8]
 * Finagle's HTTP implementation now incorporates `SameSite` attribute for cookies: [4b0a58b0]
 * Various changes to Finagle MySQL to improve the user's experience: [f3676d31], [f3676d31], [2f3650cf],
   [f67978aa]

[finagle]: https://github.com/twitter/finagle/releases/tag/finagle-18.5.0
[util]: https://github.com/twitter/util/releases/tag/util-18.5.0
[scrooge]: https://github.com/twitter/scrooge/releases/tag/scrooge-18.5.0
[twitterserver]: https://github.com/twitter/twitter-server/releases/tag/twitter-server-18.5.0
[finatra]: https://github.com/twitter/finatra/releases/tag/finatra-18.5.0
[4b0a58b0]: https://github.com/twitter/finagle/commit/4b0a58b0e0eaa246b9ffbca29f6a9de15d7b2584
[b3b66cf8]: https://github.com/twitter/util/commit/b3b66cf8df6dd5fb4d97131b110150d5403dfb68
[f3676d31]: https://github.com/twitter/finagle/commit/f3676d3186fb5dddb4fc2a833c79094af5fb460e
[f3676d31]: https://github.com/twitter/finagle/commit/f3676d3186fb5dddb4fc2a833c79094af5fb460e
[2f3650cf]: https://github.com/twitter/finagle/commit/2f3650cf600f5a666a2e95fc6631f819b515d55d
[f67978aa]: https://github.com/twitter/finagle/commit/f67978aaa48b7b65e20de787b0d84354cb5a968e
[cc333151]: https://github.com/twitter/finagle/commit/cc33315126a7fd5f2c798d0fefc28d92053b59b0


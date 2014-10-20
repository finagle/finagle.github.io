---
layout: post
title: Upgrading Finagle to Netty 4
published: true
post_author:
  display_name: Sonja Keserovic
  twitter: thesonjake
tags: Roadmap, Finagle, Netty
---

Netty 4 was released [more than a year
ago](http://netty.io/news/2013/07/16/4-0-0-Final.html) and Netty 5 Alpha is
already available. Finagle is still using Netty 3, which is getting outdated
quickly and is preventing us from taking advantage of various performance
improvements in newer versions. It's also creating additional work for the
Finagle team at Twitter as we need to port important security and performance
fixes back to Netty 3.
READMORE

## Challenges

We can split the work required to make this upgrade into two main areas:

1. Replacing internal Finagle usage of Netty 3 with Netty 4.
1. Replacing usage of Netty 3 types in Finagle's public API surface.

The first area is relatively straightforward. Once the changes are implemented,
we'll use a new load test framework that Twitter is developing to verify that
there are no regressions in performance or functionality.

The second area is the really problematic one and is what makes this effort
epic. Many projects that directly depend on Finagle are affected, and some of
these expose Netty 3 types as part of their own public surface, affecting even
more projects that depend on them, and so on.

## High level plan

We are addressing these challenges by adopting a multi-stage approach.

### Part 1: Provide alternatives for APIs that contain Netty types

For parts of Finagle that have a relatively low number of affected APIs (e.g.
finagle-core) we'll add new APIs alongside the old ones, and deprecate the old
ones. As part of deprecation we'll update all internal projects at Twitter to
use the new version.

For each part that has lots of Netty 3-based APIs (e.g. finagle-http,
finagle-memcached, and finagle-kestrel), we'll add a whole new parallel package
with the suffix "x" (e.g. finagle-httpx, finagle-memcachedx). All new bug
fixing and feature additions will be done in the new packages.

Existing packages that are not widely used internally (such as finagle-redis)
will be moved out of the Finagle repository and into their own projects under
the [new Finagle organization](https://github.com/finagle) on GitHub.

### Part 2: Remove all Netty types from Finagle's public surface

Once a sufficient number of projects have been migrated, we'll remove all
deprecated APIs and packages (this will require incrementing Finagle's major
version).
  
### Part 3: Change internal implementation to use Netty 4

At this point, the Netty version used by Finagle will be an implementation
detail, and we'll do the work necessary to upgrade to Netty 4 and verify that
performance and functionality are not affected. While this upgrade will be
seamless for users of Finagle, we'll still increment the major version to
indicate that such a significant implementation detail has been changed. We
anticipate completing this process in the second quarter of 2015, although
the timeline is still subject to revision.

## Next steps

The [Finagle repository](https://github.com/twitter/finagle) on GitHub now
contains "x" versions of three Finagle packages (finagle-http,
finagle-memcached, and finagle-kestrel), and you can follow our progress there,
or even experiment with using these new packages in your own
applications—we'd love feedback about any challenges you run into. If you have
questions about this upgrade, please contact us on the [Finaglers mailing
list](https://groups.google.com/forum/#!forum/finaglers), and be sure to watch
this space for upcoming blog posts about details of the transition for
individual Finagle packages.


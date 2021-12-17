---
layout: post
title: December 2021 Release Notes - Version 21.12.0
published: true
post_author:
  display_name: Attila Szegedi
  twitter: asz
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The year-end holiday season is upon us, so Happy New Year 🎩 🥂 and enjoy our December release! 🥳

[Util](https://github.com/twitter/util/)
========================================

Breaking API Changes
--------------------

-   util-core: Activity.collect\* and Var.collect\* are now implemented in terms of known collection
    type scala.collection.Seq versus HKT CC\[X\] before. This allows for certain performance
    enhancements as well as makes it more aligned with the Future.collect APIs.
    [caf528e2](https://github.com/twitter/util/commit/caf528e2ff7a7686e4f9cc7fe95553669fa064b8)


[Scrooge](https://github.com/twitter/scrooge/)
==============================================

No Changes


[Finagle](https://github.com/twitter/finagle/)
==============================================

Deprecations
------------

-   finagle-zipkin-core: c.t.f.zipkin.core.Sampler.DefaultSampleRate is deprecated in
    favor of c.t.f.zipkin.core.DefaultSampler.sampleRate. [bd04e1c9](https://github.com/twitter/finagle/commit/bd04e1c9cef4822466d4f4e5339137d68877ebc1)

Bug Fixes
---------

-   finagle-zipkin-core: c.t.f.zipkin.core.Sampler would sample at 1/10,000
    rate when configured with a lower (but non-zero) rate. It can now sample
    at rates as low as 1/16,777,216. [17cfb580](https://github.com/twitter/finagle/commit/17cfb58044a6a3ef11211b3fba1888a588a6be96)

Runtime Behavior Changes
------------------------

-   finagle-zipkin-scribe: c.t.f.zipkin.thrift.ZipkinTracer uses
    c.t.f.zipkin.core.DefaultSampler.sampleRate as the default sample rate instead of
    deprecated c.t.f.zipkin.core.Sampler.DefaultSampleRate. This allows it to correctly
    observe user-configured overrides to the default sample rate. When a ZipkinTracer is
    constructed with default parameters and there are no user-configured overrides, the
    behavior is unchanged. [bd04e1c9](https://github.com/twitter/finagle/commit/bd04e1c9cef4822466d4f4e5339137d68877ebc1)


[Finatra](https://github.com/twitter/finatra/)
==============================================

Changed
-------

-   inject-core: Move runAfterAll hook from c.t.inject.IntegrationTestMixin to
    c.t.inject.TestMixin [fd108ada](https://github.com/twitter/finatra/commit/fd108ada07ec6803a48261407bde02bcde6fdb59)

[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

No Changes

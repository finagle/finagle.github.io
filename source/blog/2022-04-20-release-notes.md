---
layout: post
title: April 2022 Release Notes - Version 22.4.0
published: true
post_author:
  display_name: Helen Woldesenbet
  twitter: helygwb
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Spring is finally here 😎. Enjoy the lovely weather with our April release 🎉.

[Finagle](https://github.com/twitter/finagle/)
==============================================

Bug Fixes
---------

-   finagle-integration: we discovered that we had a dead code in MuxClientSession.
    Let's remove Timer as a parameter in MuxClientSession since it's a dead code.
    [77396f84](https://github.com/twitter/finagle/commit/77396f8498b3513a927ad8c30637d3afe0d230e6)

[Util](https://github.com/twitter/util/)
========================================

Breaking API Changes
--------------------

-   util-stats: The metric instantiation methods have been removed from MetricBuilder. Use the methods on
    StatsReceiver to instantiate metrics instead. [3685d725](https://github.com/twitter/util/commit/3685d7251f0fc43a6f5746ee6e562c5c91ed34a3)

[Finatra](https://github.com/twitter/finatra/)
==============================================

No Changes
----------

[Scrooge](https://github.com/twitter/scrooge/)
==============================================

No Changes
----------

[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

No Changes
----------



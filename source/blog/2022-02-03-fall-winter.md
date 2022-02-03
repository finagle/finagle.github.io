---
layout: post
title: 2021 Fall/Winter Update 🍂❄️ 
published: true
post_author:
  display_name: Joy Bestourous
  twitter: joybestou
tags: Finagle, Finatra, Util, TwitterServer
---

Happy New Year, folks! 🥳 What better way to honor the year of 2022 🎇 than with some highlights from the second half of 2021. Welcome to the CSL Half-ly Review, a summary of all great CSL things from the second half of 2021🕺🏼.

### Finagle-Postgres
Big news! Finagle-Postgres has been merged into the main Finagle repository. See the [commits starting on August 5th](https://github.com/twitter/finagle/commits/develop?after=98604c1540fa99dff00872614d58fdd3fac728ad+104&branch=develop). We’ve been busy testing it out and squashing bugs!

### Weighted-Aperture
The deterministic aperture project is picking up a new trick: direct support for weights. The aperture load balancer no longer requires separate load balancers for each weight class and can naturally manage the weights as first class properties of an endpoint. This feature is not yet the Finagle default but will be in early 2022.

### Metrics Metadata
Work continues to refine and mature the metrics metadata. Notably, we have developed Metric Expressions, an API that helps build composable, query-agnostic high level expressions. Expressions for success rate, throughput, p99 latency, deadline rejection, admission control rejection, failures, and general JVM expressions are currently instrumented and may be leveraged in your observability pipeline. Please note that this API is still experimental and under active development.

### Finagle-MySQL
[Support for `caching_sha2_password` authentication](https://github.com/twitter/finagle/commit/9a418a58e3bf3f978a53a346dcd603c993a88c1d) method is now available to improve compatibility with MySQL 8.0.

### Finatra-MySQL
Finatra-MySql client is [now available](https://github.com/twitter/finatra/commit/fd108ada07ec6803a48261407bde02bcde6fdb59) for binding a finagle-mysql client and a EmbeddedMysqlServer. Feature tests can be tested against a real MySql instance. Thank you to Ian Bennett and Kostas Pagratis!

### Scrooge API Consolidation
We [simplified scrooge types](https://github.com/twitter/scrooge/commit/8d768ca620a33d18b89492a7a2077007cedb6e7d) by consolidating the multiple incompatible names into a single API, `ServiceName.MethodPerEndpoint`. Scrooge now generates less code, resulting in faster compile times and easier development.

### Scala 3 and Util
17 out of 31 subprojects in Util are Scala 3 compatible. Thank you to our summer interns!

*More to come in the future!*

Cheers,

Joy and Bryce on behalf of CSL

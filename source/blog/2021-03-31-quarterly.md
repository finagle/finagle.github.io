---
layout: post
title: CSL Quarterly Review, Winter/Spring 2021
published: true
post_author:
  display_name: Bonnie Eisenman
  twitter: brindelle
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Daffodils are blooming, the snow is melting, spring is in the air...and it's time for another CSL update. The CSL team has been busy since our [last](https://finagle.github.io/blog/2020/06/04/winter-spring/) quarterly / semiannual / epochly bulletin!

Without further ado, here's our Q4 2020 / Q1 2021 recap:

## Shipped 🚢

### Finatra Validations Framework 
Finatra Validation now [supports](https://github.com/twitter/finatra/commit/19008194251ec1909ee6a2478ed0138bd33509e6) cascading validations on nested case classes.

### More Robust Tracing Annotations

We shipped several changes focusing on more robust tracing annotations. This should help with latency and other performance investigations. Finagle now records errors and exceptions when spans complete, high-level HTTP status info, annotations for rate-limited requests, and more information about the process path. More details in the [February](https://finagle.github.io/blog/2021/02/10/release-notes/) notes.

### #bugfix: reading Java Thrift structs with bad field types will now throw an error

We fixed a discrepancy in how Scrooge generates Scala and Java code. If Scrooge encountered a field that had a type different from the expected type in a struct, the Java-generated code would skip the field and continue reading, causing corrupt records to slip by deserialization. Yikes! That's been fixed, and now both the Java and Scala generated code will throw an exception.

### Metrics Metadata Instrumentation (with [Matt Dannenberg](https://github.com/dannenberg))

We continued instrumenting the /admin/metric_metadata.json endpoint, and it’s now ready to be used by customers.  Our first expected use cases are for fleet-wide analysis of services, and automatic configuration of Platform Layers.

### Resharding in Partition-Aware ThriftMux Clients

We added support for resharding to Partition-Aware ThriftMux clients, so that it’s now possible to reshard your cluster without downtime by using our resharding primitives. 

### Offload Filter

Finagle's Offload Filter is now faster and easier to use! Service owners can now enable the Offload Filter with a single on/off flag: -Dcom.twitter.finagle.offload.auto=true. 

How much you'll benefit depends on your service, but expect improvements to both tail latencies and redline results. Internally, for example, one of our customers running on a dedicated host observed a 30% p99 latency improvement when compared to a vanilla (no offload enabled) config. 🎉

## WIP & coming soon  🏗

### New Backoff API

Ye olde backoff API could lead to memory leaks for potentially infinite streams. We introduced a new Backoff API that works as a drop-in replacement for the old API, but without the footguns.

### Unblocking Capacity Testing for Large Services

Today, Finagle interprets serverset weights separately from its loadbalancing algorithms. This creates problems for capacity-testing large services. Capacity testing can cause a single instance to receive a sudden influx of new connections, leading to distorted results or even a total inability to run tests. We're promoting vector weights to be a first class concern of the Finagle loadbalancers to remediate this.

...and that's all for now!

Ĝis poste,
Bonnie (on behalf of CSL)

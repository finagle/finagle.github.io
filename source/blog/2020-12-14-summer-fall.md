---
layout: post
title: Summer and Fall Update 2020 🚲
published: true
post_author:
  display_name: Ryan O'Niell
  twitter: ryanoneill
tags: Finagle, Finatra, TwitterServer
---

Greetings Finaglers! 👨💻👩💻. Usually, four times a year 🗓 we send out a
comprehensive retrospective of all of the exciting  changes we’ve been making.
However, 2020 has been anything but usual. So here’s the semiannual (Or is it
biannual 🤔? Definitely not biennial 🙅♂️.) version of our quarterly review for
Q2 and Q3 2020.

#### Aperture Eager Connections (Aperture Pro)

Over the summer, eager connections with deterministic aperture (also known as
Aperture Pro) was introduced! Eager connections should help with request
latency when a service or their backend dependencies restart.


#### OffloadFilter

CSL is seeing staggering improvements with our OffloadFilter! The OffloadFilter works
by creating a separate ThreadPool to handle application and some Finagle concerns,
while keeping Netty IO threads mostly focused on the sending and receiving of bytes.
Try it out if you haven’t
already!


#### Metrics Metadata

The Metrics Metadata endpoint (/admin/metric_metadata.json) has been added for
instances of Twitter Server, is now live, and ready to be incorporated into
tooling. This endpoint lists the metrics within a service, describes their
kinds, verbosity level, relative names, client and server categories, and
whether they are SLO key indicators.


#### Partition Aware Thrift Mux Clients

Over the past ten years, Finagle has mostly focused on features for stateless
services. This has left stateful and partitioned services as undersupported,
requiring service owners to implement per-request sharding on their own. CSL
very recently finished work to support sharding and partitioning in our
ThriftMux clients.


#### Resiliency

Resiliency efforts popped back up to the top of CSL’s priority list for a portion
of this year. The team made some subtle changes for retry storm mitigation,
retry budget replenishment, improving fail fast logic, and allowing customers to set
max retries for methodbuilder. A new server stack param, MaxConnections, was also added
to limit the number of connections a server will accept.


#### Testing

Testing is the key component for teams being able to ship changes codebase as well
as roll out new features. To that end, CSL made changes in Q2/Q3 to improve both
development time and runtime testing. Testing in Finatra was speeded up significantly,
a new library for mockito-scala was introduced, and changes to the TestInjector were
made to allow for more user control.


Thank you,

Ryan (on behalf of CSL)

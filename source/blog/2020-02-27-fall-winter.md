---
layout: post
title: 🍂 Fall/Winter ❄️ 2019 Quarterly Review
published: true
post_author:
  display_name: Ian Bennett
  twitter: enbnt
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---


Hi Finaglers,



It is ⌛time to take a 👀 look back on the 🌇 twilight of the year 2019, when the seasons shift from 🍂 Fall to Winter ❄️. Across our projects, we have introduced support for JDK 11 and added support for Scala 2.13 across a large portion of our projects. A major thanks due to our OSS community [contributions](https://www.google.com/url?q=https://github.com/twitter/finagle/issues/771&sa=D&ust=1582831031993000) on continuing to drive Scala 2.13 support - we couldn’t have made such progress so quickly without your help. We have made some steady progress and improvements across all of our projects, but also want to loop you in on some of our plans looking forward to Spring 🌱.

### Finatra

We have introduced a new Case Class Validation library (finatra/validation), upgraded some dependent libraries, squashed some bugs, and moved some things around. Automatic handling of Mustache rendering has been removed from finatra/http and Mustache support has been broken into two separate libraries: finatra/mustache and finatra/http-mustache. Please realize that we try to minimize breaking API changes unless they’re absolutely necessary and we apologize for the inconvenience when upgrading. Much of the movement is to clean up inconsistencies or poor layout of existing APIs and in service to some bigger things coming.

You should expect to see improvements to the usability of our new Case Class Validation library, bug fixes and broader support for Jackson annotations within finatra-jackson, and the removal of finagle-http as a dependency within finatra-jackson as we move into Spring 🌱. We are also looking into shifting Finatra’s HTTP path DSL to be based off of the OpenAPI spec and more information will follow as those plans solidify.

We have continued to refine the APIs around c.t.util Streaming types (Reader, Writer, Pipe). We improved the performance of Reader. We have removed the deprecated response.StreamingResponse. [StreamingResponse and StreamingRequest](https://www.google.com/url?q=https://twitter.github.io/finatra/user-guide/http/streaming.html&sa=D&ust=1582831031995000) are the recommended Finatra Streaming APIs.

### Finagle

[Martijnhoekstra](https://www.google.com/url?q=https://github.com/martijnhoekstra&sa=D&ust=1582831031995000) added a [new HeaderMap](https://www.google.com/url?q=https://github.com/twitter/finagle/pull/805&sa=D&ust=1582831031995000) to the finagle-http project!We madethis implementation the [default HeaderMap implementation](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/597e78159db35eee9c5353d15243ab0d2889767d&sa=D&ust=1582831031996000), resulting in improved performance - most notably in HTTP and HTTP/2 servers.

Check out the blog post on our homemade ◎ [Deterministic Aperture Load Balancer](https://www.google.com/url?q=https://blog.twitter.com/engineering/en_us/topics/infrastructure/2019/daperture-load-balancer.html&sa=D&ust=1582831031996000) ◎!

We focused on improving Tracing support within Finagle, including adding local tracing support ([1c6d5d24](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/1c6d5d2482521b81d0ce80a823654591910381fa&sa=D&ust=1582831031997000)), annotations to DarkTrafficFilter based requests ([ba351f4d](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/ba351f4d180faa49a6f0bbd0884338605f3b9c6b&sa=D&ust=1582831031997000)), microsecond resolution timestamps in JDK9 or later ([08a926c6](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/08a926c6a10c87072adde2b9d15e367009fde129&sa=D&ust=1582831031997000)), and changes to Trace#time and Trace#timeFuture to create BinaryAnnotations with timing information ([c6d5d24](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/1c6d5d2482521b81d0ce80a823654591910381fa&sa=D&ust=1582831031997000)), along with the deprecation of Tracing#record(message, duration) ([1c6d5d24](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/1c6d5d2482521b81d0ce80a823654591910381fa&sa=D&ust=1582831031998000)).

We improved the finagle-mysql project by adding native support for the MySQL JSON Data Type([4d403051](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/4d403051b953f76c7899f3ae667d2d0a6e65b544&sa=D&ust=1582831031998000)).

The finagle-partition, finagle-exception, finagle-exp, finagle-mysql, finagle-mux, finagle-thrift, finagle-thriftmux, finagle-redis, finagle-tunable, and finagle-grpc-context projects have added Scala 2.13 [cross-build support](https://www.google.com/url?q=https://github.com/twitter/finagle/issues/771&sa=D&ust=1582831031999000). Once again, thank you to [martijnhoekstra](https://www.google.com/url?q=https://github.com/martijnhoekstra&sa=D&ust=1582831031999000), [joroKr21](https://www.google.com/url?q=https://github.com/joroKr21&sa=D&ust=1582831031999000), [DieBauer](https://www.google.com/url?q=https://github.com/DieBauer&sa=D&ust=1582831032000000), [hderms](https://www.google.com/url?q=https://github.com/hderms&sa=D&ust=1582831032000000), and [spockz](https://www.google.com/url?q=https://github.com/spockz&sa=D&ust=1582831032000000) for all of the great work!

Per-method stats creation is now lazy, thanks to changes in Scrooge client endpoint metrics ([6be5dc48](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/6be5dc48b0f7655cd06c5a8747116407cb381ccd&sa=D&ust=1582831032001000)).  This decreases the number of metrics that are created when talking to services that have many endpoints, few of which you use.  We also reduced the number of metrics we export in general, making some verbose, and removing some unnecessary ones. To demonstrate the effect: this work retires at least ~50 metrics from a bare bones Finagle application (1 client; 1 server).

We added compression negotiation support to ThriftMux. This makes it easy to roll-out compression between two services, so that service owners can make better tradeoffs between network bandwidth and CPU.  We’re still experimenting with this feature, but please reach out to csl-team@ if you would like to be involved in trying it out!

The finagle-http clients that are HTTP/2 enabled, which is toggled on by default at Twitter, now have flow control (back-pressure) support by default. This implementation is based off of Netty’s MultiplexHandler. Our legacy HTTP/2 client implementation (without flow control) has been removed. There is additional clean-up around handling of exceptions and nacks that improved the overall HTTP/2 experience.

Looking to the Spring🌱, we have our eyes set on adding partition awareness support for Thrift and ThriftMux clients. This is a tool that could be leveraged to handle load balancing across stateful shards (i.e. partitioned storage). In a similar vein, we are looking to introduce protocol-agnostic routing constructs that will be leveraged at various points (HttpMuxer, Twitter Server Admin, Finatra) and expect some deprecations of current APIs as a result. We have also been and will continue to experiment with and roll out eager connection/session establishment for users of the ◎ [Deterministic Aperture Load Balancer](https://www.google.com/url?q=https://blog.twitter.com/engineering/en_us/topics/infrastructure/2019/daperture-load-balancer.html&sa=D&ust=1582831032002000) ◎.

### Twitter Server

We changed query parameter retrieval in order to remove duplicate functionality from Twitter Server that already exists within Finagle ([b538228c](https://www.google.com/url?q=https://github.com/twitter/twitter-server/commit/b538228c4401842a76a758e038f4a2ed73e98f5d&sa=D&ust=1582831032002000)). You can also now disable the AdminHttpServer from starting ([ecef399a](https://www.google.com/url?q=https://github.com/twitter/twitter-server/commit/ecef399ad98f5386cd75c031a8a2e73d2159a575&sa=D&ust=1582831032003000)) by default on a TwitterServer.

### Util

Twitter Futures can now convert to the newer Java CompletableFuture APIs, to improve our Java friendliness, and make it easier to integrate with modern Java libraries.

We added a new c.t.f.stats.LazyStatsReceiver, which ensures that counters and histograms don’t export metrics until after they have been incremented or added to at least once. This should make it easier to create metrics that you don’t want to export unless they’re used.

We added support for `nowNanoPrecision` to c.t.u.Time to produce nanosecond resolution timestamps in JDK9 or later.

### Scrooge

We looked hard at how to improve generic processing of Thrift data.  Historically, the only first class support for data processing was if you were processing a single Thrift type, so it was challenging to write libraries that could deal with arbitrary Thrift types.  To that end, we improved ThriftStructMetaData so that it didn’t have to use reflection by default.  We also addedStructBuilder to ThriftStruct to better support copy and modify patterns.

Scrooge is also going to be a focus heading into the Spring 🌱, as we’re looking to improve the relationship and efficiency between Scrooge and Finagle. 

### Libraries Upgraded

*   JDK11 Support ([04def84b](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/04def84b797e7c3e4615e7fcd74bdae947a862c6&sa=D&ust=1582831032006000), [e6970ed](https://www.google.com/url?q=https://github.com/twitter/util/commit/e6970ed1749eefbc3d34bfe36c8ef33ba823210d&sa=D&ust=1582831032006000), [99914111](https://www.google.com/url?q=https://github.com/twitter/twitter-server/commit/99914111241fbc4b3d4efb5869f3b849b71c8f38&sa=D&ust=1582831032006000), [e7b88e84](https://www.google.com/url?q=https://github.com/twitter/scrooge/commit/e7b88e846f3bb7b0c03983e73a18a051aa48d2df&sa=D&ust=1582831032006000), [dfc521c9](https://www.google.com/url?q=https://github.com/twitter/finatra/commit/dfc521c94db28116c25bca755a20706136b1573d&sa=D&ust=1582831032007000))
*   Upgrade to jackson 2.9.10 and jackson-databind 2.9.10.1 ([e333c839](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/e333c839604021893ada0c8d03f3f51843d5a55c&sa=D&ust=1582831032007000), [14fc3714](https://www.google.com/url?q=https://github.com/twitter/finatra/commit/14fc3714e6a6239db0c392264259ddfa52cf2b79&sa=D&ust=1582831032007000), [c6e3f317](https://www.google.com/url?q=https://github.com/twitter/util/commit/c6e3f31772f1b6a8fb9abc039e446cbf0678ce89&sa=D&ust=1582831032007000), [acf7e010](https://www.google.com/url?q=https://github.com/twitter/twitter-server/commit/acf7e01034902769eb128103a613155bcfc943c3&sa=D&ust=1582831032008000))
*   finagle: Upgrade to caffeine 2.8.0 [c335b29e](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/c335b29e7632ce7165e662136beaf377bfc4e24e&sa=D&ust=1582831032008000)
*   finagle: Upgrade to Netty 4.1.43.Final and netty-tcnative 2.0.26.Final. [cfaaa471](https://www.google.com/url?q=https://github.com/twitter/finagle/commit/cfaaa471a70ca679f2596b09687b7e1835051764&sa=D&ust=1582831032008000)
*   twitter-server: Update ScalaTest to 3.0.8, and ScalaCheck to 1.14.0\. [d9b1fc04](https://www.google.com/url?q=https://github.com/twitter/twitter-server/commit/d9b1fc044a2f59abea6a1c6924c1ad25d834b083&sa=D&ust=1582831032008000)
*   finatra: Update Google Guice version to 4.1.0, update ScalaTest to 3.0.8, and ScalaCheck to 1.14.0\. [1bc3e889](https://www.google.com/url?q=https://github.com/twitter/finatra/commit/1bc3e8891750fbcf12cdfbfb0c6a2a3639ee84f3&sa=D&ust=1582831032009000)

### Closing

If all of this excites you and you’d like to work alongside us, not only do we love working with external contributors, but we are hiring! Take a look at [careers.twitter.com](https://www.google.com/url?q=https://www.google.com/url?q%3Dhttps://careers.twitter.com/en/work-for-twitter/201909/senior-software-engineer-core-systems-libraries.html%26sa%3DD%26ust%3D1582059736599000%26usg%3DAFQjCNEmYvOSf1RDN3ISMkOT32CubdfDGw&sa=D&ust=1582831032009000) and join the Flock!

Thank you all and here is to a ✨magical ✨ year ahead,

Ian on behalf of CSL

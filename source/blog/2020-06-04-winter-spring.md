---
layout: post
title: Spring Update 2020
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Salute, Finaglers 🙇‍♂️! Four times a year we send out a comprehensive overview of all these exciting changes we’ve been working behind the curtains 🎭. As you probably guessed already, this is one of those times ✨! It’s a Q1 2020 quarterly review episode!


#### ThriftMux Compression (aka t7x)
ThriftMux’s support for negotiating payload compression is out of beta and is generally available for service owners. The way this is structured is services on both ends of the wire would need to [opt-in for compression ](https://github.com/twitter/finagle/blob/develop/doc/src/sphinx/Compression.rst) in their Finagle clients & servers. 

Enabling compression can be beneficial for network-bound services that have a few CPU cycles to spare. We highly encourage you, though, to run your own tests before enabling that feature. As always, we’re curious to hear about your performance adventures so do not hesitate to reach out!

#### Finatra Java API Improvements
We discovered a few shortcomings in our Java APIs. Specifically, the lifecycle management ergonomics in the Java version of Finatra APIs [weren’t on par with the original (Scala)](https://github.com/twitter/finatra/commit/f04772df4da0d53fa27714396a6a591f80de4e53). 

#### Finatra’s New Jackson Support
We also reworked Finatra’s Jackson integration such that it’s no longer coupled with the HTTP package. As a result of this restructuring, we’re able to provide better JSON parsing/printing APIs.

#### SameSite Cookie is ON
With Chrome shifting into being more considerate of the [lack of the SameSite cookie attribute](https://blog.chromium.org/2019/10/developers-get-ready-for-new.html), we’ve switched Finagle to propagate that attribute with its server-set cookies by default.

#### Scala 2.13 Support
CSL’s libraries have always been in the front lines when it comes to supporting modern Scala versions, such as 2.13. All packages within Finagle, Util, and TwitterServer are now cross-compiled (and cross-published in the OSS) for Scala 2.13. Finatra is next.

#### Reference Counted SSL Engines
The vast majority of Finagle’s and Netty’s SSL bits are backed by native structures that require careful off-heap memory considerations for every secure connection. Netty already had support for reference-counted SSL engines but we hadn’t been utilizing them within Finagle due to a bug in Netty. That approach, while being perfectly workable, had one noticeable downside - the native memory management machinery had been bundled into regular GC cycles, occasionally slowing them down.

We [fixed](https://github.com/netty/netty/commit/031c2e2e8899d037228a492a458ccd194eb8df9c#diff-cfd417915faad637e4278b54adafd9ba) the Netty bug and partnered with the VM team to experiment with a new implementation where the created SSL engines are explicitly released after use so they don’t end up polluting the finalizer queue (CSL-8292). The results were very promising on some of our high throughput services (25% shorter CMS remark phase - part of full GC) so we enabled that by default for everyone.

#### New Finatra CaseClass Validation API
We reworked Finatra’s validation API for case classes from the ground up to fix its shortcomings and suboptimal structure. It’s now less coupled with the rest of the framework (doesn’t have to be used as part of JSON deserialization), has more features, provides better extension points, and comes with [a refined documentation](https://twitter.github.io/finatra/user-guide/validation/index.html). 

#### Scrooge-generated Code Improvements

Twitter's Michael Braun ([@mbraun88](https://twitter.com/mbraun88)) spent his Q1 hackweek improving compile times for Scrooge-generated code by simplifying output constructs. Not only is the new code about 20% faster to compile, it also potentially unlocks more JIT optimizations (i.e., inlining) at runtime.

#### Metrics Metadata
About a year ago we started partnering with Matt Dannenberg (Twitter) to work on the metrics metadata project that aims to provide both humans and computers with the additional (on top of just a pair name, value) information about exported metrics. Things like the kind of a metric (counter, gauge, histogram), unit of measure, whether it’s latched and many others can now be exported from every TwitterServer’s admin interface - hit your /admin/metrics_metadata.json endpoint to see it in action!  Right now it doesn’t have that much information, but we plan to instrument our metrics over the next couple of quarters.

#### Bumped Dependencies
- Logback 1.2.3
- Guice 4.2.0
- Joda 2.10.2

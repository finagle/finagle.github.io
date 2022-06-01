---
layout: post
title: 🌇 Upcoming module removals & migration guide🌇
published: true
post_author:
  display_name: Zhe Song
  twitter: zsong
tags: Finagle, Finatra-Kafka, Kafka-Streams
---

Twitter [processes billions of events in real time](https://blog.twitter.com/engineering/en_us/topics/infrastructure/2021/processing-billions-of-events-in-real-time-at-twitter-)  every day using a variety of technologies including Hadoop, Kafka, and of course Finagle.

In 2018, we open sourced [Finatra Kafka Streams](https://github.com/twitter/finatra/commit/47cce5462) , which we had already been using in production at Twitter for some time, and have continued to maintain it as part of Finatra core library.

Internally at Twitter, we have begun to consolidate and refactor our own Kafka client code in incompatible ways, and have moved away from using Finatra Kafka Streams.  As a result, we will be moving Finatra Kafka out of the core Finatra repository and no longer directly supporting it.

### What happens next?

The codebase of kafka libraries under finatra repo will be completely deprecated starting from our next release.

### Who will be affected?

Any services that has dependencies on libraries of finatra/kafka and finatra/kafka-streams

### What to do?

In order to minimize the potential effects on our valuable users of finatra/kafka and finatra/kafka-streams.  We published an open sourced stand-alone
[finagle/finatra-kafka](https://github.com/finagle/finatra-kafka) client library to serve as an alternative pathway.

You can complete this migration by simply changing the groupId of your dependency namespace from “com.twitter” to “com.github.finagle”.
Below are examples of changing the groupId for two artifacts:

Change the namespace of maven coordinates in your build file

* [com.twitter:finatra-kafka_2.13:22.4.0](https://search.maven.org/artifact/com.twitter/finatra-kafka_2.13/22.4.0/jar) to [com.github.finagle:finatra-kafka_2.13:22.4.0](https://search.maven.org/artifact/com.github.finagle/finatra-kafka_2.13/22.4.0/jar)
* [com.twitter:finatra-kafka-streams_2.13:22.4.0](https://search.maven.org/artifact/com.twitter/finatra-kafka-streams_2.13/22.4.0/jar)  to
  [com.github.finagle:finatra-kafka-streams_2.13:22.4.0](https://search.maven.org/artifact/com.github.finagle/finatra-kafka-streams_2.13/22.4.0/jar)

---
layout: post
title: Summer Update ☀️
published: true
post_author:
  display_name: Christopher Coco
  twitter: cacoco
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Hello Finaglers,

Summer ⛱️ is now in full-effect around the world 🌍 but we interrupt your travel 🚙and ice cream 🍦 to quickly highlight the 🆒 things released over the spring and early summer 🐚 months of April, May, and June. Just a note, if you’d like to keep up-to-date on all that is happening in a more real-time ⏰ fashion please feel free to watch ⌚ our project changelogs [[1](https://github.com/twitter/util/blob/develop/CHANGELOG.rst), [2](https://github.com/twitter/scrooge/blob/develop/CHANGELOG.rst), [3](https://github.com/twitter/finagle/blob/develop/CHANGELOG.rst), [4](https://github.com/twitter/twitter-server/blob/develop/CHANGELOG.rst), [5](https://github.com/twitter/finatra/blob/develop/CHANGELOG.rst)].

**TwitterServer**

Users of TwitterServer can now [see client connections](https://github.com/twitter/twitter-server/commit/2c233bd5cc4590c7fa91de29c02a6424ad3a70fe) to the server via the “/admin/servers/connections.json” admin page.

**Streaming**

We’ve continued rolling out Finagle streaming HTTP updates and improvements including adding more metrics for visibility including [request/response streaming durations](https://github.com/twitter/finagle/commit/916f4a2683aef99bc5e0c29bbdad0523cebb7bc1#diff-5e888bc17c6d0a91809c677e4b452c64) and a new [`StreamingStatsFilter`](https://github.com/twitter/finagle/blob/develop/finagle-http/src/main/scala/com/twitter/finagle/http/filter/StreamingStatsFilter.scala) which tracks various [request/response metrics](http://twitter.github.io/finagle/guide/Metrics.html#streaming).

**Netty Upgrade**

We also [upgraded](https://github.com/twitter/finagle/commit/9ffbf7a74e53330672e45fd58baf07b623cc8348) our Finagle Netty4 dependency to [Netty 4.1.35.Final](https://github.com/netty/netty/releases/tag/netty-4.1.35.Final).

**Finagle**

Have you wanted a way to easily shift your application work off of the I/O threads? Good news — [now you can](https://github.com/twitter/finagle/commit/40431bb43526efb7450a254e95baf52eda5dc997). By default, Finagle executes all Futures in the I/O threads minimizing context switches. Since there is typically a fixed number of I/O threads shared across a JVM process, it is very important to ensure they’re not blocked by application code and thus affecting a system's responsiveness. Shifting application-level work onto a dedicated `FuturePool` or `ExecutorService` which offloads work from the I/O threads can improve throughput in CPU-bound systems. Note, you also do this globally for your process by setting the [`com.twitter.finagle.offload.numWorkers` flag](http://twitter.github.io/finagle/guide/Flags.html#common).

Stats and retry modules use a [`ResponseClassifier`](https://twitter.github.io/finagle/guide/Clients.html#response-classification) to give hints for how to handle failure (e.g., Is this a success or is it a failure? If it's a failure, may I retry the request?). The StatsFilter increments a success counter for successes, or increments a failure counter for failures. There isn't a way to tell the stats module to just do nothing. But this is exactly what the StatsFilter should do (nothing) in the case of ignorable failures (e.g. backup request cancellations). To represent these cases, we introduce a new ResponseClass: [`Ignorable`](https://github.com/twitter/finagle/blob/develop/finagle-core/src/main/scala/com/twitter/finagle/service/ResponseClass.scala#L49).

**Finagle-MySQL SSL/TLS**

The MySQL protocol contains support for SSL/TLS via messages sent when establishing a connection. However, `finagle-mysql` did not support the sending of the messages in the correct sequence in order to properly negotiate SSL/TLS with a MySQL server. We've [updated](https://github.com/twitter/finagle/commit/0b6c20acc22267abe901c606352fb818e6345247#diff-d6f8b1cdbafc82ccae487a9b1f76478a) `finagle-mysql` to now support using SSL/TLS with MySQL which can be enabled by calling `withTransport.tls(sslClientConfiguration)` on MySQL client and specifying a `c.t.f.ssl.client.SslClientConfiguration`.

**Jackson Upgrade**

We updated several of our libraries to [Jackson 2.9.8](https://github.com/FasterXML/jackson/wiki/Jackson-Release-2.9.8) [[1](https://github.com/twitter/util/commit/8840055958ad9adcc176ff6d0e4914f1f61730eb), [2](https://github.com/twitter/finagle/commit/90d5bcbfe87809f27bb24e2c4b4f9e3490b0d519), [3](https://github.com/twitter/twitter-server/commit/66c60483e94fb5d38e66641319ed94309c54df04), [4](https://github.com/twitter/finatra/commit/0a96d2caa9339675682f34d7889c6037ab104387)].

**Finatra**

Finatra’s HTTP integration uses code from the `javax.activation` library which was deprecated in JDK 9 and fully removed in JDK 11. We’ve updated to [specify an explicit dependency](https://github.com/twitter/finatra/commit/5a7ccf312f96f410ae0d96e77ba364faa460ccd8) on the 3rd party `com.sun.activation` library as a temporary measure until we can evolve the library away from using the `javax.activation` library. This allows for using Finatra HTTP services with JDK 11 without having to specify any additional dependencies.

Additionally, we’ve made several changes to make testing more flexible. You can now [specify values for global flags](https://github.com/twitter/finatra/commit/38a3180a5d61d12fb1546dd572f075cfd2fb3dbf) when creating an `EmbeddedTwitterServer`. This allows users to write tests which will not trample over each other since global flags are typically only read once on JVM startup.

We’ve also updated the Finatra `EmbeddedTwitterServer` to allow users to [bring their own](https://github.com/twitter/finatra/commit/7a486fd28b3126ecb62ec209c51dd06721b24d5a) `StatsReceiver` implementation. In testing with the `EmbeddedTwitterServer`, Finatra bound an `InMemoryStatsReceiver` instance to the object graph for any injectable `TwitterServer`. However this prevented users from being able to use and test against their own `StatsReceiver` implementation.

<hr/>

Thanks for following along. If you’d like to know more about any one of these updates, or if you have a question about them, join us on the [Finagle](https://groups.google.com/forum/#!forum/finaglers) or [Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists or hop on [Gitter](https://gitter.im/twitter/finagle).

Enjoy! 🕶️

Christopher and the Core Systems Libraries team
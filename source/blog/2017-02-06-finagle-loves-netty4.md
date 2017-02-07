---
layout: post
title: Netty 4 support in Finagle
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Finagle, Netty4
---

It's been quite a while since the [Netty 4 migration in Finagle][netty4-blog-post] was initially
announced. We've travelled a long way and are happy to announce that there is now (as of
[Finagle 6.42][6.42]) support for Netty 4 transports in most of the protocols: Thrift, ThriftMux,
Memcached, MySQL, Kestrel, and Redis. Both HTTP/1.1 and HTTP/2 are coming soon!

## How to enable Netty 4?

While we have not yet defaulted to Netty 4, we've been running it in production for several months
and have gained enough confidence to publicize the availability of the alternative transports in
Finagle.

We encourage Finagle users to try out the new Netty 4 transports for their protocols and jump on the
fast track to upcoming changes around resiliency (think of HTTP/2) and performance (think of a
reduced allocation profile and better threading model in Netty 4).

To switch the transport over to Netty 4 supply the following command line flag:

```
-Dcom.twitter.finagle.toggle.flag.overrides=com.twitter.$protocol.UseNetty4=1.0
```

Where `$protocol` is one of the following: `mux` (use this for ThriftMux), `thrift`, `mysql`,
`memcached`, `kestrel`.

This command line flag overrides [a feature toggle][toggles] that is evaluated at application
startup and is *global for all clients/servers running on the same JVM instance*.

Note that Netty 4 is already enabled by default in `finagle-redis` so no need for an extra CLI flag.

## What about HTTP/1.1?

HTTP/1.1 on Netty 4 is still a work in progress. There are known limitations for HTTP clients, but
we've been successfully running `finagle-http` servers with Netty 4 in production for several weeks
and on [TwitterServer][ts]'s admin interface for several months.

We feel confident in HTTP/1.1 servers running Netty 4 and encourage you to migrate now using the
toggle override. Please note that this will also switch HTTP clients running in the same JVM
process over to Netty 4, which we do not recommend at this point.

```
-Dcom.twitter.finagle.toggle.flag.overrides=com.twitter.http.UseNetty4=1.0
```

## What about HTTP/2?

HTTP/2 (i.e., `finagle-http2`) should be considered beta as there are known issues with the ALPN
support. We're hoping to roll out a feature-complete HTTP/2 implementation in the next couple of
months. In the meantime, HTTP/2 support can be experimentally enabled on any Finagle HTTP client
or server as shown below.

```scala
import com.twitter.finagle.Http

val client = Http.client
  .configured(Http.Http2)
  .newService("www.example.com:80")
```

## What's next?

We're quite optimistic about enabling Netty 4 by default in the next couple of months. Even though
we're not there yet, we feel very proud of the work we've done and the progress we've made. It took
us several years of engineering effort to be able to start serving Netty 4 traffic in production.

## Where to report problems?

Please file a [Github issue][github] if anything doesn't look right when Netty 4 is enabled.

[netty4-blog-post]: http://finagle.github.io/blog/2014/10/20/upgrading-finagle-to-netty-4/
[6.42]: https://github.com/twitter/finagle/releases/tag/finagle-6.42.0
[toggles]: https://twitter.github.io/finagle/guide/Configuration.html#feature-toggles
[github]: https://github.com/twitter/finagle/issues
[ts]: https://github.com/twitter/twitter-server

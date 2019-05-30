---
layout: post
title: Spring Update 🚲
published: true
post_author:
  display_name: Moses Nakamura
  twitter: mnnakamura
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Hey Finaglers,

Spring has sprung, and we’re beginning to ease into summer.  🚲season has begun
in New York City!  We’ve been busy little bees, and this review comes a little
bit late, so it won’t include all of the work we’ve done since the last review,
but instead just has the work from January, February, and March.  For a sneak
peak on what will be in our next quarterly review, you can check out our
changelogs!

**HTTP**

We’ve added support for trailing headers to our HTTP implementation.  Although
trailers were once considered fringe, especially since no browser supports
trailers, and vanishingly few CDNs or webservers do, trailers have in the last
few years gained significant transaction because gRPC uses them for signaling
stream errors.  Trailers are an important piece in the puzzle in making
finagle-http compatible with remote peers that speak the gRPC protocol.

Header validation support was reworked in Finagle, so that they are now totally
RFC-7230-compliant.  This will give us higher confidence that we are writing
spec-compliant HTTP clients and servers.

**Runtime**

ConstFuture performance has significantly improved, which is important given how
often we use futures that are already satisfied.  In particular, we have made
`Future#map` and `Future#flatMap` substantially faster.

Composed Filter performance is much faster now that we’ve optimized the way that
error handling works.

We are also proud to announce we have enabled client-side nack admission control
to shed load automatically in overload scenarios.  This work was largely
inspired by the client-side throttling section of the [overload
chapter](https://landing.google.com/sre/sre-book/chapters/handling-overload/) in
the Google SRE book.

Rewrote streaming parsing of JSON in Finatra to rely on Jackson’s asynchronous
parsing.  This gets us out of the JSON parsing business, so that we can focus
more on our other business.

**Developer Experience**

com.twitter.io.Reader has many much-needed utilities, including Reader#flatten
and Reader.fromSeq.  We think that Reader is now broadly appropriate for object
streaming, and encourage users to consider it for their future streaming needs.

Added the “dtab.add” flag to TwitterServer and Finatra, so that if there are any
dtabs you want to add to your server, you can specify them as command line
arguments when you start your server.

Continued the flurry of tracing improvements, including adding annotations for
backup requests, and for garbage collection events.  We also added tracing
annotations for serde in scrooge, and added the rpc method name as an annotation
to scrooge spans.

**OpenCensus / gRPC Compatibility**

We partnered with another team inside of Twitter to bring their work in making
Finagle compatible with OpenCensus and gRPC to Finagle.  This has resulted in
adding support for gRPC contexts in `finagle-grpc-context`, OpenCensus tracing
in `finagle-opencensus-tracing`, and zPages exporting support in TwitterServer’s
`opencensus` module, which now provides a ZPagesAdminRoutes mixin.

**Technical Debt**

We finally no longer depend on Netty 3 in any of Finagle!  It has been a five
year(!) journey to get here, and we are extremely pleased to have finally
arrived.  And now we can’t wait until Netty 5 gets released, so that we can
start the next migration!

Completely deleted util-collection, which may be sad for long-time
util-collection users, but lets them move to the just as good (or better!) tools
provided by the JDK.

Renamed all public “blacklist” and “whitelist” identifiers to instead be called
“denylist” and “allowlist” (or “acceptlist”), which helps move our libraries
into the 21st century.

Thanks for following along. If you'd like to know more about any one of these
updates, or if you have a question about them, join us on the
[Finagle](https://groups.google.com/forum/#!forum/finaglers) or
[Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists
or hop on [Gitter](https://gitter.im/twitter/finagle).

Stay cool,

Moses and the Core Systems Libraries team

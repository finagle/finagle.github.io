---
layout: post
title: Finagle 6.43 Release Notes
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

The March releases are hot off the printing press for [Finagle 6.43.0][finagle], [Finatra 2.9.0][finatra], [Scrooge 4.15.0][scrooge], [TwitterServer 1.28.0][twitterserver], and [Util 6.42.0][util].

Here’s a few of the highlights:

### Finatra ###
See [accompanying blog post][finatra_blog_post] for details.

### Finagle ###

* finagle-http now classifies server error status codes (500s) as failures. This affects success rate metrics and failure accrual. See the `com.twitter.finagle.http.serverErrorsAsFailuresV2` [toggle][toggles] for opting out of this behavior. [f34a7344](https://github.com/twitter/finagle/commit/f34a73443679ac4fe76bc011bfb36a5b1abe9e5e)
* The finagle-http APIs continue their trek to rid themselves of having Netty 3 in its public API.
* finagle-http now has experimental http/2 support. To try it out, pass the command line parameter `-com.twitter.finagle.toggle.flag.overrides=com.twitter.finagle.http.UseHttp2=1.0`. Please let us know of any issues that you run into!

### Scrooge ###

* The Scala code generator now supports annotations on enums, enum fields, services, and service functions. [4821b46e](https://github.com/twitter/scrooge/commit/4821b46eec45f8235ed15f196c2649cee5715323)
* Scala's types for ServiceIfaces are now a `Service` from `ThriftMethod.Args` to `ThriftMethod.SuccessType`, instead of `ThriftMethod.Args` to `ThriftMethod.Result`. This is a breaking API change though it should generally be easy to adapt existing code to it. [c5ea8515](https://github.com/twitter/scrooge/commit/c5ea851546ba215b457fcf09b90e9f1857e954c3)

### Util ###
Our byte-level abstraction, `Buf` got a fresh coat of paint:

* Introduce `Buf.process` for sequential processing of a `Buf`. Finagle has been updated to use it where appropriate, leading to reductions in allocations. [1df3646f](https://github.com/twitter/util/commit/1df3646ffe420256516167591562f85c79498ec5) and others
* Introduce `Buf.write(java.nio.ByteBuffer)` for writing to NIO `ByteBuffers`. [d6f7985e](https://github.com/twitter/util/commit/d6f7985e2014cc8c3dab71417a450900cd769f5d)
* `Buf.concat` is now a constant time operation. [bb05f425](https://github.com/twitter/util/commit/bb05f425c6b12d1b2fe9f1a75658aba175fc51f8)
* `ConcatBuf` has been removed, replaced by `Buf.apply` and `Buf.Composite`. [5833c560](https://github.com/twitter/util/commit/5833c5609b8ad72cd542e34d9d6edecd143e3bad)

### Dependencies ###
Guava has been upgraded to version 19.0 from 16.0.1 [d6bdecc9](https://github.com/twitter/util/commit/d6bdecc9269c34e477b1ce1a6e8f5d22a106e2f9)

### Changelogs ###

* [Finagle 6.43.0][finagle]
* [Util 6.42.0][util]
* [Scrooge 4.15.0][scrooge]
* [TwitterServer 1.28.0][twitterserver]
* [Finatra 2.9.0][finatra]

[finagle]: https://github.com/twitter/finagle/blob/finagle-6.43.0/CHANGES
[util]: https://github.com/twitter/util/blob/util-6.42.0/CHANGES
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-4.15.0/CHANGES
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-1.28.0/CHANGES
[finatra]: https://github.com/twitter/finatra/blob/finatra-2.9.0/CHANGELOG.md
[finatra_blog_post]: https://twitter.github.io/finatra/blog/2017/03/13/announcing-the-release-of-finatra-2-dot-9-0/
[toggles]: http://twitter.github.io/finagle/guide/Configuration.html#feature-toggles


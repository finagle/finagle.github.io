---
layout: post
title: Guava-less
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Dependency, Finagle, Finatra, Util
---

We have been minimizing our dependency on [Guava][guava], which is big
and often causes version conflicts for our users. This work will be
released as part of January's 18.1 release, though there are 2 places
it remains:

* `util-cache-guava` has a `CacheBuilder`-based implementation of
`FutureCache`.  We advise replacing this usage with a
[Caffeine][caffeine] `FutureCache` available in
[util-cache][caffeine-future-cache]. The migration is well documented
in the Caffeine [user guide][caffeine-migration].

* Finatra's `http` module has a few public APIs that use
`com.google.common.net.MediaType`.  We aren't planning to address this
in the immediate future, but it's something we'd love to tackle given
more time.

Thanks for following along. Please feel free to ask questions on the
[mailing
list](https://groups.google.com/forum/#!forum/finaglers) about
anything that is unclear and we’ll help clarify if you would like to
know more.

Kevin Oliver and the Core Systems Libraries team

[guava]: https://github.com/google/guava
[caffeine]: https://github.com/ben-manes/caffeine
[caffeine-future-cache]: https://github.com/twitter/util/blob/develop/util-cache/src/main/scala/com/twitter/cache/caffeine/CaffeineCache.scala
[caffeine-migration]: https://github.com/ben-manes/caffeine/wiki/Guava
---
layout: post
title: Finagle 6.34 Release Notes
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Util, Ostrich, Scrooge, TwitterServer
---

This release we've been focusing on improving both overall stability of Finagle components and
debugging features. We also reverted a patch that cased [duplicate tag error][tagerr] that looks as
follows.

```
com.twitter.finagle.mux.ServerError: Duplicate tag 6
```

With that said, we highly recommend upgrading from 6.33 to 6.34.

### Highlights

* Finagle now includes downstream/upstream addresses in its exceptions (see [dfb9d4fa][dfb9d4fa])
* [Response classifiers][repreq] are now enabled for HTTP servers (see [c6f1b9b8][c6f1b9b8])
* Two new histograms `request_payload_bytes` and `response_payload_bytes` are now reported for
  HTTP, Mux, Thrift, and ThriftMux protocols (see [a0d9b697][a0d9b697])
* A number of deprecated methods were removed from the Finagle API (see [eeb54869][eeb54869])
* Stack overflow bug was fixed in `AsyncStream.concat` (see [5a039780][5a039780])

### Further Plans

We're actively working on migrating Finagle to Netty 4 (`finagle-core` is mostly done,
`finagle-http` is our next target) and as part of this work we're planing to completely
replace [codecs][codecs], which are pretty tied to Netty 3, with [stacks][stacks]. While this is
a pretty wide internal change, it should not affect Finagle users.

### Changelog

* [Finagle 6.34][finagle]
* [Util 6.33][util]
* [Scrooge 4.6][scrooge]
* [TwitterServer 1.19][ts]
* [Ostrich 9.17][ostrich]

### Contributors

We deeply thank our awesome contributors who helped to make this release happen. According to
`git shortlog -sn --no-merges finagle-6.33.0..finagle-6.34.0`, 18 people contributed to this release:
Kevin Oliver, Daniel Schobel, Eugene Ma, Vladimir Kostyukov, Ruben Oanta, Christopher Coco, Jillian
Crossley, Eitan Adler, Ryan Greenberg, Stu Hood, Antoine Tollenaere, Yoshimasa Niwa, Bing Wei, Edward
Samson, Liam Stewart, Lucas Langer, Miguel Cervera, Moses Nakamura, Peter Schuller.

[dfb9d4fa]: https://github.com/twitter/finagle/commit/6716980a5f313cdc4488c578ea3a642cdfb9d4fa 
[c6f1b9b8]: https://github.com/twitter/finagle/commit/28c03353024a2372513657030ba1c940c6f1b9b8
[a0d9b697]: https://github.com/twitter/finagle/commit/35e466ff35a1630c17aba6ee1fbd593aa0d9b697
[eeb54869]: https://github.com/twitter/finagle/commit/6b230c7032efe4ac1f07118da19bb1d8eeb54869
[5a039780]: https://github.com/twitter/util/commit/dedad7027db8ea88c513b4c428b0dcdc5a039780
[codecs]: https://github.com/twitter/finagle/blob/develop/finagle-core/src/main/scala/com/twitter/finagle/Codec.scala
[stacks]: https://github.com/twitter/finagle/blob/develop/finagle-core/src/main/scala/com/twitter/finagle/Stack.scala
[tagerr]: https://groups.google.com/forum/#!topic/finaglers/tJUtxoaDGx8
[repreq]: http://twitter.github.io/finagle/guide/Servers.html#response-classification
[finagle]: https://github.com/twitter/finagle/releases/tag/finagle-6.34.0
[util]: https://github.com/twitter/util/releases/tag/util-6.33.0
[ts]: https://github.com/twitter/twitter-server/releases/tag/twitter-server-1.19.0
[scrooge]: https://github.com/twitter/scrooge/releases/tag/scrooge-4.6.0
[ostrich]: https://github.com/twitter/ostrich/releases/tag/ostrich-9.17.0
---
layout: post
title: Winter Update ❄️
published: true
post_author:
  display_name: Dave Rusek
  twitter: davidjrusek
tags: Finagle, Finatra, Util, Scrooge, TwitterServer
---

Winter is in full swing, a new year is upon us, and the [coyotes](https://twitter.com/davidjrusek/status/1083452863739777024?s=20)
are still doing their thing, and so are all of us here at Twitter. As part of your
new year resolutions please make it a point to check out the
[latest](https://github.com/twitter/finagle/releases/latest)
releases of our open source offerings.

**Developer experience**

- Reader, Writer and AsyncStream continue to make progress towards general use streaming use cases. Reader recently gained map and flatMap methods ([1](https://github.com/twitter/util/commit/ac15ad8bbd633aa5efd5e306d2dea2c40a50379e#diff-aee5b3c34d1f74bb32a0e4502ed6a988))
- Finagle MySQL gained the ability to pin successive operations to a single session, enabling use cases where connection state is important for correctness.([1](https://github.com/twitter/finagle/commit/87b3b781d0ba601d1fd91293741fc264264671f8#diff-d6f8b1cdbafc82ccae487a9b1f76478a))
- Improved Java Compatibility (
[1](https://github.com/twitter/finatra/commit/ba224757fba609bbf786ab42d9f3cb8eb81f80e9),
[2](https://github.com/twitter/finatra/commit/f6c44cab87d1f9023e6028b76c61ce1920710a7b),
[3](https://github.com/twitter/finagle/commit/e57d2a9156d72ada8a81a590714ece676e423ce6),
[4](https://github.com/twitter/finagle/commit/30a8000c4a910134219fc1317cead9735ca97cbb),
[5](https://github.com/twitter/finagle/commit/cff9aeddc0ae6ceb4c50cb8d67b3418a133d30f9))

**Netty**

- In the works for a while, we all but removed the last vestiges of Netty 3 with the use of Netty 4 cookies.
- Upgraded to 4.1.31.Final ([1](https://github.com/twitter/finagle/commit/8e0f4b868c34259350fb0def2e7fee5d3d77fece))

**Finatra**

- Per-method filtering and access to ThriftMux headers are now available in Finatra by switching to a new way of constructing Controllers. Also, Finatra Thrift services now use TypeAgnostic filters instead of the custom ThriftFilters ([1](https://github.com/twitter/finatra/commit/9d891cd1f6f907c59ad9f40a7db20c4a2b33faf1))

Thanks for following along. If you'd like to know more about any one of these
updates, or if you have a question about them, join us on the
[Finagle](https://groups.google.com/forum/#!forum/finaglers) or
[Finatra](https://groups.google.com/forum/#!forum/finatra-users) mailing lists
or hop on [Gitter](https://gitter.im/twitter/finagle).


Catch you on the next release,

Dave and the Core Systems Libraries team


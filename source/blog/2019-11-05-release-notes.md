---
layout: post
title: November 2019 Release Notes - Version 19.11.0 ❄️
published: true
post_author:
  display_name: Dave Rusek
  twitter: davidjrusek
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Now that Halloween has come and gone, it's time to get ready for cold weather fun! ❄️

### [Finagle](https://github.com/twitter/finagle/) ###

#### New Features

-   finagle-base-http: The Uri class now provides access publicly to its
    path, which is the request uri without the query parameters.
    [f40fe447](https://github.com/twitter/finagle/commit/f40fe447494c81524900941c7311c697d575698c)
-   finagle-mysql: Adding native support to finagle-mysql for MySQL JSON Data Type. A client
    can now use jsonAsObjectOrNull\[T\] or getJsonAsObject\[T\] APIs on c.t.f.mysql.Row to
    read the underlying json value as type T or use jsonBytesOrNull API to get a raw byte
    array of the the json column value. [4d403051](https://github.com/twitter/finagle/commit/4d403051b953f76c7899f3ae667d2d0a6e65b544)
-   MySQL integration tests can now run on a port other than the default (3306). Add a port
    property to .finagle-mysql/integration-test.properties to customize the value.
    [4d403051](https://github.com/twitter/finagle/commit/4d403051b953f76c7899f3ae667d2d0a6e65b544)

#### Runtime Behavior Changes

-   finagle: Upgrade to Netty 4.1.43.Final and netty-tcnative 2.0.26.Final. [cfaaa471](https://github.com/twitter/finagle/commit/cfaaa471a70ca679f2596b09687b7e1835051764)
-   finagle: Add initial support for JDK 11 compatibility. [04def84b](https://github.com/twitter/finagle/commit/04def84b797e7c3e4615e7fcd74bdae947a862c6)
-   finagle: Upgrade to caffeine 2.8.0 [c335b29e](https://github.com/twitter/finagle/commit/c335b29e7632ce7165e662136beaf377bfc4e24e)
-   finagle-http2: Nacks in the form of RST(STREAM\_REFUSED | ENHANCE\_YOUR\_CALM) no
    longer surface as a RstException, instead opting for a generic Failure to be
    symmetric with the HTTP/1.x nack behavior. [cb67fa33](https://github.com/twitter/finagle/commit/cb67fa33c4b3a482e1545405af444ecbfdc1b3fd)
-   finagle-mux: The mux handshake latency stat has be changed to Debug
    verbosity. [0eb2cfb6](https://github.com/twitter/finagle/commit/0eb2cfb680203024e99118d2a87e9d0b762e6094)
-   finagle-serversets: finagle/serverset2/stabilizer/notify\_ms histogram has been downgraded to
    debug verbosity. [30d3d0ea](https://github.com/twitter/finagle/commit/30d3d0ea432dd20821c0e1d17f6fbc0c92dadae9)

#### Breaking API Changes

-   finagle-base-http: c.t.f.http.codec.HttpContext moved into c.t.f.http.codec.context.HttpContext
    [cc29b265](https://github.com/twitter/finagle/commit/cc29b26502f5d47225425d0aa8df3e64c4eb07d2)

### [Finatra](https://github.com/twitter/finatra/) ###

#### Fixed

-   finatra-http: Better handling of URI decoding issues when extracting path parameters for
    routing. If we cannot extract a path pattern, and the exception is not intercepted by a
    user-defined Exception Mapper, we will now explicitly return a 400 - BAD REQUEST.
    Fixes \#507. [5f293844](https://github.com/twitter/finatra/commit/5f293844bb8aa8cc638f869bf739878e3de372d5)

#### Added

-   finatra: Add initial support for JDK 11 compatibility. [dfc521c9](https://github.com/twitter/finatra/commit/dfc521c94db28116c25bca755a20706136b1573d)
-   inject-core: Add support for optional binding in c.t.inject.TwitterModule.
    [285da3bb](https://github.com/twitter/finatra/commit/285da3bbc2d41969eed6678c11d54e9cecdec57e)

#### Changed

-   finatra-http: (BREAKING API CHANGE) AsyncStream\[Buf\] =&gt; AsyncStream\[String\] and
    Reader\[Buf\] =&gt; Reader\[String\] handlers will always be tread the output as a JSON arrays of
    Strings. Whereas, before, the incoming bytes would have been converted to String and
    returned as-is. [43eaa555](https://github.com/twitter/finatra/commit/43eaa555fd8ef591ae1c0a387adadc3d268c9150)
-   finatra: Deprecate c.t.finatra.http.modules.DocRootModule. Introduce FileResolverModule.
    The DocRootModule defines configuration flags for the FileResolver which was moved from
    finatra/http to a more correctly generic location in finatra/utils. However, configuration for
    injection of a properly configured FileResolver is still incorrectly tied to HTTP because of the
    DocRootModule. Thus, we deprecate the DocRootModule and introduce the
    c.t.finatra.modules.FileResolverModule which is defined closer to the
    c.t.finatra.utils.FileResolver in finatra/utils. This allows the FileResolver to be properly
    configured outside of HTTP concerns. [5a97b2aa](https://github.com/twitter/finatra/commit/5a97b2aac847a374671825986d5c69e6f3740ccf)
-   finatra-thrift: Updated BUILD files for Pants 1:1:1 layout. [c46209fd](https://github.com/twitter/finatra/commit/c46209fd440ab6e1fecb8f156c6accf1e1cdd69f)
-   inject-ports: Add finatra/inject/inject-ports which has c.t.inject.server.Ports and
    c.t.inject.server.PortUtils. [5676d038](https://github.com/twitter/finatra/commit/5676d0387353c6e30a2bc3b4d13f1c2a42e33e69)
-   inject-utils: Move AnnotationUtils to c.t.inject.utils.AnnotationUtils and make public
    for use. [0ac7af99](https://github.com/twitter/finatra/commit/0ac7af99976c243f12721f5739c5a2346cd7b2e4)
-   finatra-http: Updated package structure for Pants 1:1:1 layout. Moved META-INF/mime.types file
    to finatra/utils which is where the FileResolver is located for proper resolution of mime types
    from file extension. [57555f80](https://github.com/twitter/finatra/commit/57555f8015876d8acc10b5d04b4070b39d51d395)

### [Util](https://github.com/twitter/util/) ###

#### New Features

-   util: Add initial support for JDK 11 compatibility. [e6970ed1](https://github.com/twitter/util/commit/e6970ed1749eefbc3d34bfe36c8ef33ba823210d)

-   util-core: Created public method Closable.stopCollectClosablesThread that stops CollectClosables
    thread. [a8260998](https://github.com/twitter/util/commit/a8260998518a9efc32ece0c5114694674c63072c)

-   util-core: Introduced Reader.fromIterator to create a Reader from an iterator. It is not
    recommended to call iterator.next() after creating a Reader from it. Doing so will affect the
    behavior of Reader.read() because it will skip the value returned from iterator.next.
    [d1b42f4b](https://github.com/twitter/util/commit/d1b42f4bc8ee281d33ef4a52e2d5295ad410250c)

#### Runtime Behavior Changes

-   util: Upgrade to caffeine 2.8.0 [f35ae591](https://github.com/twitter/util/commit/f35ae591930e2c37a965e66f707bb704f41070d1)

#### Breaking API Changes

-   util-core: Add c.t.io.BufReader.readAll to consume a Reader\[Buf\] and concat values to a Buf.
    Replace c.t.io.Reader.readAll with Reader.readAllItems, the new API consumes a generic Reader\[T\],
    and return a Seq of items. [a47a219b](https://github.com/twitter/util/commit/a47a219b618e2dac2135acf5ee629d25fafe480d)
-   util-core: Moved c.t.io.Reader.chunked to c.t.io.BufReader.chunked, and Reader.framed to
    BufReader.framed. [459038f9](https://github.com/twitter/util/commit/459038f9533a5c38c6e1f4359aee1227ad772170)
-   util-core: Moved c.t.io.Reader.copy to c.t.io.Pipe.copy, and Reader.copyMany to
    Pipe.copyMany. [5562ebf3](https://github.com/twitter/util/commit/5562ebf36a728bef09e6a9104c49c41526538fa2)

#### Deprecations

-   util-core: Mark c.t.io.BufReaders, c.t.io.Bufs, c.t.io.Readers, and c.t.io.Writers as
    Deprecated. These classes will no longer be needed, and will be removed, after 2.11 support is
    dropped. [844fe24d](https://github.com/twitter/util/commit/844fe24d0e190baaa976971221c88d8b4b7f9ad5)
-   util-stats: Removed deprecated methods stat0 and counter0 from StatsReceiver. [5119e65c](https://github.com/twitter/util/commit/5119e65c5c947893b15a70b0af05b22b910fc3de)

### [Twitter Server](https://github.com/twitter/twitter-server/) ###

-   Add initial support for JDK 11 compatibility. [99914111](https://github.com/twitter/twitter-server/commit/99914111241fbc4b3d4efb5869f3b849b71c8f38)
-   The endpoints section of the clients page has been fixed
    to no longer render an incorrect html line break tag. [4463e9d5](https://github.com/twitter/twitter-server/commit/4463e9d57f94bc73e67003d1bb9e28e376296557)

### [Scrooge](https://github.com/twitter/scrooge/) ###

-   scrooge: Add initial support for JDK 11 compatibility. [e7b88e84](https://github.com/twitter/scrooge/commit/e7b88e846f3bb7b0c03983e73a18a051aa48d2df)



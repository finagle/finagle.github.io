---
layout: post
title: 🌷 March 2021 Release Notes - Version 21.3.0
published: true
post_author:
  display_name: Ian Bennett
  twitter: enbnt
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

Depends on which part of this planet you are in, you may grab a hot drink or bask in the sunshine. Here is our short and sweet February release.

### NOTE

As we noted in the 21.2.0 release, we cross-build for Scala 2.12 and Scala 2.13 for all of our projects and we have dropped support for Scala 2.11
with this release. For Finatra users, please pay special attention to the notes, as the `finatra/http` project has been renamed to `finatra/http-server`,
`finatra/httpclient` has been moved to `finatra/http-client` for consistency, and artifacts that are meant to be shared between the server and 
experimental `finatra/http-client` have moved to `finatra/http-core`.

### [Finagle](https://github.com/twitter/finagle/) ###

New Features
------------

-   finagle-core: Added value ForceWithDtab to flag
    -com.twitter.finagle.loadbalancer.exp.apertureEagerConnections that forces the
    aperture load balancer to eagerly connect, even in staging environments where
    Dtab locals are set. [9dab522d](https://github.com/twitter/finagle/commit/9dab522df6c953872d19089f8756904d076aaf77)
-   finagle-core: Introduce a new Backoff to create backoffs based on varies strategies, where
    backoffs are calculated on the fly, instead of being created once and memoized in a Stream.
    Also introduced Backoff.fromStream(Stream) and Backoff.toStream to help with migration to
    the new API. [91d24c33](https://github.com/twitter/finagle/commit/91d24c33bd7587dad9a3d5e00702d1fbffaa56f3)
-   finagle-netty4: Upgrade to Netty 4.1.59.Final and TcNative 2.0.35.Final. [ee6ced91](https://github.com/twitter/finagle/commit/ee6ced9153649cf99159614de962a2f3ba0811fa)
-   finagle-http: Integrate Kerberos authentication filter to finagle http client and server.
    [e3bfa0c3](https://github.com/twitter/finagle/commit/e3bfa0c33bb5712d6eb679062efa1619fbeba8fc) [eefc21c8](https://github.com/twitter/finagle/commit/eefc21c87026d8a641987b7bd332a03ec3c06d7b)
-   finagle-core: Provided c.t.f.ssl.TrustCredentials.X509Certificates to enable directly
    passing X509Certificate instead of passing a File. [61c2a596](https://github.com/twitter/finagle/commit/61c2a59642c9ccab682d91abe7e274824c6dddf9)

Breaking API Changes
--------------------

-   finagle: Builds are now only supported for Scala 2.12+ [8a48eab7](https://github.com/twitter/finagle/commit/8a48eab7e55084559651f8c3e66e657f39709d3e)
-   finagle-core: Changed flag -com.twitter.finagle.loadbalancer.exp.apertureEagerConnections"
    from having Boolean values true or false to EagerConnectionsType\` values Enable,
    Disable, and ForceWithDtab. [9dab522d](https://github.com/twitter/finagle/commit/9dab522df6c953872d19089f8756904d076aaf77)
-   finagle-mysql: The constructor of c.t.f.mysql.transport.MysqlBufReader now takes an underlying
    c.t.io.ByteReader. Prior uses of the constructor, which took a c.t.io.Buf, should migrate to
    using c.t.f.mysql.transport.MysqlBufReader.apply instead. [ad73f92d](https://github.com/twitter/finagle/commit/ad73f92d88dd482f6198044fd5b98044b446f82d)
-   finagle-base-http: Kerberos jaas config KerberosConfiguration is replaced with ServerKerberosConfiguration
    and ClientKerberosConfiguration concrete classes.

Runtime Behavior Changes
------------------------

-   finagle: Revert to scala version 2.12.12 due to <https://github.com/scoverage/sbt-scoverage/issues/319>
    [c2db97c2](https://github.com/twitter/finagle/commit/c2db97c2b84b8ab54c1b23b4d8304b98a77728fa)
-   finagle: Bump scala version to 2.12.13 [b8e4e0ac](https://github.com/twitter/finagle/commit/b8e4e0acc896adc4a426beaf98b41d29edbb9b16)
-   finagle-core: Move helper tracing methods like traceLocal in Trace into the Tracing class. This
    allows cheaper use of these APIs by first capturing a Trace via Trace\#apply, avoiding the extra lookups
    that will add overhead on the request path. [ec0097cd](https://github.com/twitter/finagle/commit/ec0097cd17e46e192d7e80444cdda1fcb0961407).
-   finagle-core: c.t.finagle.InetResolver, c.t.finagle.builder.ClientBuilder,
    c.t.finagle.liveness.FailureAccrualFactory, c.t.finagle.liveness.FailureAccrualPolicy,
    c.t.finagle.param.ClientParams, c.t.finagle.param.SessionQualificationParams,
    c.t.finagle.service.FailFastFactory, c.t.finagle.service.RequeueFilter,
    c.t.finagle.service.Retries, c.t.finagle.service.RetryFilter, and
    c.t.finagle.service.RetryPolicy will accept the new c.t.finagle.service.Backoff to create
    backoffs. Services can convert a Stream to/from a Backoff with Backoff.fromStream(Stream)
    and Backoff.toStream. [91d24c33](https://github.com/twitter/finagle/commit/91d24c33bd7587dad9a3d5e00702d1fbffaa56f3)
-   finagle-core: remove the com.twitter.finagle.loadbalancer.apertureEagerConnections Toggle and
    change the default behavior to enable eager connections for c.t.f.loadbalancer.ApertureLeastLoaded
    and c.t.f.loadbalancer.AperturePeakEwma load balancers. The state of the
    com.twitter.finagle.loadbalancer.apertureEagerConnections GlobalFlag now also defaults to enable
    this feature (Enable. You can disable this feature for all clients via setting the
    com.twitter.finagle.loadbalancer.apertureEagerConnections GlobalFlag to Disable for your process.
    (i.e. -com.twitter.finagle.loadbalancer.apertureEagerConnections=Disable).
    [ef8d536e](https://github.com/twitter/finagle/commit/ef8d536e4e781cf953545a419b4da1797430ba0d)

Deprecations
------------

-   finagle-core: Backoff.fromJava is marked as deprecated, since the new Backoff is java-friendly.
    For services using Stream.iterator on the old Backoff, please use the new API
    Backoff.toJavaIterator to acquire a java-friendly iterator. [91d24c33](https://github.com/twitter/finagle/commit/91d24c33bd7587dad9a3d5e00702d1fbffaa56f3)


### [Finatra](https://github.com/twitter/finatra/) ###

Added
=====

-   inject-thrift-client: Add per-method retry configuration withMaxRetries in
    com.twitter.inject.thrift.ThriftMethodBuilder for customizing configureServicePerEndpoint.
    [be9f27c8](https://github.com/twitter/finatra/commit/be9f27c8c9eb5f16c4b3e0199f3e697058766745)

Breaking API Changes
====================

-   finatra: Deprecate c.t.inject.utils.AnnotationUtils, users should instead use
    c.t.util.reflect.Annotations from com.twitter:util-reflect. Deprecate
    c.t.finatra.utils.ClassUtils, users should instead use either
    c.t.util.reflect.Classes\#simpleName, c.t.util.reflect.Types\#isCaseClass or
    c.t.util.reflect.Types\#notCaseClass from com.twitter:util-reflect. [291d1b78](https://github.com/twitter/finatra/commit/291d1b781b8fb2e079e781e34a609c6222764650)
-   finatra: Builds are now only supported for Scala 2.12+ [5f08f469](https://github.com/twitter/finatra/commit/5f08f4694389b277917f2449821d08c78d63b583)

Changed
=======

-   finatra: Revert to scala version 2.12.12 due to <https://github.com/scoverage/sbt-scoverage/issues/319>
    [6f74aedb](https://github.com/twitter/finatra/commit/6f74aedb317eee2873c646373886710d396bcba2)
-   finatra: Bump scala version to 2.12.13 [029c7500](https://github.com/twitter/finatra/commit/029c7500045ce3e63d7afca67d4fcb5f1ac76689)
-   finatra: Move com.twitter.finatra.http.{jsonpatch,request} from the finatra/http-server project to
    finatra/http-core project. Please update your build artifact references accordingly.
    [f8a810b2](https://github.com/twitter/finatra/commit/f8a810b27adc5c7eb09ab37838f72d5625ee4bf2)
-   http-server,http-core,jackson,thrift,validation: Update to use c.t.util.reflect.Types
    in places for TypeTag reflection. [c132a053](https://github.com/twitter/finatra/commit/c132a053193991a99798ff0f405420a5adb8e648)
-   finatra: Move c.t.finatra.http.{context,exceptions,response} from the finatra/http-server project
    to finatra/http-core project. Please update your build artifact references accordingly.
    [9f6c9405](https://github.com/twitter/finatra/commit/9f6c9405b9b5dfff28d350401023ea5a9c5241a1)
-   finatra: Move c.t.finatra.http.streaming from the finatra/http-server project to
    finatra/http-core project. Please update your build artifact references accordingly.
    [d454fd0e](https://github.com/twitter/finatra/commit/d454fd0e24620b6325e34e920e43cb86d6cbbe32)
-   http-core: Introduce c.t.finatra.http.marshalling.MessageBodyManager\#builder for creating an immutable
    c.t.finatra.http.marshalling.MessageBodyManager. The MessageBodyManager's constructor is now private.
    [d8886dab](https://github.com/twitter/finatra/commit/d8886dabc7bb29aa5e4a267886430f85d719d567)
-   http-server: Move c.t.finatra.http.modules.MessageBodyFlagsModule to
    c.t.finatra.http.marshalling.modules.MessageBodyFlagsModule. [0cd97c79](https://github.com/twitter/finatra/commit/0cd97c798058d0e355cc57269bfecc8d175f503f)
-   validation: Remove deprecated constraint type aliases under com.twitter.finatra.validation, users
    should prefer the actual constraint annotations at com.twitter.finatra.validation.constraints.
    [498ebe4a](https://github.com/twitter/finatra/commit/498ebe4a4c9ef005105ff84247286253487ee9bc)
-   jackson: Remove deprecated com.twitter.finatra.json.utils.CamelCasePropertyNamingStrategy,
    users should prefer to use PropertyNamingStrategy\#LOWER\_CAMEL\_CASE or an equivalent directly.
    Also remove the deprecated com.twitter.finatra.json.annotations.JsonCamelCase, users should
    use the @JsonProperty or @JsonNaming annotations or an appropriately configured
    Jackson PropertyNamingStrategy instead. [da836c55](https://github.com/twitter/finatra/commit/da836c5593edcfb9b2f961d2c503a3c660b3dd6b)
-   inject-core: (BREAKING API CHANGE) Rename c.t.inject.TwitterModule.closeOnExit to onExit so
    it mirrors the API from c.t.inject.App. [b8f00879](https://github.com/twitter/finatra/commit/b8f00879bc3542e0e68f523c23ef46e4444f8d7b)
-   http-client: Remove deprecated c.t.finatra.httpclient.modules.HttpClientModule.
    Use c.t.finatra.httpclient.modules.HttpClientModuleTrait instead.
    [333c782a](https://github.com/twitter/finatra/commit/333c782a43e1feace4d8b0ebd187d74ce3b52a48)
-   http-client: Remove deprecated c.t.finatra.httpclient.RichHttpClient. Use c.t.finagle.Http.Client
    or c.t.finatra.httpclient.modules.HttpClientModuleTrait instead. Additionally,
    c.t.finatra.httpclient.modules.HttpClientModule.provideHttpService has been removed. Use
    c.t.finatra.httpclient.modules.HttpClientModuleTrait.newService(injector, statsReceiver)
    instead. [2af18ede](https://github.com/twitter/finatra/commit/2af18ede436b229d5eb9a85fefa36ff10ae7f060)
-   finatra: Move c.t.finatra.http.fileupload from the finatra/http-server project to
    finatra/http-core project. Please update your build artifact references accordingly.
    [8b0ea169](https://github.com/twitter/finatra/commit/8b0ea169bfd52735b95d271265b2f5396bc70a1c)
-   http-client: Remove deprecated method get from c.t.finatra.httpclient.HttpClient.
    Use HttpClient's execute instead. [eada0515](https://github.com/twitter/finatra/commit/eada0515b447c863c80e411be486e575b4baf2d2)
-   finatra: Create the finatra/http-core project, which is meant to contain common artifacts
    for the finatra/http-server and finatra/http-client project. As part of this
    change, the com.twitter.finatra.httpclient.RequestBuilder has been deprecated
    and should be updated to reference com.twitter.finatra.http.request.RequestBuilder.
    [5e3da631](https://github.com/twitter/finatra/commit/5e3da63163c54e0eee7901e7b2076890cd301ab1)
-   finatra: Rename the finatra/httpclient project to finatra/http-client. Please update your
    build artifact references (i.e. SBT, Maven) to use "finatra-http-client".
    [c0b0ae61](https://github.com/twitter/finatra/commit/c0b0ae61810dd1736cd4800cf3499bce8bb819d9)
-   kafkaStreams: Switch the default Kafka client and Kafka Stream client to version 2.4.1.
    [d2367485](https://github.com/twitter/finatra/commit/d23674852345f777178966c108c794c409a01f56)
-   finatra: Rename the finatra/http project to finatra/http-server. Please update your
    build artifact references (i.e. SBT, Maven) to use "finatra-http-server". See the
    [Finatra User's Guide](https://twitter.github.io/finatra/user-guide/index.html)
    [2cb398e6](https://github.com/twitter/finatra/commit/2cb398e6c6334fd6c37619024a0a8be1103e3a61)

### [Util](https://github.com/twitter/util/) ###

Runtime Behavior Changes
========================

-   util: Revert to scala version 2.12.12 due to <https://github.com/scoverage/sbt-scoverage/issues/319>
    [c075bb13](https://github.com/twitter/util/commit/c075bb13efb2b051f9963da323c37abb0b6a9ba9)
-   util: Bump scala version to 2.12.13 [b2b94e97](https://github.com/twitter/util/commit/b2b94e974dcbf478552631633b0cb358aa8cf125)

Breaking API Changes
====================

-   util: Rename c.t.util.reflect.Annotations\#annotationEquals to c.t.util.reflect.Annotations\#equals
    and c.t.util.reflect.Types.eq to c.t.util.reflect.Types.equals. [e90c5c61](https://github.com/twitter/util/commit/e90c5c61b32b7227c763b22db435b96c5f8a816e)
-   util: Builds are now only supported for Scala 2.12+ [2c90e2fc](https://github.com/twitter/util/commit/2c90e2fc9e04eb26ee564c664fd7355380df2575)
-   util-reflect: Remove deprecated c.t.util.reflect.Proxy. There is no library replacement.
    [62a3169d](https://github.com/twitter/util/commit/62a3169da0107aeec6205d0e1bbe49addc22d7cd)
-   util-security: Renamed com.twitter.util.security.PemFile to c.t.u.security.PemBytes, and
    changed its constructor to accept a string and a name. The main change here is that we assume
    the PEM-encoded text has been fully buffered. To migrate, please use the helper method on the
    companion object, PemBytes\#fromFile. Note that unlike before with construction, we read from
    the file, so it's possible for it to throw. [5876adfc](https://github.com/twitter/util/commit/5876adfc7038dc2e77e4b19a176f6f3faa3fd1ac)

New Features
============

-   util-reflect: Add c.t.util.reflect.Annotations a utility for finding annotations on a class and
    c.t.util.reflect.Classes which has a utility for obtaining the simpleName of a given class
    across JDK versions and while handling mangled names (those with non-supported Java identifier
    characters). Also add utilities to determine if a given class is a case class in
    c.t.util.reflect.Types. [95c45f71](https://github.com/twitter/util/commit/95c45f7107fb840a0e0ffa89ef3045f208ba4dd1)
-   util-reflect: Add c.t.util.reflect.Types, a utility for some limited reflection based
    operations. [7e32800a](https://github.com/twitter/util/commit/7e32800ae6345bd02bf62286ce2e9555132990d7)
-   util-core: c.t.io now supports creating and deconstructing unsigned 128-bit buffers
    in Buf. [955754d4](https://github.com/twitter/util/commit/955754d422b7a477113841c6eb2fa77996c30244)
-   util-core: c.t.io.ProxyByteReader and c.t.io.ProxyByteWriter are now public. They are
    useful for wrapping an existing ByteReader or ByteWriter and extending its functionality
    without modifying the underlying instance. [35abecad](https://github.com/twitter/util/commit/35abecad4622efb8c13ef5607dbb09f70c023e4a)
-   util-core: Provided c.t.u.security.X509CertificateDeserializer to make it possible to directly
    deserialize an X509Certificate even if you don't have a file on disk. Also provided
    c.t.u.security.X509TrustManagerFactory\#buildTrustManager to make it possible to directly
    construct an X509TrustManager with an X509Certificate instead of passing in a File.
    [5876adfc](https://github.com/twitter/util/commit/5876adfc7038dc2e77e4b19a176f6f3faa3fd1ac)


### [Scrooge](https://github.com/twitter/scrooge/) ###

Runtime Behavior Changes
========================

-   scrooge: Revert to scala version 2.12.12 due to <https://github.com/scoverage/sbt-scoverage/issues/319>
    [e67edc0c](https://github.com/twitter/scrooge/commit/e67edc0c6572fa2438aae15e7c44c5e44ee4160c)
-   scrooge: Bump scala version to 2.12.13 [3864106d](https://github.com/twitter/scrooge/commit/3864106d4d84b65bb02761ca176c7640d9a678fe)

Breaking API Changes
====================

-   scrooge: Builds are now only supported for Scala 2.12+ [72f5a0a0](https://github.com/twitter/scrooge/commit/72f5a0a07b145f82a892c8117cc57a7c2dc5282a)

### [TwitterServer](https://github.com/twitter/twitter-server/) ###

Breaking API Changes
====================

-   com.twitter.server.util.JsonConverter is divided into two Json mappers, JsonConverter
    and AdminJsonConverter. JsonConverter keeps the minimum configuration, for json mapping
    to/from twitter-server admin endpoints, AdminJsonConverter is configured to do so.
    [c90fa00c](https://github.com/twitter/twitter-server/commit/c90fa00caebab901ac786e320de681bca43447c8)
-   Json.scala and JsonConverter are merged, removed the Json.deserialize() methods.
    [c90fa00c](https://github.com/twitter/twitter-server/commit/c90fa00caebab901ac786e320de681bca43447c8)

Runtime Behavior Changes
========================

-   Revert to scala version 2.12.12 due to <https://github.com/scoverage/sbt-scoverage/issues/319>
    [869b1863](https://github.com/twitter/twitter-server/commit/869b18639246f1995682dcd734581320db462943)
-   Bump scala version to 2.12.13 [8d6cc59d](https://github.com/twitter/twitter-server/commit/8d6cc59de1270be5f957d577193597eceb2639e5)
-   Builds are now only supported for Scala 2.12+ [a9340873](https://github.com/twitter/twitter-server/commit/a9340873b3231357ef308620cf4bac68ea0f7124)

### Changelogs ###

* [Finagle 21.3.0][finagle]
* [Finatra 21.3.0][finatra]
* [Util 21.3.0][util]
* [Scrooge 21.3.0][scrooge]
* [TwitterServer 21.3.0][twitterserver]

[finagle]: https://github.com/twitter/finagle/blob/finagle-21.3.0/CHANGELOG.rst
[util]: https://github.com/twitter/util/blob/util-21.3.0/CHANGELOG.rst
[scrooge]: https://github.com/twitter/scrooge/blob/scrooge-21.3.0/CHANGELOG.rst
[twitterserver]: https://github.com/twitter/twitter-server/blob/twitter-server-21.3.0/CHANGELOG.rst
[finatra]: https://github.com/twitter/finatra/blob/finatra-21.3.0/CHANGELOG.rst

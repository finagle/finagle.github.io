---
layout: post
title: September 2021 Release Notes - Version 21.9.0
published: true
post_author:
  display_name: Bryce Anderson
  twitter: brycelanderson
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

September release, hot off the press:

[Util](https://github.com/twitter/util/)
========================================

New Features
------------

-   util-jvm: Experimentally crossbuilds with Scala 3. [bfdde071](https://github.com/twitter/util/commit/bfdde0713ea93f29f2fe72800313c0b66f3d9e0b)
-   util-stats: Counter, Gauge, and Stat can be instrumented with descriptions. `PHAB_ID = D615481`
-   util-cache: Experimentally crossbuilds with Scala 3. [22977aa0](https://github.com/twitter/util/commit/22977aa0ff20fe5fc1226cb9a1d75fe38424280c).
-   util-cache-guava: Experimentally crossbuilds with Scala 3. [6131382e](https://github.com/twitter/util/commit/6131382e273326d14e4784463f7612f388008600).
-   util-routing: Experimentally crossbuilds with Scala 3. [9615a9f1](https://github.com/twitter/util/commit/9615a9f14ced61de3fb30846127c7094dda72a8f)
-   util-sl4j-api: Experimentally crossbuilds with Scala 3. [e2368780](https://github.com/twitter/util/commit/e23687809145b8366046deaa8a7639e97c1152d6)
-   util-sl4j-jul-bridge: Experimentally crossbuilds with Scala 3. [16a4a945](https://github.com/twitter/util/commit/16a4a945d1107a3030944595babb250e010954c8)
-   util-stats: Experimentally crossbuilds with Scala 3. [ea54f59c](https://github.com/twitter/util/commit/ea54f59c0d31b2cd37065af59dcd1d37a39e6a09)
-   util-zk-test: Experimentally crossbuilds with Scala 3. [86df882b](https://github.com/twitter/util/commit/86df882b076c2c8df8eef3bd2e5e467a2089486b)
-   util-app: Flags parsing will now roll-up multiple flag parsing errors into a single
    error message. When an error is encountered, flag parsing will continue to collect parse error
    information instead of escaping on the first flag failure. After parsing all flags, if any errors
    are present, a message containing all of the failed flags and their error reason,
    along with the help usage message will be emitted. \`0def519d &lt;https://github.com/twitter/util/commit/0def519daf1cfd5dbed03faba750fbf331672a4e&gt;\_\_

Runtime Behavior Changes
------------------------

-   util: Bump version of Jackson to 2.11.4. [72b9ba1e](https://github.com/twitter/util/commit/72b9ba1e6464af1dcab33d6d336b207342034e99)
-   util: Bump version of json4s to 3.6.11. [a9afb222](https://github.com/twitter/util/commit/a9afb222f1418995eebea38750df460ff134cea6)

Breaking API Changes
--------------------

-   util-app: the c.t.app.App\#flags field is now a final def instead of a val to address
    override val scenarios where the c.t.app.App\#flags are accessed as part of construction,
    resulting in a NullPointerException due to access ordering issues.
    The c.t.app.Flags class is now made final. The c.t.app.App\#name field has changed from
    a val and is now a def. A new c.t.app.App\#includeGlobalFlags def has been exposed, which
    defaults to true. The c.t.app\#includeGlobalFlags def can be overridden to false
    (ex: override protected def includeGlobalFlags: Boolean = false) in order to skip discovery
    of GlobalFlags during flag parsing. \`b44e820c &lt;https://github.com/twitter/util/commit/b44e820c7992746a24fc98e509c749035ded288f&gt;\_\_


[Scrooge](https://github.com/twitter/scrooge/)
==============================================

Breaking API Changes
--------------------

-   scrooge-generator: Dropped the generic (higher-kinded-types) service interface in scala-gen,
    users are recommended to use YourService.MethodPerEndpoint, YourService.ServicePerEndpoint
    and YourService.ReqRepServicePerEndpoint to represent Thrift service endpoints. Note,
    -finagle option is required to generated finagle binding code. [8d768ca6](https://github.com/twitter/scrooge/commit/8d768ca620a33d18b89492a7a2077007cedb6e7d)
-   scrooge-generator: Removed YourService.FutureIface and YourService\[Future\] in scala-gen,
    use \$YourService.MethodPerEndpoint instead. Correspondingly, YourService\$FinagleService and
    related constructors taking MethodPerEndpoint as parameters. [8d768ca6](https://github.com/twitter/scrooge/commit/8d768ca620a33d18b89492a7a2077007cedb6e7d)
-   Scrooge-generator: Dropped ThriftServiceBuilder.build and MethodIfaceBuilder.newMethodIface.
    [8d768ca6](https://github.com/twitter/scrooge/commit/8d768ca620a33d18b89492a7a2077007cedb6e7d)
-   scrooge-generator: Add reserved keywords to ThriftParser. If your field names match
    these keywords, you may need to modify them. This change should not affect backwards
    and forwards compatiblility if using binary protocol for serde. [884f3603](https://github.com/twitter/scrooge/commit/884f360361bc4abf2e2c91ada1e9cbc15f584b0d)


[Finagle](https://github.com/twitter/finagle/)
==============================================

Breaking API Changes
--------------------

-   finagle-thrift: Removed c.t.finagle.thrift.ThriftClient\#newMethodIface and
    ThriftClient\#thriftService, use c.t.f.thrift.ThriftClient\#methodPerEndpoint. [fc21cccf](https://github.com/twitter/finagle/commit/fc21cccf2003c5acdc1989b19e783d774209363a)

Bug Fixes
---------

-   finagle-core/partitioning: Close balancers and their gauges when repartitioning.
    [d0bd053d](https://github.com/twitter/finagle/commit/d0bd053d2043eb1dd9e6aa8e43668a10ee857911)

Runtime Behavior Changes
------------------------

-   finagle: Upgrade to Netty 4.1.67.Final and netty-tcnative 2.0.40.Final. [c373fc08](https://github.com/twitter/finagle/commit/c373fc087b1b04cf36bc43baa576dc81337248a1)
-   finagle: Downgrade to Netty 4.1.66.Final [cbfbef89](https://github.com/twitter/finagle/commit/cbfbef8986fbdeabccda74bf9d2e1f35f706beb9)
-   finagle: Bump version of Jackson to 2.11.4. [19750a80](https://github.com/twitter/finagle/commit/19750a804fba41b5c074c39cda94d85dccb4160a)
-   finagle-core: OffloadFilter hands off work from Netty I/O thread to the offload CPU thread pool
    right after we enter the Finagle stack by default. Previously this could be enabled via a toggle.
    The com.twitter.finagle.OffloadEarly toggle has been removed. [2b5086fe](https://github.com/twitter/finagle/commit/2b5086fe877ef40ff62bff1171439b09c754848d)


[Finatra](https://github.com/twitter/finatra/)
==============================================

Breaking API Change
-------------------

-   finatra-thrift: Removed c.t.finatra.thrift.ThriftClient\#thriftClient, use
    \#methodPerEndpoint. [ed7ffac4](https://github.com/twitter/finatra/commit/ed7ffac459be28b1bd61afae3f7bead02ed2875d)

Runtime Behavior Changes
------------------------

-   finatra: Bump version of Logback to 1.2.6. [42cb5fc3](https://github.com/twitter/finatra/commit/42cb5fc35e7c2ed9d9d936b12ca79fd46cf3af45)
-   finatra: Bump version of Jackson to 2.11.4. [dff47602](https://github.com/twitter/finatra/commit/dff47602dc48238c76ea8a25a7ced13fc2120af6)
-   finatra: Bump version of Joda-Time to 2.10.10. [4906eab1](https://github.com/twitter/finatra/commit/4906eab1d788eb28586cd28bbaea445ca88f9c1d)
-   finatra: Bump version of logback to 1.2.5. [9eaa5f9d](https://github.com/twitter/finatra/commit/9eaa5f9d9486e54881676c2838436fc59e827d87)
-   finatra: Bump version of json4s to 3.6.11. [496d0e7d](https://github.com/twitter/finatra/commit/496d0e7d30e3b44d2c5223bd7aa1e1439b077fdc)


[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

Runtime Behavior Changes
------------------------

-   Bump version of Logback to 1.2.6. [4a1930f0](https://github.com/twitter/twitter-server/commit/4a1930f0da624ff59dbe47a9508f52d98603355f)
-   Bump version of Jackson to 2.11.4. [b4a8b44f](https://github.com/twitter/twitter-server/commit/b4a8b44f34445d31ebfcfa00f0343f79cbf27089)
-   Bump version of logback to 1.2.5. [0a2bfd6d](https://github.com/twitter/twitter-server/commit/0a2bfd6dee0d1651545b9ad0b001cf78a5f5b28d)


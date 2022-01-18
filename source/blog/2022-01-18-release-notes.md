---
layout: post
title: January 2022 Release Notes - Version 22.1.0
published: true
post_author:
  display_name: Kyle Bahr
  twitter: DinoCassowary
tags: Releases, Finagle, Finatra, Util, Scrooge, TwitterServer
---

Happy New Year! Ease yourself into the new year with our January release.

[Util](https://github.com/twitter/util/)
========================================

Breaking API Changes
--------------------

-   util-jackson: The error message when failing to deserialize a character now correctly prints the non-character string. [4ddeaf89](https://github.com/twitter/util/commit/4ddeaf899564a895d92d77fe7919a46ad7c100a3)

Runtime Behavior Changes
------------------------

-   util: Bump version of Jackson to 2.13.1. [4ddeaf89](https://github.com/twitter/util/commit/4ddeaf899564a895d92d77fe7919a46ad7c100a3)
-   util-core: Return suppressed exception information in Closable.sequence [2211f75b](https://github.com/twitter/util/commit/2211f75bf5c9384326e9d289fea4caa6ed82df38)

[Scrooge](https://github.com/twitter/scrooge/)
==============================================

No Changes
--------------------


[Finagle](https://github.com/twitter/finagle/)
==============================================

Runtime Behavior Changes
------------------------

-   finagle: Bump version of Jackson to 2.13.1. [831b2512](https://github.com/twitter/finagle/commit/831b25120addc828b7de83ae20dfbc7c2606125a)


[Finatra](https://github.com/twitter/finatra/)
==============================================

Added
-----

-   http-server: (BREAKING API CHANGE) Allow for customization of the building of the HTTP and HTTPS
    ListeningServer constructs. This allows users to specify any additional configuration over the
    Finagle Service\[-R, +R\] that is constructed by the HttpRouter. The
    c.t.finatra.http.HttpServerTrait\#build method has been replaced by two more specific versions:
    \#buildHttpListeningServer and \#buildHttpsListeningServer which are used in postWarmup to
    create the appropriate ListeningServer given it has a defined port value.

    We also update the EmbeddedHttpServer and EmbeddedHttpClient to allow for being able to run both
    the HTTP and HTTPS listening servers in tests. This is done by setting the httpsPortFlag to the
    value of https.port which will enable the binding of the HTTPS listening server to the ephemeral
    port in tests. [13a600ff](https://github.com/twitter/finatra/commit/13a600ff81fad6c0e0a68723a87dcea78f0d0c4b)

-   mysql-client: Add base client configuration in EmbeddedMysqlServer to enable for more robust
    testing setup. This would allow users to add configurations like charset.
    Added a overridable function createRichClient to MysqlClientModuleTrait to allow
    creating the mysql client in other ways like newRichClient(Finagle.Name, String).
    [dc1de215](https://github.com/twitter/finatra/commit/dc1de2154e2eab4080fffdbf2ff177fd846cc13b)

Changed
-------

-   finatra: Bump version of Jackson to 2.13.1 [79bd09c4](https://github.com/twitter/finatra/commit/79bd09c4f4b64c195eacf812786c874c3864ce1c)

[Twitter Server](https://github.com/twitter/twitter-server/)
============================================================

Runtime Behavior Changes
------------------------

-   Bump version of Jackson to 2.13.1. [da33afe9](https://github.com/twitter/twitter-server/commit/da33afe983a21d7e7a9b9a3fe27ecf358ec84d03)



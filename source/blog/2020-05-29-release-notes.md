---
layout: post
title: May 2020 Release Notes - Version 20.5.0
published: true
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

### [Finagle](https://github.com/twitter/finagle/)

#### Runtime Behavior Changes

-   finagle: Bump jackson version to 2.11.0. [696bb515](https://github.com/twitter/finagle/commit/696bb5158d667e0029f9cb1b9dce08fdd1a5de1c)

### [Finatra](https://github.com/twitter/finatra/)

#### Added

-   inject-mdc: Move MDC integration from inject/inject-slf4j to inject/inject-mdc.
    [daf8716d](https://github.com/twitter/finatra/commit/daf8716d2833854cc5c80b7a521897ae908a1273)
-   finatra-http|finatra-thrift: Update TraceIdMDCFilter to log traceSampled and traceSpanId
    `PHAB_ID=472013`
-   finatra-examples: Ensure there are Java and Scala examples for the different
    types of applications and servers which can be built with Finatra. Update /examples
    directory layout for discoverability and consistency. [2c45831c](https://github.com/twitter/finatra/commit/2c45831c2ae86f369540bad0ebf66b8a87b4c3bc)

#### Changed

-   inject-slf4j: Move MDC integration from inject/inject-slf4j to inject/inject-mdc.
    [daf8716d](https://github.com/twitter/finatra/commit/daf8716d2833854cc5c80b7a521897ae908a1273)
-   finatra-http: Allow extensions of the c.t.finatra.http.filters.HttpResponseFilter
    to specify how to set the Location Header value into a Response. Additionally, don't
    allow exceptions resulting from the inability to set a non-compliant 'Location' response
    header escape the filter. [e827d91f](https://github.com/twitter/finatra/commit/e827d91f1c46118d72334fddc6ceb0d2d5c44e9d)
-   inject-core: Make flag methods in c.t.inject.TwitterModule public an final. [455ee6de](https://github.com/twitter/finatra/commit/455ee6deeb8da39b4460cad611dba91293992c5e)
-   inject-core: c.t.inject.Mockito has been marked deprecated. Users are encouraged to prefer
    [mockito-scala](https://github.com/mockito/mockito-scala) (or ScalaTest [MockitoSugar](http://doc.scalatest.org/3.1.1/#org.scalatest.mock.MockitoSugar)
    which provides some basic syntax sugar for Mockito). [9dac0470](https://github.com/twitter/finatra/commit/9dac0470b79c6dc857545f04a318d7449b518bcc)
-   http: (BREAKING API CHANGE) Update the c.t.finatra.http.HttpResponseFilter to optionally fully
    qualify response 'Location' header values. A [previous change](https://github.com/twitter/finatra/commit/ff9acc9fbf4e89b532df9daf2b9cba6d90b2df96)
    made the filter always attempt to fully qualify any response 'Location' header value. This updates
    the logic to be opt-in for the more strict returning of fully qualified 'Location' header values with
    the default being to allow relative values per the [RFC7231](https://tools.ietf.org/html/rfc7231#section-7.1.2)
    which replaces the obsolete [RFC2616](https://tools.ietf.org/html/rfc2616#section-14.30). This is
    thus a breaking API change as the default is now to allow relative values. To enable the previous
    strict behavior, users should instantiate the filter with the constructor arg fullyQualifyLocationHeader
    set to 'true'. This addresses issue \#524. [b6453a4d](https://github.com/twitter/finatra/commit/b6453a4d0b047e965b5d43f319d028739b80d5d3)
-   jackson: Remove deprecated FinatraObjectMapper and FinatraJacksonModule. Users are encouraged
    to switch to the equivalent c.t.finatra.jackson.ScalaObjectMapper and
    c.t.finatra.jackson.modules.ScalaObjectMapperModule. [416cb346](https://github.com/twitter/finatra/commit/416cb3467c88e26704d695c1d6b8176172afa9c4)
-   finatra-http: Update c.t.finatra.http.StreamingJsonTestHelper to not use Thread.sleep for
    writing JSON elements on an artificial delay. [01fdd9cf](https://github.com/twitter/finatra/commit/01fdd9cfb3c877fe226085bf411f42ae08420e5d)
-   inject-app: Remove finagle-core dependency. Introduce finatra/inject/inject-dtab.
    [f8f4a35e](https://github.com/twitter/finatra/commit/f8f4a35ef95669d5a0c8d7091d9bb72675fea9db)
-   finatra: Bump version of Jackson to 2.11.0. [e265ba87](https://github.com/twitter/finatra/commit/e265ba87c5ff6cecc88b65dd050e0cf1a23df698)
-   finatra-http: Only create EnrichedResponse counters when needed. Any "service/failure"
    response counters will only be generated upon first failure and not eagerly for each
    response generated. This change impacts users who expect a counter value of 0 when no
    response failures have been encountered - now the counter will not exist until the first
    failure has been recorded. [b0626bd8](https://github.com/twitter/finatra/commit/b0626bd82ac2371be437b8f049511efa6edce83b)
-   finatra: Bump version of Joda-Time to 2.10.6. [f67fb7ab](https://github.com/twitter/finatra/commit/f67fb7abbe1992c83b7583993617cb64d4bd3a17)

#### Fixed

-   inject-thrift-client: Convert non-camel case ThriftMethod names, e.g., "get\_tweets" to
    camelCase, e.g., "getTweets" for reflection lookup of generated ReqRepServicePerEndpoint
    interface methods in c.t.inject.thrift.filters.DarkTrafficFilter. [ca538d64](https://github.com/twitter/finatra/commit/ca538d643c9ad5328441a80d9c4d666c946d36a7)

### [Util](https://github.com/twitter/util/)

#### New Features

-   util-security: Moved Credentials from util-core: c.t.util.Credentials =&gt; c.t.util.security.Credentials. [c34cd8ef](https://github.com/twitter/util/commit/c34cd8ef0a7fc16217035c02202de0ff5a962f79)

#### Breaking API Changes

-   util-core: Move Credentials to util-security:  c.t.util.Credentials =&gt; c.t.util.security.Credentials. [c34cd8ef](https://github.com/twitter/util/commit/c34cd8ef0a7fc16217035c02202de0ff5a962f79)

-   util-core: Change the namespace of ActivitySource and its derivatives to com.twitter.io as its no longer considered experimental since the code has changed minimally in the past 5 years. [3e939701](https://github.com/twitter/util/commit/3e939701d61b6678c3e6338853c9a48ceb8ce3c1)

### [Twitter Server](https://github.com/twitter/twitter-server/)

#### New Features

-   Make lookup of Admin LoggingHandler more resilient when multiple implementations are detected.
    Now instead of perhaps using an incorrect handler the server will instead emit a lint rule violation
    and not attempt to install a logging handler ensuring that only when a single LoggingHandler
    is located that the functionality is enabled. [1ffd0f6b](https://github.com/twitter/twitter-server/commit/1ffd0f6b62a95c46b2d095487db0cc4401a0d0ba)

#### Runtime Behavior Changes

-   Bump jackson version to 2.11.0. [2fc34c6a](https://github.com/twitter/twitter-server/commit/2fc34c6abc04b52e1e4da93aae8425ba406bccfc)

### [Scrooge](https://github.com/twitter/scrooge/)

-   scrooge: Update sbt-bintray plugin to 0.5.6 which supports passing environment
    variables BINTRAY\_USER and BINTRAY\_PASS for username and password credentials
    respectively. [2df31ac2](https://github.com/twitter/scrooge/commit/2df31ac29c663a47013ede77cd3d07fc017c6bc7)
-   scrooge-generator: Close open files in Importer. [74cfc670](https://github.com/twitter/scrooge/commit/74cfc6706f9fa165ec9609d4ae3886e910460762)

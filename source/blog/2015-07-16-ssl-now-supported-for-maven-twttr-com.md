---
layout: post
title: SSL now supported for maven.twttr.com
published: true
post_author:
  display_name: Travis Brown
  twitter: travisbrown
tags: Finagle
---

Most of Twitter's open source projects for the JVM are published to [Maven
Central][maven-central], but for various reasons a few are still published to
`maven.twttr.com`, a Maven repository that is hosted by Twitter. While Finagle
itself is in Maven Central, some of its subprojects and some
[Finagle-related libraries and tools][twitter-server] require dependencies from
`maven.twttr.com`.

We're actively working to eliminate the need for this separate repository, but
we don't have a definite timeline for moving everything to Maven Central, and so
this week we have enabled secure access to the repository, which was previously
only available over unsecured HTTP.
READMORE

To switch to HTTPS, you'll just need to add an "s" to the URL in your build
configuration. For example, if you have a line like the following in your SBT
build:

```scala
resolvers += "twitter-repo" at "http://maven.twttr.com"
```

You'll just change it to the following:

```scala
resolvers += "twitter-repo" at "https://maven.twttr.com"
```

Over the next week we'll be updating the build configuration and documentation 
for all of our own projects to reflect this change.

Unsecured access will remain available until September 30, 2015, but we
encourage you to update your configuration as soon as possible. Please contact
us on the [Finaglers](https://groups.google.com/forum/#!forum/finaglers) mailing
list or [on Twitter](https://twitter.com/finagle) if you have any questions
about this change.

[maven-central]: http://search.maven.org/
[twitter-server]: http://twitter.github.io/twitter-server/#quick-start

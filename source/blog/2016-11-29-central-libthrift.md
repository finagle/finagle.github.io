---
layout: post
title: Farewell, maven.twttr.com!
published: true
post_author:
  display_name: Bryce Anderson
  twitter: banderson
tags: Finagle, Finatra, Util
---

Historically Finagle has depended on a forked org.apache.thrift libthrift
version 0.5.x, which happens to not be published to the Central
Repository. We have published the artifact to maven.twttr.com,
but this requires users to add the maven.twttr.com repository as a
resolver for their project. This is normally not a serious problem for
most users, but historically maven.twttr.com has had a propensity to
be unreliable and inaccessible from certain locations. Our longterm
goal is to transition to a current version of Apache libthrift which is
hosted by the Central Repository, but there is a significant amount of
work we need to do internally before we can get there.

However, we have good news: now maven.twttr.com is no longer required! We
have published a fork of libthrift v0.5.0 to the central repository
under the 'com.twitter' organization. The class files still reside in
the 'org.apache' namespace, so users can still upgrade to newer version
of libthrift as they wish, but doing so will now require manual exclusion
rules because the eviction mechanisms used by sbt rely on matching
organization names:

```scala
// snippet from build.sbt script
libraryDependencies ++= Seq(
  "com.twitter" %% "finagle-thrift" % "6.40.0" exclude("com.twitter", "libthrift"),
  "org.apache.thrift" % "libthrift" % "0.9.3"
)
```

 See the [sbt documentation on library management](http://www.scala-sbt.org/0.13/docs/Library-Management.html)
for more details.



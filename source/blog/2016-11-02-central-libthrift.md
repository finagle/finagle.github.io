---
layout: post
title: Farewell, maven.twttr.com!
published: true
post_author:
  display_name: Bryce Anderson
  twitter: banderson
tags: Finagle, Finatra, Util
---

Historically Finagle has depended on org.apache.thrift libthrift
verison 0.5.x, which happens to not be published to the Central
Repository. We have published the artifact to the maven.twttr.com,
but this requires users to add the maven.twttr.com repository as a
resolver for their project. This is normally not a serious problem for
most users, but historically maven.twttr.com has has a propensity to
be unreliable and inaccessible from certain locations. Our long term
goal is to transition to a current version of Apache libthrift which is
hosted in the Central Repository, but there is a significant amount of
work we need to do internally because that can be realized.

However, I have good news: Now maven.twttr.com is no longer required! We
have published a fork of libthrift v0.5.0 to the central repository
under the 'com.twitter' organization. The class files still reside in
the 'org.apache' namespace, so users can still upgrade to newer version
of libthrift as they wish, but doing so will now require manual exclusion
rules because the eviction mechanisms used by sbt rely on matching
organization names. See the [sbt documentation on library managment](http://www.scala-sbt.org/0.13/docs/Library-Management.html)
for more details.



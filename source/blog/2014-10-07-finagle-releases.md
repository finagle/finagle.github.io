---
layout: post
title: Finagle releases
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Releases, Finagle, Util, Ostrich, Scrooge
---

For [Finagle](https://github.com/twitter/finagle) and its associated libraries,
known internally at Twitter as the Core Systems Libraries, we plan to change
the way we push code to GitHub and publish releases. The other libraries
included are [util](https://github.com/twitter/util),
[twitter-server](https://github.com/twitter/twitter-server),
[ostrich](https://github.com/twitter/ostrich), and
[scrooge](https://github.com/twitter/scrooge).
READMORE

## Background

Historically some Twitter-internal engineering projects depended directly on
published OSS versions of these libraries. Our internal requirements and our
external schedule for publishing to the community rarely overlapped. We have
recently improved our mechanism for sharing the libraries internally without
requiring external publishing, and as such we wanted to rethink how we share
this code with the community.

## Pushing source to GitHub

In the interest of getting changes open sourced more quickly, we will create
a new `develop` branch per project where we will publish the state of our
internal repos on a weekly schedule. These `develop` branches will require
building their other Twitter libraries from source instead of depending on
published versions. The `master` branch will continue to be reliant on
published versions of dependencies. There will be instructions on how to build
against both the `develop` branch and the `master` branch. Going forward, we
will encourage contributors to make pull requests against the `develop` branch.
We will merge `develop` back into `master` whenever we publish an OSS release.
We feel this gives users a good choice of picking between bleeding edge and
stable released versions. Furthermore, this will shorten the feedback loop
between contributing and seeing your code on GitHub, which we hope will
encourage all contributors to become repeat contributors. Although `develop`
will be the bleeding edge, we will keep `master` as the default on GitHub, so
that new users see it first.

## Releases

Over the years, Finagle and its associated libraries have made decent efforts
at keeping a valid [semver](http://semver.org/) for the projects. While these
efforts have been noble, they have only been best effort. Unfortunately, most
of our minor version bumps would be considered major version bumps in a strict
definition of semver; we do not feel, however, that bumping the major version
for every release is a win for anyone. Instead, we propose using major version
bumps for very large and/or significant API changes. Minor bumps will be the
vast majority of releases and indicate decent sized changes. Patches will be
used to indicate small changes and/or bug fixes.

Along with this change, we are planning to further improve on our recently
improved
[changelogs](https://finagle.github.io/blog/2014/08/12/release-notes/).
Specifically, we plan to add more details on API changes and to help give users
the context to migrate when necessary. We plan to make sure tags are pushed to
GitHub for each release.

These changes allow more flexibility in the timing of our OSS releases. We'd
like to move to doing releases on a slightly less frequent basis, say at least
once every two months. Our plan is to make these be "known" good versions that
Twitter has battle-tested in production. While this is an increase in time from
most of our releases, the ability to build from more recent source is available
to mitigate that lag.


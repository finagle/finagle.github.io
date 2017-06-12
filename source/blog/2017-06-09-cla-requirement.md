---
layout: post
title: Integration of CLA Assistant
published: true
post_author:
  display_name: Eitan Adler
tags: Finagle, CLA, Twitter
---

We have integrated [CLA Assistant](https://cla-assistant.io) with the Finagle Github repository.

Due to lack of discoverability, not everyone has been consistent about signing [Twitter's existing CLA](https://engineering.twitter.com/opensource/cla). We believe that this will be less of a burden than manually checking CLAs against an internal list.

The new tooling goes a long way in improving the experience for the new Finagle contributors by embedding the CLA signing step into a Github workflow. This means, every first-time Finagle contributor
will now be prompted into signing a CLA before their PRs are reviewed/accepted.

Eitan Adler, Vladimir Kostyukov, on behalf of Twitter's Open Source Team

# Finagle blog [![Build Status](https://secure.travis-ci.org/finagle/finagle.github.io.png?branch=source)](http://travis-ci.org/finagle/finagle.github.io)

This project uses [Middleman](http://middlemanapp.com/) to generate the
[blog](https://finagle.github.io) for the
[Finagle project](http://twitter.github.io/finagle/). If you'd like to
contribute a guest post about how you're using Finagle, you can get in touch
through [our Twitter account](https://twitter.com/finagle), or you can fork this
repository and submit a pull request for us to review.

## Setup

The first thing you need is a recent version of Docker. See the 
[Docker Desktop](https://www.docker.com/products/docker-desktop) page for installation
instructions.

The second thing we need to do is get the docker image built. We have a simple helper
command to do that for you:

``` bash
$ build_docker_image.sh
```

This will build a new docker image on your local machine and tag it `ghpublish`.
Once that completes successfully we can boot into our docker image and start our work.

``` bash
$ docker_start.sh
   # ... Container starts ...
docker $ cd finagle.github.io
docker $ bundle install # installs all the dependencies from the gemfile
```

Now you're ready to start working on the site.

## Generating the site

Once inside the container with the bundle installed we can generate and preview the site:

``` bash
docker $ bundle exec middleman server # preview the site locally before publishing
```

You can open the site preview from the host OS and preview the files by going to 
`http://localhost:4567/` in your host OS's browser. Updates to the underlying source files
will be detected and automatically rebuilt for the previewing server.

## Writing a post

Since the blog content is published in the `master` branch of this GitHub
repository, the source lives in a separate branch, appropriately named `source`.
It's a good idea to start your work on a new blog post by creating a fresh
branch off of `source`.

Posts live in the `source/blog/` directory and are written in
[Markdown](http://daringfireball.net/projects/markdown/). You
should create a file with a name formatted like `2014-08-14-short-title.md`, and
the file should have a header like the following:

``` markdown
---
layout: post
title: My new Finagle blog post
published: true
post_author:
  display_name: Travis Brown
  twitter: travisbrown
tags: Finagle, Util
---
```

Once you've written your post, push your commits to your fork and file a pull
request. We'll review your post and will get back to you as soon as we can if we
have changes to suggest, etc. Please let us know if you have any questions!

## Deploying the site

---
**NOTE**

You must have the appropriate Github access to perform the deployment step.

---

Once you merged you new blog post into the `source` branch, it's time to get that deployed
on [Github Pages](https://pages.github.com/) by running `bundle exec middleman deploy`
against the `source` branch from inside the docker container (if you exited you'll need to
`bundle install` again).

## Licensing

Unless otherwise noted, all content published on this blog is released under the
[Creative Commons Attribution 3.0 Unported License](https://creativecommons.org/licenses/by/3.0/)
(CC BY). The site generation code (and any code in posts) is available under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).
By submitting a pull request, you affirm that the content is your original work
and that you agree to have it published under these licenses.

---
layout: post
title: New and upcoming Finagle examples
published: true
public_draft: false
post_author:
  display_name: Travis Brown
  twitter: travisbrown
tags: Roadmap, Finagle, Examples
---

Part of my role as an open source advocate for Scala projects at Twitter
involves talking to developers outside of Twitter about how we can make
[our open source projects](https://engineering.twitter.com/opensource/projects)
more widely useful and accessible, and one of the most common requests for
Finagle is for more introductory tutorials and examples.

One of the steps we're taking in this direction is a major overhaul of
[`finagle-example`](https://github.com/twitter/finagle/tree/6.22.0/finagle-example/),
which we'll be moving out of the main Finagle repository and
into its own project under the [Finagle organization](https://github.com/finagle/)
on GitHub. At the same time we'll be
filling out the top-level introduction to the examples (which is [currently a
little bare](https://github.com/twitter/finagle/tree/6.22.0/finagle-example)),
adding more detailed API documentation, providing [better example coverage for
Finagle subprojects](https://github.com/twitter/finagle/tree/6.22.0/finagle-example/src/main/scala/com/twitter/finagle/example),
and creating a larger set of
[Java examples](https://github.com/twitter/finagle/tree/6.22.0/finagle-example/src/main/java/com/twitter/finagle/example/java)
to show off our new work on improving Java compatibility.
READMORE

We're also working on several stand-alone example projects and tutorials,
including the [Finagle Name Finder](https://github.com/finagle/finagle-example-name-finder),
which provides a simple Scala wrapper for a few pieces of [OpenNLP](https://opennlp.apache.org/),
a Java library for natural language processing, and uses that wrapper to define
a [named entity recognition](http://en.wikipedia.org/wiki/Named-entity_recognition)
RPC service built on Finagle and [Thrift](https://thrift.apache.org/).
You can start up a name finding service in your SBT console with just a few
lines of code:

```scala
import com.twitter.finagle.Thrift
import com.twitter.finagle.examples.names.thriftscala._

val server = SafeNameRecognizerService.create(
  langs = Seq("en"),
  numThreads = 4,
  numRecognizers = 4
) map { service =>
  Thrift.serveIface("localhost:9090", service)
} onSuccess { _ =>
  println("Server started successfully")
} onFailure { ex =>
  println("Could not start the server: " + ex)
}
```

You can then create a client (either locally in the same console, or on another
machine):

```scala
import com.twitter.finagle.Thrift
import com.twitter.finagle.examples.names.thriftscala._

val client =
  Thrift.newIface[NameRecognizerService.FutureIface]("localhost:9090")
```

And feed it a document:

```scala
val doc = """
An anomaly which often struck me in the character of my friend Sherlock Holmes
was that, although in his methods of thought he was the neatest and most
methodical of mankind, and although also he affected a certain quiet primness of
dress, he was none the less in his personal habits one of the most untidy men
that ever drove a fellow-lodger to distraction. Not that I am in the least
conventional in that respect myself. The rough-and-tumble work in Afghanistan,
coming on the top of a natural Bohemianism of disposition, has made me rather
more lax than befits a medical man.
"""

client.findNames("en", doc) onSuccess { response =>
  println("People: " + response.persons.mkString(", "))
  println("Places: " + response.locations.mkString(", "))
} onFailure { ex =>
  println("Something bad happened: " + ex.getMessage)
}
```

And the service will tokenize the document, identify parts of speech, attempt
to find all the names of people, places, and organizations, and promptly return
the results:

```
People: Sherlock Holmes
Places: Afghanistan
```

When you start a service, you can have OpenNLP recognizers loaded into memory
for a given set of languages, but the service can also load languages from disk
for individual requests—for example, we've only loaded the English-language
models for the service we started above, but we could also copy a set of
Spanish-language models into our `models` directory, and then our client could
ask to use them:

```scala
val esDoc = """
Alrededor de 1902 fue el primero en aplicar una descarga eléctrica en un tubo
sellado y con gas neón con la idea de crear una lámpara. Inspirado en parte por
la invención de Daniel McFarlan Moore, la lámpara de Moore, Claude inventó la
lámpara de neón mediante la descarga eléctrica de un gas inerte comprobando que
el brillo era considerable.
"""

val result = client.findNames("es", esDoc)
```

We're using the Name Finder project in a new "Finagle Essentials" course at
[Twitter University](https://twitter.com/university), and
[the slides](https://finagle.github.io/finagle-example-name-finder/) for that
course go into more detail about how the implementation works. The project is
currently designed to fit into an overview of the fundamental abstractions
behind Finagle, and to demonstrate just how easy it is to get a basic (but useful)
Finagle service up and running, but over the next few months we'll be expanding
it to show off more of Finagle's capabilities.

We're also working on a tutorial that walks through the implementation of a
Finagle protocol for [scodec](https://github.com/scodec/scodec), a Scala binary
serialization library that's part of the [Typelevel](http://typelevel.org/)
group of projects. If you're interested in helping out with this kind of
tutorial development, or if you have a Finagle example project, blog post, etc.
that you'd like us to feature, or if you just have questions, please get in
touch via [@finagle](https://twitter.com/finagle)
or the [Finaglers mailing list](https://groups.google.com/d/forum/finaglers),
and be sure to watch this space for updates as we continue to improve our
documentation and examples.


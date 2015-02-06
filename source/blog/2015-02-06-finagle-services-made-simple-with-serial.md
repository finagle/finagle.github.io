---
layout: post
title: Finagle services made simple with Serial
published: true
post_author:
  display_name: Travis Brown
  twitter: travisbrown
tags: Finagle, Serial, Scodec
---

Most internal services at Twitter speak the [Thrift protocol][thrift], which
provides many benefits—once you've defined your data types and service
interfaces, for example, it's possible to create bindings for a wide range of
programming languages, and Twitter's [Scrooge][scrooge] in particular makes
it easy to create high-performance Finagle servers and clients for your Thrift
interfaces.

In some cases, though, it would be more convenient not to have to worry about
things like interface description files, the build system plugins necessary to
generate bindings from them, etc. In particular, being able to define Finagle
services that take arbitrary types as inputs and outputs in a Scala REPL would
make writing tutorials and quickstart projects much more straightforward, and
would enable easier experimentation with other parts of the Finagle API.
READMORE

With this in mind, [Vladimir Kostyukov](https://twitter.com/vkostyukov) and I
decided to spend part of Twitter's January 2015 Hack Week putting together a
library that would allow users to create Finagle clients and servers that use
Scala (or Java) libraries for serialization instead of IDL-based systems like
Thrift. The result was [Finagle Serial][serial], a new project in the [Finagle
organization][finagle-org]. Serial is built on [Mux][mux], a generic
session-layer RPC protocol that supports multiplexing, and currently provides
support for using [Scodec][scodec] for object serialization. Other
serialization libraries may be supported in the future, but we found that
Scodec worked well for the initial proof-of-concept implementation.

## Starting a server

With Serial, you don't need to describe your service interfaces using an
external IDL—instead you simply provide _codecs_ for your input and output
types. If you clone the [Serial repository][serial] and [install
SBT][sbt-install], you can launch a REPL with the following command:

``` bash
sbt "project scodec" console
```

And then define and start a Finagle server with just a few lines of code:

``` scala
import com.twitter.finagle.Service
import com.twitter.util.Future
import io.github.finagle.serial.scodec.ScodecSerial
import java.net.InetSocketAddress
import scodec.Codec
import scodec.codecs._

val protocol = ScodecSerial(int32, double)

val reciprocalServer =
  protocol.serveFunction(new InetSocketAddress(8123))(1.0 / _)
```

And that's all—we now have a Finagle server running on port 8123 that will
return the floating-point reciprocal of any integer we pass to it.

Note that all you need to be able to serve a Finagle `Service[Req, Rep]` (or an
ordinary function from `Req` to `Rep`) is a pair of codecs for the `Req` and
`Rep` types.

In this example, `int32` and `double` are the Scodec codecs that we've decided
to use for the `Int` and `Double` input and output types. These are fairly simple,
but Scodec makes it possible to define more complex codecs with very little
boilerplate (see for example the ones for the `User` and `Greeting` case classes
below).

We can try out our server by defining and calling a client:

``` scala
val reciprocal = protocol.newService("localhost:8123")

reciprocal(1001).onSuccess(result => println(f"$result%.12f"))
```

Which should print `0.000999000999`, exactly as we'd expect.

## Handling exceptions

Now for a slightly more interesting service:

``` scala
val protocol = ScodecSerial(variableSizeBits(uint8, utf8), int32)

val intParsingServer =
  protocol.serveFunction(new InetSocketAddress(8124))(_.toInt)

val intParser = protocol.newService("localhost:8124")

intParser("2015").onSuccess(println)
```

This should print `2015`. But the function that we're serving is of course not
very well-behaved—it'll throw an exception on strings that can't be
parsed into integers. So what happens if we call our client with invalid input?

``` scala
intParser("I'm not a number").onFailure(result => println(s"Too bad: $result"))
```

You should see the following:

``` scala
Too bad: java.lang.NumberFormatException: For input string: "I'm not a number"
```

Note that we're getting a `NumberFormatException`, not a
[`ServerApplicationError`][sae] or some other kind of Finagle-explicit exception
type. This is because the default Scodec protocol implementation knows how to
serialize a few common exception types so that they can be sent over the wire.

## Using your own input, output, and error types

Using types you've defined as your service's input and output is as easy as
providing codecs for those types, and you also can extend the functionality in
the default implementation with information about how to serialize your own
exception types. Custom error types requires a little more work than custom
input and output types, but it's still fairly concise (and is likely to improve
in future iterations of the API).

Suppose for example that we've got a simple user greeting service with a couple
of case classes and a custom error type:

``` scala
case class User(name: String)
case class Greeting(u: User) {
  override def toString = s"Hello, ${u.name}!"
}
case class GreetingError(message: String) extends Exception(message)

object GreetUser extends Service[User, Greeting] {
  def apply(u: User) = u match {
    case User("Mary") => Future.value(Greeting(u))
    case User(other) => Future.exception(GreetingError(s"Unknown user: $other"))
  }
}
```

The easy part is defining our codecs for our input and output case classes:

``` scala
val userCodec: Codec[User] = variableSizeBits(uint24, utf8).as[User]
val greetingCodec: Codec[Greeting] = userCodec.as[Greeting]
```

We have to create a new `ScodecSerial` instance to add support for our custom
error type, but then we're done:

``` scala
import io.github.finagle.serial.scodec.ApplicationErrorCodec

object UserSerial extends ScodecSerial {
  override lazy val applicationErrorCodec =
    ApplicationErrorCodec.basic.add(GreetingError(_)) {
      case GreetingError(message) => message
    }.underlying
}

val protocol = UserSerial(userCodec, greetingCodec)

val server = protocol.serve(new InetSocketAddress(8125), GreetUser)
val client = protocol.newService("localhost:8125")
```

Now Mary will get a greeting and everyone else will get a `GreetingError`:

``` scala
scala> client(User("Mary")).onSuccess(println)
res33: com.twitter.util.Future[Greeting] = ...
Hello, Mary!

scala> client(User("Travis")).onFailure(println)
res34: com.twitter.util.Future[Greeting] = ...
GreetingError: Unknown user: Travis
```

Any exceptions that the implementation doesn't know how to serialize will result
in the exception's message being wrapped in a Serial `ApplicationError`.

## Using Serial

Serial is a very young project, but Finagle and Mux are a good foundation to
build on, and we love to have other people give it a try.

The API documentation is available on [the project's GitHub Pages site][api],
and the project's [README][readme] presents some initial benchmarks and goes
into more detail on topics like exception serialization. If you're interested in
writing an implementation for another serialization library, we've put together
some [ScalaCheck][scalacheck]-based integration testing tools that can help you
verify that it's working correctly.

Please let us know if you have any questions, either by filing a GitHub issue or
getting in touch through [@finagle](https://twitter.com/finagle) or the
[Finaglers mailing list][ml]!

[thrift]: https://thrift.apache.org/
[scrooge]: https://twitter.github.io/scrooge/
[serial]: https://github.com/finagle/finagle-serial
[finagle-org]: https://github.com/finagle
[mux]: https://twitter.github.io/finagle/guide/Protocols.html#mux
[scodec]: https://github.com/scodec/scodec
[sbt-install]: http://www.scala-sbt.org/0.13/tutorial/Setup.html
[sae]: https://twitter.github.io/finagle/docs/index.html#com.twitter.finagle.mux.ServerApplicationError
[readme]: https://github.com/finagle/finagle-serial
[scalacheck]: https://www.scalacheck.org/
[api]: https://finagle.github.io/finagle-serial/docs/#package
[ml]: https://groups.google.com/forum/#!forum/finaglers

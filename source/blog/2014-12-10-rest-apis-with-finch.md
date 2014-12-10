---
layout: post
title: Purely Functional REST APIs with Finch
published: true
public_draft: false
post_author:
  display_name: Vladimir Kostyukov
  twitter: vkostyukov
tags: Finagle, Finch
---

At [Konfettin][1] we decided to build a REST API backend using a [Finagle][2] stack. While it's possible to do that using pure Finagle abstractions, we ended up writing the [Finch][3] library to simplify things and get more suitable building blocks. And it worked well: we shipped the product and got the customers. This library has been running in production for about six months so far and it's pretty stable and well-tested. This post gives an overview of Finch: explains its core design principles and use cases.
READMORE

## Overview
Finch's mission is to provide the developers composable REST API building blocks being as close as possible to the bare metal Finagle API. The killer feature of Finch is purely functional primitives/functions layered on top of the Finagle API. Finch doesn't _hide_ the underlying API, but _extends_ it with new abstractions such as `RequestReader`, `ResponseBuilder`, `Endpoint`, etc. Using Finch means using the power and composability of Finagle within a couple of handy REST-specific types/functions.

<p align="center">
  <img src="https://raw.githubusercontent.com/finagle/finch/master/finch-logo.png" width="360px" style="margin: 1em 0em;"/>
</p>

## Quick Start
Let's start with writing a simple REST service that greets a user by given `name` and `title`.

```scala
import io.finch._
import io.finch.request._
import io.finch.response._

def hello(name: String) = new Service[HttpRequest, HttpResponse] = {
  def apply(req: HttpRequest) = for {
    title <- OptionalParam("title")(req)
  } yield Ok(Json.obj("greetings" -> s"Hello, ${title.getOrElse("")} $name!"))
}

val endpoint = new Endpoint[HttpRequest, HttpResponse] {
  def route = {
    // routes requests like '/hello/Bob?title=Mr.'
    case Method.Get -> Root / "hello" / name => hello(name)
  }
}
```

The `name` param is passed as a part of URI, but the `title` is a regular query string param. The body of `hello` service is a for-comprehension over the Finagle futures. `OptionalParam` (a `RequestReader`) might be treated here as a simple Finagle service that fetches the _option_ of string out of the HTTP request. So it takes an `HttpRequest` and returns a `Future[Option[String]]`.

The response is build by `ResponseBuilder` `Ok` that builds a succeed `HttpResponse` with status code two hundred. It takes a JSON object and builds `application/json` HTTP response. The JSON API is provided by `finch-json` module, which is shipped along with `finch-core`.

## Request Reader
Under the hood, `RequestReader` is a [reader monad][4]. So, it has a monadic API and we can use a for-comprehension to compose readers together. `RequestReader` is also a function. So we can pass it a request and get a future of a read value.

Since the request readers read futures they might be chained together with regular Finagle services in a single for-comprehension. Thus, reading the request params is an additional monad-transformation in the program's data flow. This is an extremely useful when a service should fetch and validate the request params before doing a real job and not doing the job at all if the params are not valid. `RequestReader` might throw a future exception and none of further transformations will be performed. _Reader Monad_ is a well-known abstraction that is heavily used in Finch applications.

The simplified signature of the `RequestReader` abstraction is similar to `Service` but with monadic API methods `map` and `flatMap`.

```scala
trait RequestReader[A] {
  def apply(req: HttpRequest): Future[A]
  def map[B](fn: A => B): RequestReader[B] = ???
  def flatMap(fn: A => RequestReader[B]): RequestReader[B] = ???
}
```

In the following example, we define a new request reader `pagination` that reads a tuple from an `HttpRequest` with two numbers: `offset` and `limit`. These params are optional so we have to provide default values for both of them. We can use request reader as a regular service: it takes an `HttpRequest` and returns the pagination details in `Future[(Int, Int)]`.

```scala
import io.finch.request._

val pagination: RequestReader[(Int, Int)] = for {
  offset <- OptionalIntParam("offset")
  limit <- OptionalIntParam("limit")
} yield (offset.getOrElse(0), math.min(limit.getOrElse(50), 50))

val service = new Service[HttpRequest, HttpResponse] {
  def apply(req: HttpRequest) = for {
    (offsetIt, limit) <- pagination(req)
  } yield Ok(s"Fetching items $offset..${offset+limit}")
}
```

Here is more complex example: _param validation_. The `RequestReader` abstraction may be used for param validation. There is a `ValidationRule` request reader that doesn't read anything from the request but validates the given predicate and returns `Future.Done` in case of success. Since, a `ValidationRule` is an implementation of a `RequestReader`, it might be chained together with other request readers in the same for-comprehension.

```scala
import io.finch.request._

case class User(age: Int)

val adult: RequestReader[User] = for {
  age <- RequiredIntParam("age")
  _ <- ValidationRule("age", "should be greater then 18") { age > 18 }
} yield User(age)

val req: HttpRequest = ???

val user: Json = adult(req) map { Json.obj("age" -> _.age) } handle {
  case ParamNotFound(param) =>
    Json.obj("error" -> e.getMessage, "param" -> e.param)
  case ValidationFailed(param, rule) =>
    Json.obj("error" -> e.getMessage, "param" -> e.param, "rule" -> rule)
}
```

We have a case class `User` with only single field `age`. We can define a new reader `adult` that reads only adult users. We compose a `RequiredIntParam` request reader here within a `ValidationRule`. Then, we fetch the _adult_ user out of the `HttpRequest` and map it to JSON object. We also have to handle the exceptions of both cases: `ParamNotFound` and `ValidationFailed`.

There are plenty of request readers that can read almost everything out of the `HttpRequest`. There are three common groups of readers:

* `OptionalX` - reads future `Option` value from the request;
* `RequiredX` - reads either future of value or future exception from the request;
* `ValidationRule` - returns `Future.Done` if the given predicate is true or `Future[ValidationFailed]` exception;

Every _required_ reader has a companion _optional_ one that reads value into a `Future[Option[_]]`. For example, there are `RequiredIntParam` and `OptionalIntParam` readers Finch. Here the list of most popular required readers.

* `RequiredParam` reads query string param value into a `Future[String]` or `Future[ParamNotFound]` exception;
* `RequiredParams` reads comma-separated query string param values into a `Future[List[_]]` or `Future[ParamNotFound]` exception;
* `RequiredStringBody` reads request body into a `Future[String]` or `Future[BodyNotFound]` exception;
* `RequiredJsonBody` reasd request body into a `Future` of JSON type defined by implicit `DecodeJson` value or `Future[JsonNotParsed]` exception;
* `RequiredHeader` reads request header into a `Future[String]` or `Future[HeaderNotFound]` exception;

For complete reference, see [Requests][5] section in the documentation.

## Response Builder
Responses are much easier. There are plenty of predefined response builders like `Ok`, `NotFound` and so on. We can pass it a `String` and get `plain/text` HTTP response or we can pass it a JSON object and get `application/json` HTTP response. We can also add custom headers to the response.

```scala
import io.finch.response._

// an empty response with status 200
val a = Ok()

// 'plain/text' response with status 404
val b = NotFound("body")

// 'application/json' response with status 201
val c = Created(Json.obj("id" -> 42))

// an empty response with header
val d = SeeOther.withHeaders("X-Location" -> "Nowhere")()
```

For more details, see [Responses][6] section in the documentation.

## Endpoint
Another powerful abstraction in Finch is an `Endpoint`, which is a _composable router_. At the high level it might be treated as a usual `PartialFuncton` from request to service. Endpoints may be converted to Finagle services. And more importantly they can be composed with other building blocks like _filters_, _services_ or _endpoints_ itself.

We've seen a pipe (a bang `!`) operator  before in a quick start example. It's kinda type-safe compositor which can be used with almost everything. It exposes a data flow just like the Linux pipe `|`. The idea is pretty simple: we can build new endpoints by composing the old ones with either filters or services. It is nothing more than a fancy DSL for developers to allow them to think of the `request` -> `response` relationship in terms of flow of data: we just pipe the request through the chain of building blocks and it flows in the exact way we've written it. Easy-peasy to reason about such code.

```scala
val ab: Filter[A, C, B, C] = ???
val bc: Endpoint[B, C] = ???
val cd: Service[C, D]

val ad1: Endpoint[A, D] = ab ! bc ! cd
val ad2: Endpoint[A, D] = ???
val ad3: Endpoint[A, D] = ad1 orElse ad2
```

See [Endpoints][8] section in the documentation.

## JSON
The Finch library has built-in support for JSON via traits `EncodeJson` and `DecodeJson`. All the building blocks in Finch that deal with JSON objects take those traits as implicit values. It makes the JSON dependency pluggable. All we need to do in order to change the JSON backend is to import implicit encoder and decoder into scope and use the new JSON API.

Here is an example of usage of the default JSON implementation from `finch-json` module.

```scala
import io.finch.json._       // import Immutable JSON API from finch-json
import io.finch.json.finch._ // import implciit encoder/decoder for finch-json

val jsonService: Service[HttpRequest, Json] = ???
val httpService: Setvice[HttpRequest, HttpResponse] = jsonService ! TurnJsonIntoHttp[Json]
```

See [JSON][9] section in the documentation.

## OAuth2
There is a separate project [finagle-oauth2][12], which is 100% compatible with Finch. It might be used as follows for request authorization.

```scala
import com.twitter.finagle.oauth2._
import com.twitter.finagle.oauth2.{OAuth2Filter, OAuth2Request}

val dataHandler: DataHandler[User] = ???

val auth = new OAuth2Filter(dataHandler)

val hello = new Service[OAuth2Request[User], Response] {
  def apply(req: OAuth2Request[User]) = {
    println(s"Hello, ${req.authInfo.user}!")
    Future.value(Response())
  }
}

val backend: Service[Request, Response] = auth andThen hello
```

Here `hello` is a _protected_ service. It takes only authorized requests (request type is `OAuth2Request[U]`). So, we can rely on the compiler to make sure at compile time that all the services that are supposed to be protected are actually protected. This is a well-known Finagle example of why we need filters and why we love type-safety. We express the business logic in the type system and get a robust application.

For details, see [Authentication][10] section in the documentation.

## Finagle Rocks!
Finagle itself is a great tool that can easily be adopted outside the Twitter infrastructure. Sometimes it just requires writing a couple of handy libraries on top of it. And that shouldn't be scary for passionate developers.

## Try Finch
The latest [release][7] is available on Maven Central:

```scala
libraryDependencies ++= Seq(
  "com.github.finagle" %% "finch-core" % "0.2.0",
  "com.github.finagle" %% "finch-json" % "0.2.0"
)
```

For a complete example of usage, see the [demo][11] project ([Main.scala][13]) that is built with the `finch-core` and `finch-json` modules.

[1]: http://konfettin.ru
[2]: https://twitter.github.io/finagle
[3]: https://github.com/finagle/finch
[4]: https://hackage.haskell.org/package/mtl-1.1.0.2/docs/Control-Monad-Reader.html
[5]: https://github.com/finagle/finch/blob/master/docs.md#requests
[6]: https://github.com/finagle/finch/blob/master/docs.md#responses
[7]: https://github.com/finagle/finch/releases/tag/0.2.0
[8]: https://github.com/finagle/finch/blob/master/docs.md#endpoints
[9]: https://github.com/finagle/finch/blob/master/docs.md#json
[10]: https://github.com/finagle/finch/blob/master/docs.md#authentication
[11]: https://github.com/finagle/finch/blob/master/docs.md#demo
[12]: https://github.com/finagle/finagle-oauth2\
[13]: https://github.com/finagle/finch/blob/master/finch-demo/src/main/scala/io/finch/demo/Main.scala

---
layout: post
title: Reusable HTTP contracts with Fintrospect
published: true
post_author:
  display_name: David Denton
  github: daviddenton
tags: Finagle, Fintrospect
---

# Reusable HTTP contracts with Fintrospect

## overview 
At [SpringerNature][springernature], we've been migrating our architecture stack to a Microservice-based approach, and from the application side a few core requirements kept coming up. We wanted our apps to be able to easily:

- generate and serve live API contract documentation - in our case [Swagger][swagger] docs with [JSON schema][jsonschema] example
- automatically validate and respond to invalid requests (missing or invalid parameters)
- marshal objects to and from HTTP requests in various messaging formats in a type-safe way, for both server and client-side services
- provide a low effort way of creating HTTP servers to fake our downstream dependencies for CDC and network based testing

To solve these requirements, [Fintrospect][fintrospect] was devised. The library provides a thin layer over the top of Finagle HTTP that helped us solve the above requirements with minimal ongoing effort. 

This post describes a brief overview of the main features of the library. Full documentation can be found at the [project site][fintrospect], or for the impatient there is a Github repo with a [demo application][demo].

Let's dive in...

## defining HTTP contracts
An HTTP contract is created by defining a ```RouteSpec``` which takes some typed parameters at a particular path:

```scala
val activeOnly = Header.optional.boolean("listOnlyActive")
val employeeName = Query.required.string("name")
val departmentId = Path.integer("departmentId")

val listEmployeesContract = RouteSpec("search for all employees in a particular group")
  .taking(activeOnly)
  .taking(employeeName)
  .at(Get) / "search" / departmentId
```

Body parameters are handled in much the same way... with built in support for both JSON and XML.

## serving the contract

#### basics
In order to serve the contract, we need to bind it to a Finagle ```Service```. Dynamic Path parameters (in this case `departmentId`) are read from the URL and injected on a request-by-request basis. Other parameters can be retrieved in a type-safe way through applying the ```<--``` operator to the request. Bad requests (missing/malformed parameters) have already been dealt with automatically by this point, so no validation logic is required:

```scala
def listEmployees(departmentId: Integer) = Service.mk[Request, Response] { request => 
  val activeFlag: Option[Boolean] = activeOnly <-- request
  val employeeNameInstance: String = employeeName <-- request
  ...
}

val listEmployeesRoute = listEmployeesContract bindTo listEmployees
```

Routes which all live in a common context are then bundled into a ```ModuleSpec``` (which can themselves be combined), and the result is converted into a standard Service which can be served as usual using the Finagle ```Http``` API:

```scala
Http.serve(":9000", ModuleSpec(Root / "employee").withRoute(listEmployeesRoute).toService)
```

#### creating the HTTP response
Fintrospect includes support for natively creating responses using a number of different protocols, and also ships with bindings for creating JSON messages from [a bunch][supportedjson] of popular JSON libraries, including the auto case-class conversion support included in [Argonaut][argonaut], and more recently [Circe][circe]. There are various mechanisms of creating the responses, but the below method is the most compact:

```scala
import Argonaut.ResponseBuilder._
import Argonaut.JsonFormat._

case class Employee(name: String)

val resp: ResponseBuilder[Json] = Ok(encode(Employee("Bob"))).withHeaders("MyCustomHeader" -> "value")
```

The first call to ```Ok``` in the example above references the Finagle ```Status.Ok``` object which is implicitly converted to a ```ResponseBuilder```. We also get implicit conversion from the ```ResponseBuilder``` to a ```Future[Response]```, so an implementation of the server method above could simply be:

```scala
def listEmployees(departmentId: Integer) = Service.mk[Request, Response] { request => 
  Ok(encode(List(Employee(employeeName <-- request))))
}
```

#### custom parameters and bodies
Parameter and body type support includes a number of factory methods for various primitive and complex (JSON/XML/Form) types, but it is also simple to provide support for your own - you just need to provide the mechanism to serialise and deserialise the type instance:

```scala
val spec = ParameterSpec[EmployeeId]("employeeId", None, NumberParamType, 
  s => EmployeeId(parseInt(s)), id => id.value.toString)

val employeeId = Query.required(spec)
val id: EmployeeId = employeeId <-- request
```

Body specifications are declared in the same way, by defining a ```BodySpec```.

#### generating the documentation
Another of our requirements was to provide live documentation for the services - and this is can be auto-generated by providing a ```ModuleRenderer``` implementation when defining the ```ModuleSpec```. By default, the documentation URL appears at the root context of the module - in this case ```http://localhost:9000/employee``` :

```scala
val findEmployeeContract = RouteSpec("employee lookup", "more detailed description of the service")
  .returning(NotFound -> "so such employee")
  .returning(Ok -> "here you go", encode(Employee("Bob")))
  .at(Get) / Path.string("id", "the employee id in the format 12-3456-78")

ModuleSpec(Root / "employee", Swagger2dot0Json(ApiInfo("employee server", "1.0")))
  .withRoute(findEmployeeContract bindTo searchEmployees)
  .toService
```

The additional detail provided above regarding the formats of the parameters and the possible responses are reflected in the generated Swagger documentation - the idea being to keep the docs as close to the actual implementation as possible to avoid possible staleness.

In order to interact with the API here, you'll need an instance of the Swagger UI. Normally, these are hosted yourself, but you can see an [example instance][swaggerpetstore].

All parameter locations are represented in the documentation, and in the case of JSON messages (when examples are provided for the responses or bodies), [JSON Schema][jsonschema] is generated to provide a breakdown of the expected object format.

## consuming the contract
The HTTP contract can also be bound to an outgoing Finagle Client ```Service```, which creates a callable ```RouteClient```. Typed values can be bound to the contract parameters using ```-->``` and are auto-marshaled into the outgoing request:

```scala
val client = listEmployeesContract bindToClient Http.newService("localhost:9001")
val response: Future[Response] = client(activeOnly --> true, employeeName --> "bob", departmentId --> 5)
```

## low-effort fake HTTP servers
The ability to reuse the defined HTTP contract for both the server and the client allows us to very easily create HTTP servers to fake out downstream dependencies. The ```TestHttpServer``` is provided for this purpose, allowing you easily mount single or multiple downstream contracts:

```scala
class FakeEmployeeServer (port: Int) {
  def listEmployees(departmentId: Integer) = Service.mk[Request, Response] { request =>
        ... fake logic goes here ...
  }

  val routes = new ServerRoutes[Response] {
    add(listEmployeesContract bindTo listEmployees)
  }

  def start() = new TestHttpServer(port, routes).start()
 }
```

One advantage of this kind of fake server setup is the ability to define CDC-style tests to ensure the integrity of the contract between the real and fake dependency. Another is that the effects of network problems such as timeouts can be easily be realistically recreated by building these into the fake server implementation.


## web content and templating
As well as serving of static content via ```StaticModule```, Fintrospect provides built-in support for the [Mustache][mustache] and [Handlebars][handlebars] templating engines. View models which implement the ```View``` trait will automatically render in the identically named view file, which is converted by a ```Render<Engine>View``` Filter. Here's an example Web module for Mustache which uses the filter at a module-level, and describes itself as an XML SiteMap:

```scala
// maps to IndexView.mustache in the classpath
case class IndexView(title: String) extends View

def index() = Service.mk { request: Request => IndexView("my great website") } 

ModuleSpec[View](Root, new SiteMapModuleRenderer(new URL("http://my.great.site")),
  new RenderMustacheView(Html.ResponseBuilder, "templates")
).withRoute(RouteSpec("index").at(Get) bindTo index)
```

## a note on design philosophy
The library has evolved greatly over the year that it's been in production, but the core principles remain:

- minimise API surface: we attempt to provide as a thin as possible a layer over Finagle, so the library user still talks mainly in terms of the standard Finagle HTTP API (Services/Filters/Request/Response).
- design for extensibility: new Parameter and Body types, message formats (such as JSON libraries etc), new module renderers and templating engines are all simple to add.
- dependency minimisation: Fintrospect only relies on a single external JAR and the even choice of Finagle version is up to the library user. Bindings for external message formats and templating libraries are shipped, but dependant libraries are up to the user to include.
- proper semantic versioning: using major versions to indicate breaking changes, along with notes in the changelog to help library users migrate versions.


## fin
And that's a whirlwind tour of some of the features of Fintrospect - you can see the full feature set in the documentation at the [project site][fintrospect]. For the impatient there is a Github repo with an fully tested [demo application][demo]. 

Alternatively, you can go straight to Maven for the base SBT install:
```scala
libraryDependencies ++= Seq(
  "io.github.daviddenton" %% "fintrospect" % "12.4.0",
  "com.twitter" %% "finagle-http" % "6.33.0"
)
```


[springernature]: http://www.springernature.com
[fintrospect]: http://fintrospect.io
[supportedjson]: http://fintrospect.io/installation
[jsonschema]: http://json-schema.org
[demo]: https://github.com/daviddenton/fintrospect-example-app
[argonaut]: http://argonaut.io
[circe]: http://circe.io
[swagger]: http://swagger.io
[swaggerpetstore]: https://petstore.swagger.io
[mustache]: http://mustache.github.io
[handlebars]: http://handlebarsjs.com

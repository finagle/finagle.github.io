---
layout: post
title: April 2020 Patch Release Notes - Version 20.4.1
published: true
post_author:
  display_name: Yufan Gong
  twitter: yufangong
tags: Releases, Finagle, Finatra, Scrooge, TwitterServer, Util
---

April Release encountered some issues running on JDK 8, here's a patch release that should address it. 

### [Finagle](https://github.com/twitter/finagle/)

#### New Features

- finagle-redis: Add `ConnectionInitCommand` stack to set database and password.
  [9fe05301](https://github.com/twitter/finagle/commit/9fe05301e56d2cbab001e48216a1b05f5a6e5e6a)

- finagle-mysql: Add `ConnectionInitSql` stack to set connection init sql. [bd4411dd](https://github.com/twitter/finagle/commit/bd4411ddc5e6e0df6b08b78a507280b654e617b9)

#### Runtime Behavior Changes

- finagle-core: Requeued reqeuests due to the `c.t.finagle.service.RequeueFilter` will generate
  their own spanId. [af490773](https://github.com/twitter/finagle/commit/af490773a8154b848a3f596897250b57d84df5c0)

#### Bug Fixes

- finagle-core: Restrict `OffloadFilter` from allowing interruption of the work performed in the worker pool. This is to ensure that the worker thread isn't interruptible, which is a
  behavior of certain `FuturePool` implementations. [f0af6ad7](https://github.com/twitter/finagle/commit/f0af6ad7f108d294abff5ccffe0dd93beca7560d) [59f9f2b5](https://github.com/twitter/finagle/commit/59f9f2b567b54d1c70fd6a41b89235e32c43cf8a)

- finagle-netty4: ChannelStatsHandler will now only count the first channel `close(..)` call when incrementing the `closes` counter. [3fa91944](https://github.com/twitter/finagle/commit/3fa919448139f0a40c5d9156075aed6fd4aef0ee)

#### Breaking API Changes

- finagle-toggle: Removed abstract type for `c.t.finagle.Toggle`, all Toggles are of type `Int`.
  This is to avoid Integer auto-boxing when calling `Toggle.apply`, thus to improve overall toggle performance. [c81a87b0](https://github.com/twitter/finagle/commit/c81a87b0cdf9105f7b2985686331d43d4c56067e)

- finagle-core: Retried requests due to the `c.t.finagle.service.RetryFilter` will generate their
own spanId. [762471a0](https://github.com/twitter/finagle/commit/762471a02885e4981efd41a1e09e819959997ed4)

### [Finatra](https://github.com/twitter/finatra/)

#### Added

- inject-app: Add default type conversions for `java.time.LocalTime`, `c.t.util.Time`,
  `java.net.InetSocketAddress`, and `c.t.util.StorageUnit`. This allows the injector to convert from
  a String representation to the given type. The type conversion for `java.net.InetSocketAddress`
  uses the `c.t.app.Flaggable.ofInetSocketAddress` implementation and the type conversion for
  `c.t.util.Time` uses the `c.t.app.Flaggable.ofTime` implementation for consistency with Flag parsing.
  Because of the current state of type erasure with `c.t.app.Flag` instances, Finatra currently binds
  a parsed `c.t.app.Flag` value as a String type, relying on registered Guice TypeConverters to convert
  from the bound String type to the requested type. These conversions now allow for a `c.t.app.Flag`
  defined over the type to be injected by the type as Guice now has a type conversion from the bound
  String type rather than as a String representation which then must be manually converted.
  [20ac122f](https://github.com/twitter/finatra/commit/20ac122f6672bc7b4a00dd796e4cd9293f6fb949)

- finatra-http: Method in tests to return an absolute path URI with the https scheme and authority
  [ffed3815](https://github.com/twitter/finatra/commit/ffed3815797d7a6d329f995eb2d91eae801e44b2)

- finatra: Java-friendly `bindClass` test APIs. The `bindClass` API calls from Java can be
  now chained with the `TestInjector`, `EmbeddedApp`, `EmbeddedTwitterServer`,
  `EmbeddedThriftServer`, and `EmbeddedHttpServer`. For example, the following is now possible:

  ```
  EmbeddedHttpServer server = new EmbeddedHttpServer(
      new HelloWorldServer(),
      Collections.emptyMap(),
      Stage.DEVELOPMENT)
      .bindClass(Integer.class, Flags.named("magic.number"), 42)
      .bindClass(Integer.class, Flags.named("module.magic.number"), 9999);
  return server;
  ```
  [e2b204a8](https://github.com/twitter/finatra/commit/e2b204a8dd08100e354e52c5ad2a4ce550072ad1)

#### Changed

- inject-app: Introduce consistent `c.t.app.Flag` creation methods for Java. Bring HTTP and Thrift
  server traits inline with each other to provide consistent Java support. Ensure Java examples in
  documentation. [c7d8c46c](https://github.com/twitter/finatra/commit/c7d8c46c55407958da6b91899cae0748259a3376)

- inject-core: Update the configuration of `c.t.app.Flag` instances created within a `c.t.inject.TwitterModule`
  to have `failFastUntilParsed` set to 'true' by default. While this is configurable for a given
  `c.t.inject.TwitterModule`, much like for the application itself, it is STRONGLY recommended that
  users adopt this behavior. [e74ef0a3](https://github.com/twitter/finatra/commit/e74ef0a3346802939a3bcae16d2e2e0e156ef9cf)

- inject-app: Update `c.t.inject.app.TestInjector` to always add the `InjectorModule`.
  [6e53e77a](https://github.com/twitter/finatra/commit/6e53e77a3c18c1fc5e07e13157d0f6c27a213080)

- inject-app: Reduce visibility of internal code in `c.t.inject.app.internal`. [a166dc89](https://github.com/twitter/finatra/commit/a166dc89bc427e08f665bfe43ebd39eb4c27a492)

- inject-modules: Updated BUILD files for Pants 1:1:1 layout. [a4fbbd19](https://github.com/twitter/finatra/commit/a4fbbd19c07874f41c1698090f1d7b48db910139)

#### Fixed

- finatra-kafka: Close a result observer when Namer.resolve fails. [f358993f](https://github.com/twitter/finatra/commit/f358993f0aa4a54f3757de59331cc50713d82834)

### [Util](https://github.com/twitter/util/)

#### New Features

- util-tunable: ConfigurationLinter accepts a relative path. [71d39d80](https://github.com/twitter/util/commit/71d39d80621fc3ac48d9154e2bd3bc5e049c639b)

### [Twitter Server](https://github.com/twitter/twitter-server/)

No Changes

### [Scrooge](https://github.com/twitter/scrooge/)

- scrooge-generator: Respect the proper order of separators in function declarations.
  [b72a08c9](https://github.com/twitter/scrooge/commit/b72a08c9a2e284f352c68afd9f4728c1f47f196d)

- scrooge-generator: Optimized generated Scala code for compile time and smaller bytecode.
  Companion objects for thrift enum traits are no longer case objects. [2189d281](https://github.com/twitter/scrooge/commit/2189d28104dd2c558af54b614fae2e533bc9fa11)

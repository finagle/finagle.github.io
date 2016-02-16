---
layout: post
title: Hello AsyncStream!
published: true
post_author:
  display_name: Moses Nakamura
  twitter: mnnakamura
tags: Finagle, Streaming
---

tl;dr AsyncStream is replacing Spool.

Big shoutout to [Neuman Vong][0], who designed and built AsyncStream soup to nuts ✧٩(•́⌄•́๑)

We know and love [Spool][1], the Twitter [util][2] tool for asynchronous object streaming.  The main
advantages of asynchronous stream processing are that it makes it easy to exert backpressure by no
longer reading from the stream, it’s easy to map over it lazily and asynchronously, and unlike a
Stream of Futures, it’s simple to discover the end of the collection without having to resort to
making it blocking, or allowing users to grab Futures past the end of the stream.

However, since we’ve had a long time to experiment with it, we’ve found that there are places where
Spool is a little clumsy.  For example, the `flatMap` operation in Spool isn’t associative, some of
the flatMap behavior is unintuitive, and the API is a little messy.  Taking lessons from our
experience with Spool, we are proud to announce [*~AsyncStream~*][3], as an improved API for
asynchronous object streaming.  Several twitter services spent months experimenting with it, and we
decided we were confident enough in it a few months ago to consider it stable.  We like it a lot,
and we hope you like it too.

We’ve taken care with the API to make it more pleasant to use, while still keeping the APIs that
worked well with Spool, so migration shouldn't be too painful (migration guide in appendix below).
We’ve also benchmarked it carefully, to ensure that we don’t regress–in fact, it should be faster
and entail less GC pressure than before.  We aren’t planning to deprecate Spool immediately, but
we’re targeting all new features and performance optimizations for AsyncStream, so if you’re a heavy
user of Spool, you should strongly consider migrating to AsyncStream.

# Appendix

## Perf

Here are the differences in microbenchmark results between AsyncStream and Spool, when trying to use
them as conduits for moving objects through.  The first one (like asyncStream) measures how fast an
operation is on average, and the second one (like asyncStream:·gc.alloc.rate.norm) measures how many
bytes are allocated per operation on average.  Lower is better.

```
                                    threads   score
asyncStream                               1   162.707  ±   39.933   ns/op
asyncStream:·gc.alloc.rate.norm           1   232.000  ±    0.001    B/op
spool                                     1   11.280   ±  324.364   ns/op
spool:·gc.alloc.rate.norm                 1   752.001  ±    0.003    B/op

asyncStream                               2   514.126  ±   87.914   ns/op
asyncStream:·gc.alloc.rate.norm           2   688.001  ±    0.003    B/op
spool                                     2   942.653  ±  111.403   ns/op
spool:·gc.alloc.rate.norm                 2   1344.001 ±   0.005     B/op

asyncStream                               5   1609.987 ±  718.745   ns/op
asyncStream:·gc.alloc.rate.norm           5   2248.003 ±    0.009    B/op
spool                                     5   2792.601 ± 1238.565   ns/op
spool:·gc.alloc.rate.norm                 5   3120.005 ±    0.019    B/op

asyncStream                              10   3214.592 ±  843.915   ns/op
asyncStream:·gc.alloc.rate.norm          10   4848.005 ±    0.016    B/op
spool                                    10   4235.138 ± 1448.331   ns/op
spool:·gc.alloc.rate.norm                10   6080.006 ±    0.020    B/op
```

As you can see, we have improvements across the board for every number of threads.


## Migration guide:
### Stream construction with Spool

```scala
import com.twitter.concurrent.Spool
import com.twitter.util.Future

// Construction from a materialized value
val result: String = "wonderful string" // materialized wonderful string
val spool: Spool[String] = result *:: Future.value(Spool.empty)

// Construction from a Future
def getString(): Future[String] = myService.getString("wonderful string") // gets a wonderful string
val unforced: () => Future[Spool[String]] =
  () => getString().map { string => string *:: Future.value(Spool.empty) }

// Construction from a Seq
val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val spool: Spool[String] = Spool.fromSeq(results)

// Construction from a function
def getNext(): Future[String] = myService.getNext()
def mkStream(): Future[Spool[String]] = getNext().map { string => string *:: mkStream() }
val unforced: () => Future[Spool[String]] = () => mkStream()
```

### Stream construction with AsyncStream

```scala
import com.twitter.concurrent.AsyncStream
import com.twitter.util.Future

// Construction from a materialized value
val result: String = "wonderful string" // materialized wonderful string
val spool: AsyncStream[String] = AsyncStream.of(result)

// Construction from a Future
def getString(): Future[String] = myService.getString("wonderful string") // gets a wonderful string
val unforced: () => AsyncStream =
  () => AsyncStream.fromFuture(getString())

// Construction from a Seq
val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val spool: AsyncStream[String] = AsyncStream.fromSeq(results)

// Construction from a function
def getNext(): Future[String] = myService.getNext()
def mkStream(): AsyncStream[String] = AsyncStream.fromFuture(getNext()) ++ mkStream()
val unforced: () => AsyncStream[String] = () => mkStream()
```

### Iteration with Spool

```scala
import com.twitter.concurrent.Spool
import com.twitter.util.Future

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val spool: Spool[String] = Spool.fromSeq(results)
spool.foreach { string => log.info(s"love to log my string $string") }

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val spool: Spool[String] = Spool.fromSeq(results)
val newSpool: Spool[Int] = spool.map { string => string.length }
```

### Iteration with AsyncStream

```scala
import com.twitter.concurrent.AsyncStream
import com.twitter.util.Future

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val stream: AsyncStream[String] = AsyncStream.fromSeq(results)
stream.foreach { string => log.info(s"love to log my string $string") }

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val stream: AsyncStream[String] = AsyncStream.fromSeq(results)
val newStream: AsyncStream[Int] = stream.map { string => string.length }
```

### Aggregation with Spool

```scala
import com.twitter.concurrent.Spool
import com.twitter.util.Future

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val spool: Spool[String] = Spool.fromSeq(results)
val fullyFolded: Future[String] = spool.foldLeft("") { (acc, item) => acc ++ item }

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val spool: Spool[String] = Spool.fromSeq(results)
def recursing(spool: Spool[String]): Future[String] = spool.headOption match {
  case Some(head) => if (head.length < 6) spool.tail.flatMap {
    next => recursing(next).map { rest => spool.head ++ rest }
  } else Future.value(head)
  case None => Future.value("")
}
val partiallyForced: Future[String] = recursing(spool)

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val spool: Spool[String] = Spool.fromSeq(results)
def split(item: String): Spool[String] = Spool.fromSeq(item.grouped(1).toSeq)
val result: Future[Spool[String]] = spool.flatMap { item => Future.value(split(item)) }
```

### Aggregation with AsyncStream

```scala
import com.twitter.concurrent.AsyncStream
import com.twitter.util.Future

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val stream: AsyncStream[String] = AsyncStream.fromSeq(results)
val fullyFolded: Future[String] = stream.foldLeft("") { (acc, item) => acc ++ item }

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val stream: AsyncStream[String] = AsyncStream.fromSeq(results)
def continue(next: String, acc: => Future[String]): Future[String] = if (next.length > 6) Future.value(next) else acc.map {
  string => next ++ string
}
val partiallyForced: Future[String] = stream.foldRight(Future.value(""))(continue _)

val results: Seq[String] = Seq("i", "have", "many", "wonderful", "strings") // many nice strings
val stream: AsyncStream[String] = AsyncStream.fromSeq(results)
def split(item: String): AsyncStream[String] = AsyncStream.fromSeq(item.grouped(1).toSeq)
val result: AsyncStream[String] = stream.flatMap(split)
```

[0]: https://github.com/luciferous
[1]: https://github.com/twitter/util/blob/develop/util-core/src/main/scala/com/twitter/concurrent/Spool.scala
[2]: https://github.com/twitter/util
[3]: https://github.com/twitter/util/blob/develop/util-core/src/main/scala/com/twitter/concurrent/AsyncStream.scala

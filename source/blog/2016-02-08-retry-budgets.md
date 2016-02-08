---
layout: post
title: Retry Budgets
published: true
post_author:
  display_name: Kevin Oliver
  twitter: kevino
tags: Finagle, Resiliency
---

Ever had your service attacked by a retry storm from your clients? Or
your clients’ clients? Or has your service ever been the attacker in
one of those situations?

Thought so.

To help you avoid this, in release 6.31 we’ve introduced the notion of
a [`RetryBudget`](https://github.com/twitter/finagle/blob/develop/finagle-core/src/main/scala/com/twitter/finagle/service/RetryBudget.scala)
that controls when it is okay for a client to retry a failed request.

The default budget allows for 20% of requests to be retried on top of
a minimum of 10 retries per second. This is built on top of a token
bucket where credits expire after 10 seconds. In practice this should
allow for plenty of retries in the face of transient errors without
causing cascading failures when there are persistent issues.

Developers can wire up their own budget:

```scala
import com.twitter.finagle.Http
import com.twitter.finagle.service.{Retries, RetryBudget}

val budget: RetryBudget = ???

val twitter = Http.client
  .configured(Retries.Budget(retryBudget = budget))
  .newService("twitter.com")
```

The following code shows how to use the factory method
`RetryBudget.apply` in order to construct a custom instance of
`RetryBudget`:

```scala
import com.twitter.conversions.time._
import com.twitter.finagle.service.RetryBudget

val budget: RetryBudget = RetryBudget(
  ttl = 10.seconds,
  minRetriesPerSec = 5,
  percentCanRetry = 0.1
)
```

The `RetryBudget` factory method takes three arguments:

1. `ttl` — a time to live for deposited tokens
2. `minRetriesPerSec` — the minimum rate of retries allowed
3. `percentCanRetry` — the percentage of requests that might be retried

`RetryBudgets` are wired up to `RetryFilter` and `RetryExceptionsFilter`
which allows them to be used outside of a Finagle client as well.
Further details on retries and retry budgets are covered in the
[user guide](http://twitter.github.io/finagle/guide/Clients.html#retries).

Please let us know if you have any questions, either by filing a GitHub issue or
getting in touch through [@finagle](https://twitter.com/finagle) or the
[Finaglers mailing list](https://groups.google.com/forum/#!forum/finaglers).

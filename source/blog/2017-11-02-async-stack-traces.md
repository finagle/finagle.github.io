---
layout: post
title: 🛠️ Introducing Twitter Futures Capture Points
published: true
post_author:
  display_name: Stefan Lance
  twitter: stefan_lance
tags: Util, IntelliJIDEA
---

If you've ever tried to debug asynchronous code written with Twitter [`Future`](https://github.com/twitter/util/blob/develop/util-core/src/main/scala/com/twitter/util/Future.scala)s, 
you may have found that the stack trace isn't always helpful. The stack trace
at a given point in the program includes the active stack frames and thus shows
the chain of function calls that led up to that point. Since asynchronous
execution causes different parts of a program to have their stack traces chopped
up, the stack trace often shows unexpected internal library calls and is missing
the causality developers are used to from synchronous code. As a result, the
context leading to the current stack frame is lost.

IntelliJ 2017.1 included a feature called [Capture Points](https://blog.jetbrains.com/idea/2017/02/intellij-idea-2017-1-eap-extends-debugger-with-async-stacktraces/).
This feature lets us stitch together stack frames so that the order of functions
in the stack trace respects the order in which they were called.

Our summer intern, [Haggai Kaunda](https://twitter.com/McKardah), wrote capture
points specific to Twitter [`Future`](https://github.com/twitter/util/blob/develop/util-core/src/main/scala/com/twitter/util/Future.scala)s 
(thanks, Haggai!). Using these can make debugging asynchronous code written
with Twitter `Future`s simpler by providing more informative stack traces.

Note that as of November 2017, the capture points are guaranteed to work with
only Scala 2.11. We are not working on capture points for 2.12 at this time;
if you would like to help make this feature available for more users, you can
submit a pull request on [util's GitHub repo](https://github.com/twitter/util).

To start using, you can grab the capture points XML file [directly from GitHub](https://raw.githubusercontent.com/twitter/util/develop/util-intellij/src/main/resources/util-intellij/TwitterFuturesCapturePoints.xml),
and after our next release it will be available as an artifact published to
Maven Central.

## Setup

The capture points are defined in [TwitterFuturesCapturePoints.xml](http://github.com/twitter/util/util-intellij/src/main/resources/util-intellij/TwitterFuturesCapturePoints.xml).
To import them into IntelliJ,

1. Open IntelliJ. In the menu bar, click IntelliJ IDEA > Preferences.
2. Navigate to Build, Execution, Deployment > Debugger > Async Stacktraces.
3. Click the Import icon on the bottom bar. Find the XML file and click OK.

## Use

Set a breakpoint where you wish to see the stack trace, debug your code, and 
look at the "Frames" tab in the Debugger. Any asynchronous calls in the stack
trace will appear in logical order. If you wish to clean up the stack trace,
click the funnel icon in the top right, "Hide Frames from Libraries".

## Example

We will illustrate how to use the capture points to assist with debugging with a
[small example](https://github.com/twitter/util/blob/develop/util-intellij/src/test/scala/com/twitter/util/capturepoints/Demo.scala)
written by [Kevin Oliver](https://twitter.com/kevino) (thanks, Kevin!).

A brief explanation of this test: the test passes a [`Promise[Int]`](https://github.com/twitter/util/blob/develop/util-core/src/main/scala/com/twitter/util/Promise.scala)
through three methods and then sets the `Promise`’s value in a `futurePool`.
The calls are asynchronous, but the logical flow of the test is as follows:

1. `test` block calls `someBusinessLogic`
2. `someBusinessLogic` calls `moreBusinessLogic`
3. `moreBusinessLogic` calls `lordBusinessLogic`
4. `lordBusinessLogic` waits for the `Promise`’s value to be set
5. The `Promise`’s value is set in the test block (this could happen at any
   time; it is not necessarily step number 5)
6. `lordBusinessLogic` returns
7. `test`’s `result` variable is `4`, and the test passes

Suppose we wish to inspect the stack trace from inside `lordBusinessLogic`. If 
we set a breakpoint at line 47 and then debug the test in IntelliJ with the
capture points disabled, we see the following stack trace:

```
apply$mcVI$sp:47, Demo$$anonfun$lordBusinessLogic$1
apply:1820, Future$$anonfun$onSuccess$1
apply:205, Promise$Monitored
run:532, Promise$$anon$7
run:198, LocalScheduler$Activation
submit:157, LocalScheduler$Activation
submit:274, LocalScheduler
submit:109, Scheduler$
runq:522, Promise
updatelfEmpty:880, Promise
update:859, Promise
setValue:835, Promise
apply$mcV$sp:20, Demo$$anonfun$3$$anonfun$apply$1
apply:15, Try$
run:140, ExecutorServiceFuturePool$$anon$4
```

The library calls in the stack trace do not help us understand our code. If we
enable the capture points and again debug the test, we see the following stack
trace:

```
apply$mcVI$sp:47, Demo$$anonfun$lordBusinessLogic$1
apply:1820, Future$$anonfun$onSuccess$1
onSuccess:1819, Future
lordBusinessLogic:42, Demo
moreBusinessLogic:38, Demo
someBusinessLogic:31, Demo
apply:17, Demo$$anonfun$3
```

This is much cleaner and it includes only calls to functions we wrote. It lets
us clearly see that the test block called `someBusinessLogic`, that
`someBusinessLogic` called `moreBusinessLogic`, and that `moreBusinessLogic`
called `lordBusinessLogic`.

## That's all!

Please let us know if you have any questions via [@finagle](http://twitter.com/finagle),
the [Finaglers mailing list](https://groups.google.com/forum/#!forum/finaglers), or
[chat](https://gitter.im/twitter/finagle).

Happy debugging!

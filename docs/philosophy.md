# Development Philosophy

This page documents the philosophy I hold around software development. That
might sound a bit odd at first, but all of us have a worldview that influences
how we see and interact with the world around us. Software is no exception to
this, and as developers, we tend to inherit our philosophy around how we develop
software, whether we know it or not.

This page is subject to rapid change as my philosophy and understanding
continues to grow.

## Free is Better

A tried and true philosophy I've developed over the years is that humans are
naturally lazy. When presented with two competing options, one which requires
more labor and one which requires less, with the same perceived result, a person
will almost always choose the latter option. Even if the former yields a
slightly better result, it must have enough inertia behind it to overcome this
nature. This nature isn't necessarily a bad thing; it has been at work since
early civilizations started to be built and has been a significant fuel source
for driving innovation and advancements.

When it comes to dealing with this nature when making choices, we have three
options:

1. We can brute force it and always pick the right choice.
1. We can encode the right choice into our subconscious through habit.
1. We can encode the right choice into something external.

The first option is valid but not ideal as it requires the most work and is,
therefore, the least likely to be consistent. The second option is a bit more
viable as the power of habit can easily overwhelm this nature (for a great book
on this, see James Clear's [Atomic Habits][01]). However, it can take up to
three months to develop a habit, and lack of discipline, in the beginning, can
negate the whole effort. The third option is where I have landed in my
philosophy, choosing to encode the right choice into something external whenever
possible.

A case study to prove my point: In 1883, James Ritty invented the cash register.
Ritty was a bar owner and was a frequent victim of theft by his employees. While
traveling on a ship, Ritty had an idea after witnessing a device that counted
the revolutions of the ship propeller. Upon returning home, he began working
with his brother to develop the first cash register. The idea was simple: it
kept a running total of all transactions and would ring a bell when an employee
opened the cash drawer. He immediately saw a significant decrease in employee
theft. He encoded the right choice into an external device.

I don't mean to be critical, but as developers, I've found that this nature is
even more robust in us when compared to our contemporaries. Perhaps it has
something to do with what drew us towards programming to begin with - finding a
way to reduce the toil in our daily lives. As such, I believe the yield from
option three is even more significant in the context of software development.

### Encoding Best Practices

> A good developer uses best practices, a great developer automates them.

This brings us to my first primary philosophical view of software development:
we should always work to encode best practices into our daily tools.

There's a hidden relationship between the second and third options discussed in
the section above. It's easiest to see with an example. One of the best
practices developers like to employ is meaningful commit messages. Adopting this
single change can significantly improve the git history, make git blame more
effective, and even improve generating the dreaded CHANGELOG. A good way to
encode this best practice is by using a git hook (preferably with a tool like
[pre-commit][02] or [husky][03]) which can validate a commit message before
allowing it to go through. The benefits of this approach are many:

1. It doesn't interrupt the existing flow of development but instead attaches
   itself to a current operation that we use multiple times a day.

1. The feedback loop is fast. I type `git commit`, and I get instant feedback on
   the quality of my commit message.

1. It forms a natural entry point for learning. New developers will slowly learn
   the proper way to format git commit messages as they go through the feedback
   loop every day.

It's the last benefit that brings us back to the original point: option #2 is
practical because there's scientific evidence that habits are some of the most
powerful forces we employ in our day-to-day life. Encoding best practices in our
tooling will naturally, over time, encode that best practice into our
subconscious. After three months of going through the pre-commit feedback loop,
it's very likely that the hook could be removed, and a developer would continue
to employ the best practice taught by the feedback loop. Thus, in some cases,
the third option can leverage the inherent power found in habit building.

### No Blame Culture

> A no-blame culture helps create an environment where individuals feel free to
> report errors and help the organization to learn from mistakes ([ref][04]).

My second primary philosophical view on software development is closely related
to the first: encoding best practices into our tooling can lead to the
development of a no-blame culture. The benefits of this type of culture are
widely documented; namely, in mission-critical environments where errors are
most catastrophic, this type of culture promotes identifying and fixing these
errors before they turn disastrous.

By defaulting to the view that best practices should be encoded into our tools,
we can quickly begin to shift our perspective of human mistakes. Let's look at a
theoretical example: Sally is a new developer. She recently joined the team and
has been given the responsibility of managing a small micro-service responsible
for customer invoices. One day, she makes a minor revision, runs all unit tests,
and pushes the change to the staging environment. This environment runs some
basic smoke tests on the service and, once passed, pushes the change to
production. Unfortunately, after several hours, an edge case occurs with a
customer invoice that takes down the entire service. Worse, an unnoticed
dependency between this service and other micro-services increases the blast
radius to the level of a major outage.

The company would likely fire Sally for missing this edge case in a blame
culture. The origin and nature of the cause of the outage is unlikely to be
investigated too much further as most of the blame has been placed on human
error.

In a no-blame culture, the origin of the blame is placed on the systems in place
that allowed the change to go through in the first place. Several questions are
asked:

1. Could this have been caught in a unit test?

1. Are smoke tests sufficient for this service? Why are there no E2E tests which
   can detect dependencies between the micro-services?

1. Is automatically pushing such a critical service to production a good idea?
   Should there be a second check encoded into the process before release?

At the root of all of these questions is that somewhere a system failed and
allowed a human mistake to go through. One of the most freeing experiences for a
the developer is to not only not receive the brunt of the blame in this
situation, but to also be empowered to fix the tooling that allowed such a
mistake to go through unnoticed.

### Reducing Cognitive Burden

> A reduction in cognitive load is proportional to gain in productivity.

The third and final primary philosophical idea on software development builds on
this idea of encoding best practices into automation. One of the significant
problems with adopting best practices is that there are often simply too many of
them. Cognitive load is a precious resource for developers since all of our work
is cognitive by nature. There's no quicker way to kill productivity in a
developer than to overwhelm them cognitively.

Encoding best practices allow a developer to be free from the burden of
recalling and employing a given best practice in the correct context. The
external tool will be responsible for enforcing it in the proper context and the
developer can build a sense of confidence that the code she produces will meet
these various criteria due to the systems that have been put in place.

The result of this practice is healthy developers who are not over-burdened with
rules and who can, in turn, be much more productive while producing software.

## Summary

Free is better. Encoding best practices into our tooling and automation can lead
to building more vital developer skills through the power of habit, a no-blame
culture, which empowers developers to report and fix errors, and a more
productive team which is free from the burden of having to remember the details
around when and how to employ a best practice.

Humans are naturally lazy. We can try to fight this fact of life through brute
force, or we can embrace it by taking the alternative approach of automation.

[01]: https://jamesclear.com/atomic-habits
[02]: https://pre-commit.com
[03]: https://typicode.github.io/husky/#/
[04]: https://en.wikipedia.org/wiki/Just_culture

# Introduction

This section of the handbook documents the general environment I use for
day-to-day development. General meaning that the documented environment and
practices span multiple languages. For language specific environment details,
refer to the appropriate language section.

## Philosophy

Over the years I've found that developers generally fall within two major
categories when it comes to the tooling they use in development:

1. Novice developers tend to gravitate towards collecting dozens of tools and
   are generally prone to fear of missing out (FOMO). The primary cause of this
   is the consumption of media as they learn development and which, like the
   main stream media, generally follows the latest trends.

1. More experienced developers have had enough time to experience the backhand
   of developing with the *latest and greatest* of tooling. They tend to push
   back against the latest trends and have, over the years, fine-tuned their
   portfolio to what works best for them.

The above is not intended to patronize either group - it's simply an observation
that has been made over the years. When it comes to my development environment,
I apply a philosphy I've developed in my personal life called *the radical
center*. The idea is that humans are generally lazy and will gravitate towards
extremes in order to avoid the work of finding the center. It's much easier to
identify with one philosophy and stick with it dogmatically then attempt to
constantly refine your thoughts and views on the matter at hand.

This principle, when applied to my environment, tends to lead me towards the
center of the two categories documented above. Like many others, my experience
in development has led me to realize there is a large productivity cost in
always using the *latest and greatest*. There's the cost of constantly ingesting
the amount of content necessary to stay abreast of the latest trends, the cost
of constantly evaluating the trends to your current setup, and the cost of
trying to maintain often immature tools. On the other hand, there's a cost to
being too dogmatic when it comes to embracing the changing landscape. In the
never-ending stream of new tools and technologies, there are many gems that are
sometimes hidden and which, when found, provide an immediate positive impact to
productivity. While the head in the sand approach serves to save a lot of time
and headache, it's simply the other extreme and has its own share of faults.

Taking the above into account, I often try to land in the radical center of the
two positions. I don't bar myself from ingesting content from popular social
platforms, but I also have a very healthy respect for the danger involved in
doing so.

## Guidelines

In line with the above philosphy, I've attempted to distill the following
guidelines when it comes to building my development environment:

1. [Minimalism outweighs maximalism](#minimalist).
1. [Integration can balance the min/max equation](#integrated).
1. [New software often outweighs the productivity increase](#tested).
1. [Poorly documented tooling should be avoided](#documented).
1. [Security is important](#secure).

### Minimalist

Minimalism outweighs maximalism. The cognitive burden required to maintain a
large set of tools is often not worth the benefit being added by them. When
evaluating a new tool, prefer being biased against it and, if adopted, prefer
replacing an existing tool rather than adding it to the portfolio of tools.

### Integrated

Integration can balance the min/max equation. If the cognitive burden of a tool
can be offloaded by integration then in some cases the first guideline can be
reversed. When evaluating a new tool, determine if it can be adequately
integrated into existing automation. Does it have an API or CLI interface?
Perhaps it already integrates with an existing tool (i.e. Github Actions).

### Tested

The burden of new software often outweighs the productivity increase. When
evaluating a new tool, prefer to be biased towards established solutions which
have seen many developement cycles and been tested in production environments. A
metric often used to measure this is performing a Google search of the tool.
Mature tools often have plenty of third-party content covering it.

### Documented

Poorly documented tooling should be avoided. When evaluating a new tool, prefer
to discard tools which lack sufficient documentation. Exploratory
troubleshooting is a huge time sync and should be avoided if possible. When
something breaks it's much easier to have a single source of truth for
troubleshooting.

### Secure

Security is important. Tools which are not adequately tested can, overtime, add
up to producing an insecure environment. When evaluating a new tool, prefer
tools which adopt security best-practices such as encryption, multi-factor
authentication, and high visibility into what's going on underneath the hood.

The desired result of the above guidelines is an environment which is not overly
dogmatic about what it contains but is also highly critical of how it evolves
over time.

## Principles

Below are the principles used in actually building my environment:

1. [It should be automated](#automation).
1. [It should stay out of the way](#seamless).
1. [It should be maintainable](#maintainable).
1. [It should be secure](#security).
1. [It should promote best practices](#best-practices).

### Automation

It should be automated. The environment should prefer automation where possible.
Like lego-blocks, the tools should be put together in such a way that they
create a pipeline which executes from start to finish without much thought from
me.

### Seamless

It should stay out of the way. The word seamless is being jeopardized of
becoming a buzzword, but in this case it best fits the meaning here. My normal
workflow of writing, testing, comitting, and pushing code should not require
frequent interruptions in order to deal with the supporting tools. This is not
to be confused with troubleshooting - Murphy's Law is persistent and there's
always going to be a cost of maintaing the environment. However, when things are
working as expected, they should do so by being practically invisible to my
day-to-day work.

### Maintainble

It should be maintainable. A direct consequence of automation is the natural
building of a complex system of interlocking parts that is almost impossible to
troubleshoot. Such an environment should be actively avoided. A key to
accomplishing this is thorough documentation as well as automated testing of
tools where applicable.

### Security

It should be secure. Suprisingly, source code and automation workflows are still
one of the top sources for security breaches in companies. While developing
security-minded habits is critical (i.e. hardware token over a software one),
the environment shouldn't enable easily leaking sensitive information. The
easiest way to accomplish this is through scanning, however, the most effective
is making storing and accessing secrets in a development environment as easy as
possible (again, humans are lazy).

### Best Practices

It should promote best practices. Remembering all of the best practices,
especially language specific ones around organization/packaging, can be a huge
cognitive burden. Instead of remembering these, they should be built into the
environment in such a way that it naturally promotes them. For example, a simple
pre-commit check on a git commit message can help to remind me to stick to a
consistent format in my commits.

## Hardware

It's worth documenting the current hardware I use for development, primarily for
others who may be perusing these guides. All of my development happens on a
single machine. This comes from another philosophy I employ of *partioning*
which helps the brain to associate physical things with certain activities.

- **Model**: MacBook Pro 16 (2021)
- **CPU**: Apple M1 Max
- **Memory**: 64 GB
- **OS**: macOS Monterey (v12.1)

# Performance Methodologies

This section outlines common methdologies that can (and should) be used when
doing system performance related work. It is not an exhaustive list and
primarily includes methodologies that I've found to be useful over the years.

## Problem Statement

This is the first methodology that should be used when beginning performance
related investigations. It consists of asking a series of questions, usually
directed at the person who noticed the issue, in order to quickly rule out the
need to investigate further.

1. What makes you think there is a performance problem?
1. Has this system ever performed well?
1. What changed recently? Software? Hardware? Load?
1. Can the problem be expressed in terms of latency or runtime?
1. Does the problem affect other people or applications (or is it just you)?
1. What is the environment? What software and hardware are used?

## USE Method

The USE method provides a framework for identifying system bottlenecks. It is an
acronym which combines the following terms:

- **U**tilization: The percentage of time that the resource was busy servicing
  work.
- **S**aturation: The degree to which the resource has extra work that it can't
  service, often waiting on a queue.
- **E**rrors: The count of error events.

The USE method is iterative: it should be applied for each resource identified
as a potential bottleneck in the system.

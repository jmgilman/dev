# Performance Analysis

Performance analysis can be broken down into two categories: *resource analysis*
and *workload analysis*.

## Resource Analysis

Resource analysis can be considered the *bottom-up approach* where analysis
begins at the physical (hardware) levels and travels upward. It is most often
used in troubleshooting to pinpoint problem resources and also in capacity
planning to determine which resources are most likely to be contested.

The following metrics are most often measured when doing resource analysis:

- IOPS
- Throughput
- Saturation
- Utilization

## Workload Analysis

Workload anaylsis can be considered the *top-down approach* where analysis
begins at the software level and travels downward. It is most often used to
identify and resolve software related bugs and issues.

The following metrics are most often measued when doing workload analysis:

- Requests (the workload applied)
- Latency (the response time of the application)
- Completion (looking for errors)

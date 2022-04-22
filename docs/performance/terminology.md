# Performance Terminology

This page contains definitions for common terminoloy used when discussing the
art of systems performance. Some words, in particular, already contain an
abundance of meanings, and it's important to distinguish which is being used
when discussing performance engineering.

| Term              | Definition                                                                              |
| ----------------- | --------------------------------------------------------------------------------------- |
| Architecture      | The software configuration and hardware on which an application runs.                   |
| Bottleneck        | A resource that limits the performance of the system.                                   |
| Caching           | Storing the results from a slower storage tier in a faster storage tier, for reference. |
| IOPS              | Input/output operations per second (read/writes per second for disks).                  |
| Latency\[^1\]     | A measure of time an operation spends waiting to be serviced.                           |
| Profiling         | The building of a picture of a target that can be studied and understood.               |
| Response Time     | The time for an operation to complete.                                                  |
| Saturation        | The degree to which a resource has queued work it cannot service.                       |
| Scalability       | The performance of the system under increasing load.                                    |
| Throughput        | The rate of work performed.                                                             |
| Utilization\[^2\] | How busy a resource is.                                                                 |
| Workload          | The input to the system or the load applied.                                            |

\[^1\]: This specific term can be ambigious without qualifying information; it's
better to quantify it with additional terms (i.e. TCP connection latency)
\[^2\]: Utilization can be time-based or capacity based: the average amount of
time a resource is busy vs the utilization of a certain percent of total
resource capacity (i.e. disk I/O usage vs disk capacity usage).

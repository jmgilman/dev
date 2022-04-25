# Linux in 60 Seconds

This table provides a methodology for quickly iterating through performance
metrics of a typical Linux system with the goal of quickly identifying
bottlenecks.

| Tool                | Rationale                                                                                            |
| ------------------- | ---------------------------------------------------------------------------------------------------- |
| `uptime`            | Load averages to identify if load is increasing or decreasing (compare 1, 5, and 15 minute averages) |
| \`dmesg -T          | tail\`                                                                                               |
| `vmstat -SM 1`      | System-side statistics: run queue length, swapping, overall CPU usage                                |
| `mpstat -P ALL 1`   | Per-CPU balance: a single busy CPU can indicate poor thread scaling                                  |
| `pidstat 1`         | Per-process CPU usage: identify unexpected CPU consumers, and user/system CPU time for each process  |
| `iostat -sxz 1`     | Disk I/O statistics: IOPS and throughput, average wait time, percent busy                            |
| `free -m`           | Memory usage including the file system cache                                                         |
| `sar -n DEV 1`      | Network device I/O: packets and throughput                                                           |
| `sar -n TCP,ETCP 1` | TCP statistics: connection rates, retransmits                                                        |
| `top`               | Check overview                                                                                       |

## uptime

The `uptime` command is primarily used to get a quick glance at system load
averages to quickly understand the characteristics of the current load (i.e.
spurious or long-term). The three load average numbers represent 1-minute,
5-minute, and 15-minute intervals respectively.

In Linux, load average refers to system-wide demand of CPUs, disks, and other
key resources. Load is measured as the current resource usage (utilization) plus
the queued requests (saturation). The average is an exponentially damped moving
average.

Note that if the load averages are decreasing (i.e. 15 > 5 > 1), it's possible
the sought after event has already occurred and not repeated itself. This helps
to identify where in the timeline to pay attention.

## dmesg

Tailing the kernel ring buffer is helpful for quickly orienting yourself to
where the bottleneck might be located. While this practice may not always
produce usable results, it can quickly show memory pressure through OOM errors
which can reduce the time needed to locate the issue.

## vmstat

The below tables can help in understanding the output.

### Procs

| Column | Description                                                        |
| ------ | ------------------------------------------------------------------ |
| `r`    | The number of runnable processes (running or waiting for run time) |
| `b`    | The number of processes waiting for I/O to complete                |

The `r` column can also be referred to as the run-queue length.

### Memory

| Column  | Description                                 |
| ------- | ------------------------------------------- |
| `swdp`  | The amount of swapped memory used           |
| `free`  | The amount of idle memory                   |
| `buff`  | The amount of memory used as buffers        |
| `cache` | The amount of memory used as cache (paging) |
| `si`    | The amount of memory swapped in from disk   |
| `so`    | The amount of memory swapped to disk        |

In most Linux systems, `free` will be relatively small and most of the usable
memory will be allocated to the page cache (`cache`). This is an intentional
design philosophy which prefers utilizing free RAM instead of letting it be
wasted. The `-a` flag can be included which breaks up the page cache into
inactive and active memory.

The buffer cache is used for block device caching whereas the page cache is used
for general file system caching (most modern systems have the buffer cache
contained within the page cache).

If the `si` and `so` values are constantly in flux, it indicates that memory
swapping is occurring and indiciates memory pressure is being applied.

### IO

| Column | Description                                    |
| ------ | ---------------------------------------------- |
| `bi`   | Blocks received from a block device (blocks/s) |
| `bo`   | Blocks sent to a block device (blocks/s)       |

A large increase in either one of these values can indicate a process is writing
or reading a large amount of data to disks (which can show up as load).

### System

| Column | Description                                              |
| ------ | -------------------------------------------------------- |
| `in`   | The number of interrupts per second, including the clock |
| `cs`   | The number of context switches per second                |

### CPU

| Column | Description                                                         |
| ------ | ------------------------------------------------------------------- |
| `us`   | Time spent running non-kernel code (user time, including nice time) |
| `sy`   | Time spent running kernel code (system time)                        |
| `id`   | Time spent idle                                                     |
| `wa`   | Time spent waiting for IO                                           |
| `st`   | Time stolen from a virtual machine                                  |

## mptstat

The following tables documents the columns resulting from this command:

| Column    | Description                                    |
| --------- | ---------------------------------------------- |
| `CPU`     | Logical CPU ID, or `all` for summary           |
| `%usr`    | User-time, excluding `%nice`                   |
| `%nice`   | User-time for processes with a nice'd priority |
| `%sys`    | System-time (kernel)                           |
| `%iowait` | I/O wait                                       |
| `%irq`    | Hardware interrupt CPU usage                   |
| `%soft`   | Software interrupt CPU usage                   |
| `%steal`  | Time spent servicing other tenants             |
| `%guest`  | CPU time spent in guest virtual machines       |
| `%gnice`  | CPU time to run a niced guest                  |
| `%idle`   | Idle                                           |

Of note are the `%usr`, `%sys`, and `%idle` columns which can indiciate the
ration between user/kernel CPU usage. Additionally, a single hot CPU (`%usr` +
`%sys`) can indicate a large single-threaded workload.

## pidstat

This tool presents CPU utilization information as broken down by process. By
default it only shows active (non-idle) processes. Passing the `-p ALL` flag
will instead force it to show statistics for all processes.

The `-d` flag converts the output to reflect disk I/O statistics instead.

## iostat

This tool provides per-disk I/O statistics. By default, without any additional
flags or arguments, a summary-since-boot for CPU and disk statistics is printed.
The following table details the short extended (`-sx`) columns presented:

| Column    | Description                                                                                        |
| --------- | -------------------------------------------------------------------------------------------------- |
| `Device`  | The device (or partition) name as listed in /dev                                                   |
| `tps`     | Transactions per second (IOPS)                                                                     |
| `kB/s`    | Kbytes per second                                                                                  |
| `rqm/s`   | Requests queued and merged per second                                                              |
| `await`   | Average I/O response time, including time queued in the OS and the I/O response time of the device |
| `aqu-sz`  | Average number of requests both waiting in the driver request queue and active on the device       |
| `areq-sz` | Average request size in Kbytes                                                                     |
| `%util`   | Percent of time the device was busy processing I/O requests (utilization)                          |

The most important metric in terms of delivered performance is `await`. What
values constitutes good or bad is subjective depending on the workload. A high
`await` can be caused by queueing, larger I/O sizes, random I/O on rotational
disks, and device errors.

Nonzero counts in `rqm/s` indiciate a sequential workload. Small-sizes in
`areq-sz` indicate a random I/O workload.

By omitting the `-s` flag, the columns are further broken down by read/writes.
This can be helpful, especially considering writes are less impactful (due to
write-back caching) and can otherwise skew the aggregated value.

## free

This tool provides summarized information about memory usage. Most of these
statistics reside in `vmstat`, however, of particular note is the `available`
column which indiciates how much memory is available for reclamation,
specifically memory being used in the cache which can be released (i.e. not
dirty).

## sar

This tool is very configurable and can provide a wide spectrum of data. The full
breadth of what is possible is too much to detail here, refer to `man sar` for
more details.

## top

This is likely the most popular tool used by beginners for investigating the
performance state of a machine. Of note is the `%CPU` column which shows CPU
usage percentage (not normalized, meaning not average over all CPUs), and the
`TIME+` column which shows total CPU usage time.

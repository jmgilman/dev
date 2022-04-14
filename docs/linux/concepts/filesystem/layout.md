# Linux Filesystem Layout

The contents of this page have primarily been adapted from the
[Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html).
It briefly summarizes key concepts and material that is necessary to understand
when administrating Linux systems which fully (or even partially) adhere to the
FHS standard.

## Partitioning

The FHS recommends that the root partition be kept as small as possible in order
to:

1. Allow mounting it from small media
1. Separating specific system files (i.e. kernel) from more sharable files
1. To not assume that other individuals have large root partitions
1. To reduce the surface area of disk errors impacting the root partition

## Structure

The follow directories (or symlinks) are required:

| Directory | Description                                       | Link                                                                  |
| --------- | ------------------------------------------------- | --------------------------------------------------------------------- |
| bin       | Essential command binaries                        | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s04.html) |
| boot      | Static files of the boot loader                   | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s05.html) |
| dev       | Device files                                      | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s06.html) |
| etc       | Host-specific system configuration                | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s07.html) |
| lib       | Essential shared libraries and kernel modules     | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s09.html) |
| media     | Mount point for removable media                   | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s11.html) |
| mnt       | Mount point for mounting a filesystem temporarily | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s12.html) |
| opt       | Add-on application software packages              | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s13.html) |
| run       | Data relevant to running processes                | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s15.html) |
| sbin      | Essential system binaries                         | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s16.html) |
| srv       | Data for services provided by the system          | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s17.html) |
| tmp       | Temporary files                                   | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s18.html) |
| usr       | Secondary hierachy                                | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04.html)    |
| var       | Variable data                                     | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch05.html)    |

The following directories (or symlinks) are optional:

| Directory | Description                      | Link                                                                  |
| --------- | -------------------------------- | --------------------------------------------------------------------- |
| home      | User home directories            | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s08.html) |
| root      | Home directory for the root user | [Link](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s14.html) |

In particular, there's a growing convention for using the XDG Base Directory
Specification for creating the `home` directory layout. See the specification
[here](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

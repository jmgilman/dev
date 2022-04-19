# IP Addressing

## Basic Design

When designing an IPv4 network, the primary goals are usually the following:

1. To meet the current needs of the network
1. To provide space for future growth
1. To waste as few resources as possible

The primary way this is acheived is through proper use of subnetting. Perhaps
the easiest methodology is to remember this rule:

> The number of host IP addresses on a network is 2^N - 2, where N is the number
> of host bits

In other words, a subnet with 6 host bits would have 2^6-2 IP addresses
available, a total of 62 addresses. With this rule, when approaching how to
design a subnet for a specific environment, asking what the current need in
terms of address space is and how much is it expected to grow can take you very
far.

Some common pitfalls are as follows:

- Point-to-point connections between routers need 2 addresses
- Network devices which need to be managed remotely also need addresses

When designing subnets, most engineers will tend to use a single subnet across
all networks (i.e. /24). While variable length subnet masks (VLSM) were popular
for a time, with advent of mostly private netwokring utilizing NAT, there's
often little reason to be as precise with subnet masks.

The simplest way to achieve this is to examine all required networks, find the
one with the largest number of hosts required, determine a subnet for it, and
then apply that subnet across all other networks.

However, this is not as straight-forward as it may seem: at one of the scale you
must balance the total number of subnets needed and at the other end you need to
balance the number of hosts available in each subnet. Mathemtically speaking:

- 2^S >= total number of subets (where S is the number of subnet bits)
- 2^H >= total number of hosts (where H is the number of host bits)

## Network Classes

The IPv4 standard specifies five network classes:

| Class | First Octet Value | Purpose                        |
| ----- | ----------------- | ------------------------------ |
| A     | 1-126             | Unicast (large networks)       |
| B     | 128-191           | Unicast (medium networks)      |
| C     | 192-223           | Unicast (small networks)       |
| D     | 224-239           | Multicast                      |
| E     | 240-255           | Reserved (formly experimental) |

The below table documents common facts for the three most common classes (A-C):

| Fact                          | Class A           | Class B               | Class C                 |
| ----------------------------- | ----------------- | --------------------- | ----------------------- |
| First octet range             | 1-126             | 128-191               | 192-223                 |
| Valid network numbers         | 1.0.0.0-126.0.0.0 | 128.0.0.0-191.255.0.0 | 192.0.0.0-223.255.255.0 |
| Total networks                | 2^7 - 2 = 126     | 2^14 = 16,384         | 2^21= = 2,097,152       |
| Hosts per network             | 2^24 - 2          | 2^16 - 2              | 2^8 - 2                 |
| Octets (bits) in network part | 1 (8)             | 2 (16)                | 3 (24)                  |
| Octets  (bits) in host part   | 3 (24)            | 2 (16)                | 1 (8)                   |
| Default mask                  | 255.0.0.0         | 255.255.0.0           | 255.255.255.0           |

### Private Network Classes

When dealing with private IP networks, there are three classes:

| Class | Private IP Networks         | Number of Networks |
| ----- | --------------------------- | ------------------ |
| A     | 10.0.0.0                    | 1                  |
| B     | 172.16.0.0 - 172.31.0.0     | 16                 |
| C     | 192.168.0.0 - 192.168.255.0 | 256                |

The most common in enterprise networks is class A. While the 16 million
addresses it provides may seem unecessary, there's no penalty to using a class A
private network and the benefit for supporting growth is essentially free.

## Subnetting

A key to help understanding subnets is that they ultimately consist of binary
values where a 1 indiciates the network portion of a subnet and a 0 represents
the host portion of the subnet.

All hosts in a subnet share a common network portion, however, the host portion
must be unique. Viewed this way, some of the below rules start to make more
sense; using the previous mask, the total possible hosts in the subnet would be
2^24 (24 host bits), minus the network address and broadcast address.

Additionally, subnet masks can be represented in three ways, however, all three
ways can be translated between each other using the above concepts.

Assuming a mask of 11111111.00000000.00000000.00000000:

- The dotted decimal notation (DDN) simply converts each octet into its decimal
  equivalent: 255.0.0.0
- The CIDR prefix simply counts the number of network bits (1's) and then adds a
  slash before it: /8

The DDN conversion is a bit tricky: since we're dealing with octets, the easiest
methodology is to go from right to left, starting from 255, and subtracting the
0's: 11110000 would be 255 - 1 - 2 - 4 - 8 = 240. You could also just do normal
right-to-left addition.

Since subnets cannot interleave 1's and 0's, and the 1's must always come before
the 0's, there's technically only a small number of potential values in a single
octet. Thus, it's feasible to simply memorize these values to make calculations
more efficient:

| Binary Mask Octet | Decimal Equivalent |
| ----------------- | ------------------ |
| 00000000          | 0                  |
| 10000000          | 128                |
| 11000000          | 192                |
| 11100000          | 224                |
| 11110000          | 240                |
| 11111000          | 248                |
| 11111100          | 252                |
| 11111110          | 254                |
| 11111111          | 255                |

### Subnet Masking Calculations

A subnet mask, as its core, simply defines the dividing line between the network
prefix bits and the host bits. For example, a /24 mask puts the dividing line
such that the first 24 bits are the prefix and the remaining 8 bits are the host
bits. This concept is referred to as *classless addressing*\*. Its counterpart,
*classful addressing*, simply divides the network prefix in half: one half is
the class prefix and the other part is the subnet prefix, for a total of three
parts.

Regardless of the approach, you only need two parts to determine a few basic
characteristics about a subnet:

- **Number of hosts**: 2^H - 2 where H is the number of host bits
- **Number of subnets**: 2^S where S is the number of prefix (subnet) bits

A *classful addressing* example:

- We have the following mask: 8.1.4.5 255.255.0.0
- The CIDR prefix for this would be 8.1.4.5/16
- This is a class A network, so the class prefix is 8
- The subnet prefix is the CIDR prefix minus the class prefix: 16 - 8 = 8
- The host bits is 32 minus the CIDR prefix: 32 - 16 = 16
- The number of hosts is 2 raised to the host bits: 2^16 = 65,534
- The number of subnets is 2 raised to the subnet prefix: 2^8 = 256

The most common calculation is one which takes an IP address and subnet mask and
determines the subnet ID and broadcast address. This is possible with a firm
understanding of the concepts detailed in the previous section. For example,
assuming the following address: 172.16.150.41/18

- Convert the IP address to binary: 10101100 00010000 10010110 00101001
- Convert the prefix to binary: 11111111 11111111 11000000 00000000
- Using the above prefix, set the host bits of the IP address to 0: 10101100
  00010000 10000000 00000000
- Convert the result to DDN: 172.16.128.0 is the subnet ID
- Using the same prefix, set the host bits of the IP address to 1: 10101100
  00010000 10111111 11111111
- Conver the result to DDN: 172.16.191.255 is the broadcast address

While this process is closest to resembling what is actually happening
underneath the hood, it's also time-consuming and typically cannot be done
without pen and paper. A simpler methodology takes advantage of a few rules:

- If the mask octet is 255, copy the decimal IP address
- If the mask octet is 0, write a decimal zero
- If the mask is neither, this is an *interesting* octet:
  - Calculate the magic number as 256 - mask
  - Set the subnet ID's value to a multiple of the magic number that is closest
    to the IP address (without going over)

A practical example using 130.4.102.1/2555.255.240.0:

- We can copy 130 and 4 down (130.4.x.x)
- We can copy the zero down (130.4.x.0)
- The interesting octet is 102, therefore the magic number is: 256 - 240 = 16
- The closest multiple of 16 to 102 is 96: 134.4.96.0

Finding the broadcast address is very similar:

- If the mask octet is 255, copy the decimal IP address
- If the mask octet is 0, write a decimal 255
- If the mask is neither, this is an *interesting* octet
  - Calculate the magic number as 256 - mask
  - Take the subnet ID, add the magic number, and subtract 1

Using the previous example of 130.4.102.1/255.255.240.0:

- We can copy 130 and 4 down (130.4.x.x)
- We can copy the zero to a 255 (130.4.x.255)
- The interesting octet is 240, therefore the magic number is 256 - 240 = 16
- The broadcast address is the subnet ID + magic number - 1 = 134.4.111.255

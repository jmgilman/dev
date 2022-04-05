# Cisco Switches

Cisco sells a variety of network switches that span many different use-cases and
technologies. This page attempts to consolidate a useful subset of information
when configuring and troubleshooting Cisco switches.

## Default Setup

By default, Cisco switches come out of the box ready for basic switching. All
ports should be enabled, STP is enabled, and the default VLAN is set to VLAN1.
In most cases, this should be sufficient for forwarding ethernet traffic in a
network.

## Status

When attempting to grok the status of a switch, there are a few useful commands
available:

### Mac-address Table

To check the status of the mac-address table, run the following:

```text
switch> show mac address-table

          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
   1    0050.7966.6802    DYNAMIC     Gi0/2
   1    0050.7966.6803    DYNAMIC     Gi0/2
```

Note that the `Type` field indicates how the entry was added to the table.
Notably, the `DYNAMIC` type indicates this entry was learned through monitoring
incoming frames to the switch.

Additionally, `DYNAMIC` entries are not retained indefinintely. The global aging
timer determines when the switch flushes a specific entry (see
`show mac address-table aging-time`).

You can verify if a specific MAC address exists or not:

```text
switch> show mac address-table address 0050.7966.6802

          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
   1    0050.7966.6802    DYNAMIC     Gi0/2
```

If you don't know the MAC address, you can instead search by port:

```text
switch> show mac address-table dynamic interface gi0/2

          Mac Address Table
-------------------------------------------

Vlan    Mac Address       Type        Ports
----    -----------       --------    -----
   1    0050.7966.6802    DYNAMIC     Gi0/2
   1    0050.7966.6803    DYNAMIC     Gi0/2
Total Mac Addresses for this criterion: 2
```

Finally, entries can be cleared with:

```text
switch> clear mac address-table dynamic
```

### Interfaces

The easiest way to get an overview of the status of all of the switch ports is
to run the following command:

```text
switch> show interface status

Port      Name               Status       Vlan       Duplex  Speed Type
Gi0/0                        notconnect   1          a-full   auto RJ45
Gi0/1                        connected    1          a-full   auto RJ45
Gi0/2                        connected    1          a-full   auto RJ45
Gi0/3                        notconnect   1          a-full   auto RJ45
Gi1/0                        notconnect   1          a-full   auto RJ45
Gi1/1                        notconnect   1          a-full   auto RJ45
Gi1/2                        notconnect   1          a-full   auto RJ45
Gi1/3                        notconnect   1          a-full   auto RJ45
```

The port naming scheme is based on the highest speed possible for that port. You
can further inspect a port by drilling down into it:

```text
switch> show interface Gi0/1

GigabitEthernet0/1 is up, line protocol is up (connected)
  Hardware is iGbE, address is 5000.0001.0001 (bia 5000.0001.0001)
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,
     reliability 255/255, txload 1/255, rxload 1/255
  Encapsulation ARPA, loopback not set
  Keepalive set (10 sec)
  Auto Duplex, Auto Speed, link type is auto, media type is RJ45
  output flow-control is unsupported, input flow-control is unsupported
  ARP type: ARPA, ARP Timeout 04:00:00
  Last input never, output 00:00:01, output hang never
  Last clearing of "show interface" counters never
  Input queue: 0/75/0/0 (size/max/drops/flushes); Total output drops: 0
  Queueing strategy: fifo
  Output queue: 0/0 (size/max)
  5 minute input rate 0 bits/sec, 0 packets/sec
  5 minute output rate 0 bits/sec, 0 packets/sec
     0 packets input, 0 bytes, 0 no buffer
     Received 0 broadcasts (0 multicasts)
     0 runts, 0 giants, 0 throttles
     0 input errors, 0 CRC, 0 frame, 0 overrun, 0 ignored
     0 watchdog, 0 multicast, 0 pause input
     1226 packets output, 89342 bytes, 0 underruns
     0 output errors, 0 collisions, 2 interface resets
     0 unknown protocol drops
     0 babbles, 0 late collision, 0 deferred
     1 lost carrier, 0 no carrier, 0 pause output
     0 output buffer failures, 0 output buffers swapped out
```

## Configuration

### Configuring IPv4

To add a management IPv4 address to a switch, use the following:

```text
switch (config)# interface vlan 1
switch (config-if)# ip address 192.168.1.200 255.255.255.0
switch (config-if)# no shut
switch (config-if)# exit
switch (config)# ip default-gateway 192.168.1.1
```

Replace key details where needed. Alternatively, the IP address details can be
obtained via DHCP by substituting the second command with `ip address dhcp`.

!!! note All switches use VLAN1 out of the box. If your networking is using
VLANs, this should be changed accordingly. Additionally, it's possible for a
switch to have an IPv4 address on multiple VLANs (simply repeat the commands).

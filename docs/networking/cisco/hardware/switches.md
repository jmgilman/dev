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

The port naming scheme is based on the highest speed possible for that port.

Additionally, the following command contains useful information about port
status:

```text
Switch# show interface description
Interface                      Status         Protocol Description
Gi0/0                          up             up       VPC1
Gi0/1                          up             up       VPC2
Gi0/2                          down           down
Gi0/3                          down           down
Gi1/0                          down           down
Gi1/1                          down           down
Gi1/2                          down           down
Gi1/3                          down           down
```

When examining the above two outputs, the following table is useful:

| Line Status           | Protocol Status     | Interface Status | Root Cause                                               |
| --------------------- | ------------------- | ---------------- | -------------------------------------------------------- |
| administratively down | down                | disabled         | The `shutdown` command is configured on the interface    |
| down                  | down                | notconnect       | No cable; bad cable; wrong cable pinouts; speed mismatch |
| up                    | down                | notconnect       | This condition is unexpected on a LAN switch             |
| down                  | down (err-disabled) | err-disabled     | Port security has disabled this interface                |
| up                    | up                  | connected        | The interface is working correctly                       |

!!! warning A duplex mismatch will show the switch as `up/up` with a `connected`
interface status. In this case, double-check the duplex settings on both sides
of the connection.

You can further inspect a port by drilling down into it:

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

The following are descriptions for some of the packet terms above:

| Name            | Description                                                                       |
| --------------- | --------------------------------------------------------------------------------- |
| Runts           | Frames which are less than 64-bytes long (including 18 for MAC addresses and FCS) |
| Giants          | Frames that exceed the macimum frame size (typically 1518 bytes)                  |
| Input Errors    | A total of runts, giants, no buffer, CRC, frame, overrun, and ignored counts      |
| CRC             | Frames that did not pass the FCS                                                  |
| Frame           | Frames which have an illegal format                                               |
| Packet Outputs  | Total number of packets forwarded out of the interface                            |
| Output Errors   | Total number of packets which failed being forwarded                              |
| Collisions      | Number of collisions detected when an interface is transmitting a frame           |
| Late Collisions | Collisions which happen after the 64th byte of the frame has been transmitted     |

### VLANs

To show the status of VLANs:

```text
switch# show vlan brief

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Gi0/2, Gi0/3, Gi1/0, Gi1/1
                                                Gi1/2, Gi1/3
10   prod                             active    Gi0/0, Gi0/1
1002 fddi-default                     act/unsup
1003 token-ring-default               act/unsup
1004 fddinet-default                  act/unsup
1005 trnet-default                    act/unsup
```

To inspect a particular VLAN:

```text
switch# show vlan id 10

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
10   prod                             active    Gi0/0, Gi0/1

VLAN Type  SAID       MTU   Parent RingNo BridgeNo Stp  BrdgMode Trans1 Trans2
---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------
10   enet  100010     1500  -      -      -        -    -        0      0

Remote SPAN VLAN
----------------
Disabled

Primary Secondary Type              Ports
------- --------- ----------------- ------------------------------------------
```

Additionally, VLAN information pertaining to a particular port can be seen with:

```text
switch# show interface gi0/2 switchport
```

### Spanning Tree

To see the status of spanning-tree:

```text
switch# show spanning-tree
```

To limit to a single VLAN:

```text
switch# show spanning-tree vlan 10
```

### EtherChannel

To see the details of a particular EtherChannel:

```text
switch# show etherchannel 1 port-channel
```

## Configuration

### Configuring interfaces

Interfaces can be configured individually or across a range. For individual
configuration:

```text
switch (config)# interface gi0/1
```

To configure a range of interfaces:

```text
switch (config)# interface range gi0/1-3
```

#### Adding a description

```text
switch (config-if)# description "my port"
```

#### Changing duplex/speed

In most cases, these settings should be left at their default value of `auto` to
automatically negotitating duplex and speed. However, some IoT devices in
particular, may fail auto-negotiating and it may therefore be necessary to
manually configure the port the device is connected to.

Additionally, if a device simply does not support aut-negotation, then Cisco
switches by default will resort to trying to sense the speed or just resort to
using the slowest speed available if that fails. For duplex, the switch uses
half-duplex for 10/100 links and full duplex for all others.

To set the duplex mode:

```text
switch (config-if)# duplex [auto | full | half]
```

To set the speed:

```text
switch (config-if)# speed [auto | 10 | 100 | 1000 | ....]
```

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

### Configuring VLANs

In order for switches to be able to use VLANs, it must first be told that they
exist:

```text
switch (config)# vlan 10
switch (config-vlan)# name myvlan
```

Once configured, interfaces should be configured as access ports in order for
them to be joined to the VLAN:

```text
switch (config)# int gi0/1
switch (config-if)# switchport access vlan 10
switch (config)# switchport mode access
```

Configuring a VLAN trunk is a bit more involved: by default, switches are
configured with `switchport mode dynamic auto` which will never attempt to
actually auto-negotiate a trunking protocol with other switches; rather, it will
sit idle and wait for incoming requests to negotiate a trunking protocol. To
force a switch into an active state:

```text
switch (config-if)# switchport mode dynamic desirable
```

The above command need only be run on **one switch** in a pair of switches,
assuming the other switch is in its default state. Alternatively, you can skip
using dynamic mode altogether and set the trunking explicitely:

```text
switch (config-if)# switchport trunk encapsulation dot1q
switch (config-if)# switchport mode trunk
```

The below table summarizes all of the available administrative modes:

| Mode              | Access  | Dynamic Auto | Trunk | Dynamic Desirable |
| ----------------- | ------- | ------------ | ----- | ----------------- |
| access            | Access  | Access       | N/A   | Access            |
| dynamiuc auto     | Accesss | Access       | Trunk | Trunk             |
| trunk             | N/A     | Trunk        | Trunk | Trunk             |
| dynamic desirable | Access  | Trunk        | Trunk | Trunk             |

To completely disable the Dynamic Trunking Protocol (DTP) which is responsible
for negotiations, configure the interace with:

```text
switch (config-if)# switchport nonnegotiate
```

By default, trunks will forward all configured VLANs on the switch. To limit the
VLANs that are forwarded over a specific trunk:

```text
switch (config-if)# switchport trunk allowed vlan 1, 2, 10-12
```

It's also possible to change the default VLAN of a trunk interface:

```text
switch (config-if)# switchport trunk native vlan 10
```

### Configuring spanning tree

There are five different variations of the spanning tree protocol, with RSTP
being the most dominant. However, Cisco switches only support three, as shown in
the below table (which lists all five):

| Name        | STP or RSTP? | # Trees   | IEEE   | Config Name |
| ----------- | ------------ | --------- | ------ | ----------- |
| STP         | STP          | 1 (CST)   | 802.1D | N/A         |
| PVST+       | STP          | 1/VLAN    | 802.1D | pvst        |
| RSTP        | RSTP         | 1 (CST)   | 802.1w | N/A         |
| Rapid PVST+ | RSTP         | 1/VLAN    | 802.1w | rapid-pvst  |
| MSTP        | RSTP         | 1 or more | 802.1s | mst         |

Which mode of STP that is used can be configured with a global command:

```text
switch (config)# spanning-tree mode [pvst/rapid-pvst/mst]
```

Additionally, the priority on a given switch can be modified such that it's
always elected as the root bridge (or acts as a backup):

```text
switch (config)# spanning-tree vlan 1 root [primary/secondary]
```

### Configuring EtherChannels

EtherChannels are configured in the interface subconfiguration menu. To link one
or more physical ports into an EtherChannel, you must use the same
`channel-group` number across all physical links:

```text
switch (config)#: int gi0/0
switch (config-if)# channel-group 1 mode on
switch (config)#: int gi0/1
switch (config-if)# channel-group 1 mode on
```

In most cases, you'll likely want to configure a dynamic EtherChannnel which
will only bring the EtherChannel up if both sides are configured correctly.
Cisco switches offer two dynamic protocols: PAgP and LACP, the former being a
Cisco proprietary protocol. Both protocols support being in an active or passive
state, however, for the EtherChannel to actually configure itself, one end
should be in passive and the other in active.

Confusingly, Cisco does not differentiate the protocols by name. Rather, you
must use the correct verb to define which protocl you intend to use. For PAgP:

```text
switch (config-if)# channel-group 1 mode [desirable/auto]
```

For LACP:

```text
switch (config-if)# channel-group 1 mode  [active/passive]
```

Load distribution in a EtherChannel is a bit complex. By default, Cisco switches
will consider the following rules first:

- Avoid message reordering whenever possible
- Make use of the switch forwarding ASICs whenever possible
- Use all of the active links whenever possible

Other than those rules, the only configuration option available is how the
switch actually balances traffic across an EtherChannel:

| Configuration | Uses                   | Layer |
| ------------- | ---------------------- | ----- |
| src-mac       | Source MAC             | 2     |
| dst-mac       | Destination MAC        | 2     |
| src-dst-mac   | Source/Destination MAC | 2     |
| src-ip        | Source IP              | 3     |
| dst-ip        | Destination IP\_       | z     |

## Troubleshooting

### Troubleshooting VLANs

There are many different scenarios in which a VLAN may not be operating on a
switch as expected. This section covers some common pitfalls.

#### Check that the VLAN is enabled

```text
switch# sh vlan brief
```

Verify that the status column is `active`. If it's `act/lshut`, the VLAN has
been administratively shutdown.

#### Check that trunking is setup correctly

If the VLAN is trunked, verify that trunking ports are working as expected:

```text
switch# show interface gi0/2 switchport
```

In particular, verify that the `Operational Mode` row indicates `trunking`. If
it's not trunking, double-check how the port is configured. In particular, if
the mode is set to `dynamic auto` on both ends of the trunk, it will not work.
Try manually setting the trunking protocol on both ends.

Verify that the problematic VLANs are allowed over the trunk:

```text
switch# sh interface trunk
```

The `Vlans allowed on trunk` section should list the desired VLANs. If not,
check the trunk interface configuration, specifically if the
`switchport trunk allowed vlan` setting has been configured.

Finally, verify that the native VLAN is the same on the trunk interfaces. The
`Native VLAN` column in the previous command should match on both sides of the
trunk.

### Troubleshooting EtherChannels

EtherChannels can be notoriously finicky to get set up correctly. The most
common pitfall is the interfaces in a single EtherChannel not being configured
the same. When creates an EtherChannel, all ports added must have identical
values for the following properties:

- Speed
- Duplex
- Operational access or trunking state
- If an access port, the access VLAN
- If a trunk port, the allowed VLAN list
- If a trunk port, the native VLAN
- STP interface settings

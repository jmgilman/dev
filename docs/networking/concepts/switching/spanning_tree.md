# Rapid Spanning Tree Protocol

The Rapid Spanning Tree Protocol (RSTP/802.1w/Q) is responsible for preventing
loops in a network when redundant links are used between devices. In particular,
it focuses on blocking certain switch ports in a topology such that a frame
cannot infinitely recurse through the network. This is primarily done by
dynamically examining the topology at runtime and determining which ports need
to be placed in a *blocked* state to prevent recursion.

In particular, RSTP prevents the following problems:

| Problem                     | Description                                                                    |
| --------------------------- | ------------------------------------------------------------------------------ |
| Broadcast Storms            | The forwarding of a frame repeatedly on the same links                         |
| MAC table instability       | The continuinal updating of a switch's MAC address table                       |
| Multiple frame transmission | A side effect of looping frames in which multiple copies are received by nodes |

When RSTP detects a problem, *convergence* happens, in which the switches
collectively realize a topology change has occurred and determine if additional
ports should be set to a blocking or forwarding state.

## How it Works

At the core, in a given topology, RSTP simply decides which ports on switches
should be allowed to *forward* frames. Any frames **not** selected in this
process are put into a *blocking* state. The following table documents the
reasoning used to determine which ports are placeed in a forwarding state.

| Characterization                | STP state  | Description                                                                   |
| ------------------------------- | ---------- | ----------------------------------------------------------------------------- |
| All root switch ports           | Forwarding | The root switch is always the designated switch                               |
| Each nonroot switch's root port | Forwarding | The port through which the switch has the least cost to reach the root switch |
| Each LAN's designated port      | Forwarding | The switch forwarding the Hello on the segment, with the lowest root cost     |
| All other working ports         | Blocking   | The port is not used for forwarding user frames                               |

### Bridge Protocol Data Units

The RSTP protocol relies on the sending and receiving of Bridge Protocol Data
Units (BPDU), of which the most common is the *Hello BPDU*. The structure of a
BPDU is documented below.

| Field                           | Description                                                                |
| ------------------------------- | -------------------------------------------------------------------------- |
| Root bridge ID                  | The bridge ID of the switch that the sender believes to be the root switch |
| Sender's bridge ID              | The bridge ID of the switch sending this BPDU                              |
| Sender's root cost              | The RSTP cost between this switch and the current root                     |
| Timer values on the root switch | Includes the Hello timer, MaxAge timer, and forward delay timer            |

### Election

The first major step in RSTP is election: all switches must perform a process by
which only one switch is elected as the *root switch*. This is accomplished by
comparing their *bridge ID's* - ID values built from combining a priority with
the MAC address of the switch.

All switches assume they are the root switch in the beginning and send out
BPDU's indicating as such. As switches receive BPDU's, they will compare the
sending BPDU to their own, and if it's smaller, will modify the BPDU it's
sending to indiciate that the sending switch is actually the root switch. In a
short-period of time, the switches should eventually converge on a single root
switch.

### Root ports

After the election, non-root switches must now designate a *single* port to be
their root port. The process for determining a root port is as follows:

1. The switch determines a cost for each of its interfaces
1. The switch adds incoming neighbor root costs to each of its interfaces
1. The interface with the lowest root cost is chosen to be the root port

In the case of a tie, switches use the following tie-breakers:

1. Choose based on the lowest neighbor bridge ID
1. Choose based on the lowest neigbor port priority
1. Choose based on the lowest neigbor internal port number

### Designated ports

The final step is to designate a *single* designated port on each LAN segment.
This port is determined by selecting the switch port with the lowest root cost
in the segment. This port is automatically set to a forwarding state.

!!! note A segment can be thought of as a physical link between two devices. The
root switch sets all ports on itself to the DP since it's the root. Other
switches must determine which of their ports on a given segment will become the
DP. Ports which connect an end-user device are always set as DP's.

### Default Costs

When calculating costs, each port is given a default cost value which is often
tied to the speed of the port. This is the *default* value and can be modified
as needed by a network engineer.

| Speed    | Cost (1998 version) | Cost (2004 version) |
| -------- | ------------------- | ------------------- |
| 10 Mbps  | 100                 | 2,000,000           |
| 100 Mbps | 19                  | 200,000             |
| 1 Gbps   | 4                   | 20,000              |
| 10 Gbps  | 2                   | 2000                |
| 100 Gbps | N/A                 | 200                 |
| 1 Tbps   | N/A                 | 20                  |

### STP features

Up until this point, all processes have been the same for both RSTP And STP.
However, STP does diverge away from RSTP, primarily in how it responds to a
change in the network topology.

In particular, STP relies on three timers:

| Timer         | Default Value  | Description                                                                                       |
| ------------- | -------------- | ------------------------------------------------------------------------------------------------- |
| Hello         | 2 seconds      | The time period between Hellos created by the root                                                |
| MaxAge        | 10 times Hello | How long any switch should wait after ceasing to hear Hellos before trying to change the topology |
| Forward delay | 15 seconds     | Delay that determines how quickly a port can change from blocking to forwarding                   |

Additionally, if a port was previously blocking, it does not transition directly
to forwarding, but rather must go through two additional state:

- Listening: The interface does not forward frames; old MAC addresses are purged
  from the table as usual but no new ones are added.
- Learning: The interface does not forward frames; the switch begins adding new
  MAC addresses to the table.

For **each** transition, the switch must wait the configured forward delay
period defined. Thus, in a default state, a blocking port would need to wait at
least 10 x Hello (20 seconds) plus 15 seconds per transition (30 seconds) for a
total of 50 seconds.

### RSTP features

One of the primary ways that RSTP differs from STP is by port roles:

| Port Role       | Function                                                          |
| --------------- | ----------------------------------------------------------------- |
| Root port       | Port that begins a nonroot switch's best path to the root         |
| Alternate port  | Port that replces the root port when the root port  fails         |
| Designated port | Switch port designated to forward onto a collision domain         |
| Backup port     | Port that replaces a designated port when a designated port fails |
| Disabled port   | Port that is administratively disabled                            |

Of note is the concept of an alternate port - in cases where the root port is
determined to have failed, a switch using RSTP can immediately set the current
root port to blocking and the alternate port to forwarding - thus bypassing any
need for delays.

In addition to the roles, RSTP uses all of the same states of STP with the
exception of the listening state and changing the blocking state to discarding.

| Function                                                            | STP State  | RSTP State |
| ------------------------------------------------------------------- | ---------- | ---------- |
| Port is admin disabled                                              | Disabled   | Discarding |
| State that ignores incoming data frames and does not forward frames | Blocking   | Discarding |
| Interim state without MAC learning and no forwarding                | Listening  | Not used   |
| Interim state with MAC learning and no forwarding                   | Learning   | Learning   |
| State that allows MAC learning and forwarrd of frames               | Forwarding | Forwarding |

### MSTP Features

The Multiple Spanning Tree Protocol (MSTP) was added by the IEEE in cases where
multiple spanning trees should exist in a single network, specifically for
covering cases that involve multiple VLANs.

The bridge ID contained within a BPDU is modified by MSTP to include an
additional 12-bit *System ID Extension* field which holds the VLAN ID.

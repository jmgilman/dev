# Rapid Spanning Tree Protocol

The Rapid Spanning Tree Protocol (RSTP) is responsible for preventing loops in a
network when redundant links are used between devices. In particular, it focuses
on blocking certain switch ports in a topology such that a frame cannot
infinitely recurse through the network. This is primarily done by dynamically
examining the topology at runtime and determining which ports need to be placed
in a *blocked* state to prevent recursion.

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

### STP vs RSTP

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

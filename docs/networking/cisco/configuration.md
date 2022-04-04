# Cisco Configuration

Configuration in Cisco IOS devices is done in a text file that lives on the
device and is consulted at runtime to determine how a device should behave. The
format of the configuration is specific to Cisco and very closely resembles the
syntax of the commands used to modify a device configuration while in
[configuration mode](cli.md#configuration-mode).

## Storage

The configuration of a device is typically stored in two places.

### RAM

The running configuration is stored in RAM and all configuration commands issued
to a device will modify this in-memory version of the configuration. Since RAM
is volatile, any changes to this configuration file are temporary and lost after
a reboot of the device.

### NVRAM

The startup configuration is stored in NVRAM and is only consulted at boot time
in order to set the running configuration. Since NVRAM is non-volatile, changes
to this configuration file will persist across reboots.

## Saving

Since, by default, configuration commands only modify the volatile running
configuration file, it's important to save changes you want to persist across
reboots of the switch. This can be accomplished via the `copy` command:

```text
copy running-config startup-config
```

## Erasing

The startup configuration file can be erased with the following command:

```text
write erase
```

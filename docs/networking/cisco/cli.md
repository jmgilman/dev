# Cisco CLI

Cisco provides a common CLI interface for devices running their proprietary
Internetwork Operating System (IOS). While the various commands contained within
the CLI environment are too many to document effectively, understanding the
basic structure of the CLI interface can help move around more smoothly.

## CLI Modes

The CLI interface contains three primary modes. The first two are executive
modes, meaning they only contain commands that interact with the device but do
not make configuration changes. The last one, however, allows running commands
which can change the running configuration of a device.

### User Mode

This is the default exec mode that you will typically be dropped into when you
connect to an IOS device. This mode is considered safe in that it only allows
viewing the status of the switch and does not allow an individual to make any
disruptive changes to the device state. It's denoted by a `>` character after
the hostname.

### Privileged Mode

Identical to the user mode, except that certain additional commands are made
available for execution. These commands can typically be disrupted, like the
`reload` command which will cause IOS to reboot. It's denoted by a `#` character
after the hostname.

| Command   | Description             |
| --------- | ----------------------- |
| `enable`  | Enables privilged mode  |
| `disable` | Disables privilged mode |

### Configuration Mode

This is the only mode which allows running commands which can directly change
the running configuration of the IOS device. It's typically structured with
several sub-modes which control configuring specific aspects of the device.

!!! note While in configuration mode, commands that typically run in execution
mode are not available unless the command is prefixed with the `do` keyword. For
example: `do show running-config`.

| Command              | Description               |
| -------------------- | ------------------------- |
| `configure terminal` | Enters configuration mode |
| `exit` or `CTRL+Z`   | Exits configuration mode  |

## Help

As noted above, it's impossible to memorize the vast number of commands you'll
run into on the various IOS devices. In order to quickly recall commands, you
can use the `?` operator:

```text
Switch> show ?
```

The below table documents common usages of this operator:

| Example       | Description                                                       |
| ------------- | ----------------------------------------------------------------- |
| `?`           | List all possible commands in the current context                 |
| `<command> ?` | List all possible subcommnads of the given command                |
| `sh?`         | List all possible completions of the partially given command name |

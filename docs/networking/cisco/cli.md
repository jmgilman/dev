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
switch> show ?
```

The below table documents common usages of this operator:

| Example       | Description                                                       |
| ------------- | ----------------------------------------------------------------- |
| `?`           | List all possible commands in the current context                 |
| `<command> ?` | List all possible subcommnads of the given command                |
| `sh?`         | List all possible completions of the partially given command name |

## Security

Production environments should take care to secure access to the CLI. There are
various methods of doing this, the below sections cover common ones.

### Securing Privileged Mode

A shared password can be set to secure privileged access (the `enable` command):

```text
switch> enable secret mypassword123
```

!!! warning The `enable password` command is still accessible in most IOS
versions and **should not** be used. It stores the password in plain-text and
can be extracted by simply examining the current running configuration.

### Securing Local Console Access

The default configuration of an IOS device does not block access to the local
console port on the device. To force a user to use a shared password when
connecting locally to a device:

```text
switch> line con 0
switch> login
switch> password mypassword123
```

### Enabling SSH Access

SSH is not enabled by default and some devices do not have the cryptographic
methods needed for handling SSH connections. However, it is the most preferred
method for connections since it's encrypted by default. To enable SSH on a
device:

```text
switch (config)# hostname sw1
sw1 (config)# ip domain-name sw1.example.com
sw1 (config)# crypto key generate rsa
sw1 (config)# ip ssh version 2
```

Then, follow the steps to
[secure with local user accounts](#securing-with-user-accounts).

!!! warning By default, setting `login local` on vty lines 0-15 will enable
**both** SSH and telnet access. It's recommended to explicitely disable telnet
access by only allowing SSH connections:

```text
sw1 (config)# line vty 0 15
sw1 (config-line)# transport input ssh
```

### Enabling Telnet Access

Telnet is not enabled by default. To enable it and require a password, use the
following:

```text
switch (config)# line vty 0 15
switch (config-line)# login
switch (config-line)# password mypassword123
```

### Securing with User Accounts

As an alternative to shared passwords, local user accounts can be created on
each IOS device which can then be used at login time:

```text
switch (config)# username myusername secret mypassword123
```

Once configured, use `login local` in the console/telnet configuration sections
to enable local account login ([see above section](#enabling-telnet-access)).

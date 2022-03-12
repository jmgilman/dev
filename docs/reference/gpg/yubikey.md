# Yubikey

## Provisioning

### Setup

Perform the following steps for setting up the environment for provisioning:

1. The dedicated environment should already be available as documented in the
   [environment](environment.md) section.

1. Ensure the RPi is running and you are sitting infront of the shell prompt.

1. Use a USB-C to USB-A adapter to plug the YubiKey into the RPi.

1. Plug the encrypted USB backup drive with the primary key into the RPi.

1. Enter the passcode into the USB drive to unlock it.

1. Note the device name of the USB drive (use `lsblk`).

Create a new temporary working environment:

```bash
export GNUPGHOME="$(key_workspace)"
```

Decrypt the backup partition and import the primary PGP key. Note that the
primary key is backed up on partition one:

```bash
key_open /dev/sda1
```

You'll need to enter both the passphrase for the encrypted partition as well as
the passphrase for the primary PGP key. These are documented on paper and stored
in the safe.

### Configure pins

Begin configuring the card:

```bash
gpg --card-edit
```

Enter admin mode and enable kdf-setup. You will be prompted for the current
admin pin, the factory admin pin is: `12345678`.

```bash
gpg/card> admin
gpg/card> kdf-setup
```

Change the admin pin (factory default is: `12345678`):

```bash
gpg/card> passwd
gpg/card> 3
```

And the user pin (factory default is: `123456`)

```bash
gpg/card> 1
```

And the reset code:

```bash
gpg/card> 4
```

### Configure properties

Set the name, language, and login (email):

```bash
gpg/card> name
Cardholder's surname:
Cardholder's given name: Joshua Gilman

gpg/card> lang
Language preferences: en

gpg/card> login
Login data (account name): <EMAIL>
```

### Transfer subkeys

Edit the primary key:

```bash
gpg --edit-key "<FINGERPRINT>"
```

The below will begin selecting each key, one-by-one, and moving them to the
Yubikey. This is a destructive process, however, only the local key data is lost
and not the data located on the backup.

Note that this process requires selecting the key to transfer first and then
transferring it. Selected keys are denoted by a `*`. You must de-select each key
by using `key <NUM>` **before** moving to another key.

```bash
gpg> key 1
gpg> keytocard
Your selection? 1

gpg> key 1
gpg> key 2
gpg> keytocard
Your selection? 2

gpg> key 2
gpg> key 3
gpg> keytocard
Your selection? 3
```

Now save and quit:

```bash
gpg> save
```

Verify that all three subkeys were transferred:

```bash
gpg -K
-------------------------------------------------------------------------
sec   rsa4096/0xFF3E7D88647EBCDB 2023-03-011 [C]
      Key fingerprint = 011C E16B D45B 27A5 5BA8  776D FF3E 7D88 647E BCDB
uid                            Joshua Gilman <me@gmail.com>
ssb>  rsa4096/0xBECFA3C1AE191D15 2017-10-09 [S] [expires: 2023-03-11]
ssb>  rsa4096/0x5912A795E90DD2CF 2017-10-09 [E] [expires: 2023-03-11]
ssb>  rsa4096/0x3F29127E79649A3D 2017-10-09 [A] [expires: 2023-03-11]
```

Note the `>` after each `ssb` which denotes the key lives in the card.

## Troubleshooting

If you see something like below when trying to edit the card:

```bash
$ gpg --card-status
gpg: selecting card failed: Operation not supported by device
gpg: OpenPGP card not available: Operation not supported by device
```

Try the following:

```bash
echo "disable-ccid" >> ~/.gnupg/scdaemon.conf
pkill gpg-agent; gpg-agent --homedir $HOME/.gnupg --daemon
```

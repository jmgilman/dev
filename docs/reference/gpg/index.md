# GnuPG

This section contains information about the GnuPG (aka GPG), the OpenPGP stack
that it's based on, and it's `gpg` CLI tool. GnuPG is primarily used for signing
my git commit messages and encrypting passwords using `pass`.

## Overview

GnuPG (GNU Privacy Guard) is an open-source tool which implements OpenPGP (open
source PGP) and provides a suite of crytographic operations for encrypting data
at rest and in motion. It accomplishes this through a combination of symmetric
and assymetric encrpytion. In short, encryption of a payload is typically done
using a symmetric algorithm (i.e. AES) using a randomly generated session key.
The session key is then encrypted using an assymetric algorithm (i.e. RSA). A
receiving party would first decrypt the session key and then the payload using
the decrypted session key.

GnuPG has the concept of keyrings. A keyring usually consists of a primary key
and one or more associated subkeys. Cross-signing is implemented between a
primary key and a dependent subkey to prove the relationship. Subkeys are
typically (but not always) segregated by their functionality. Four
functionalities are available:

1. Encryption
1. Signing
1. Certification
1. Authorization

A secure setup typically involves an offline primary key which has the
certification functionaltiy enabled and signs three subkeys for covering the
remaining functionalities (although the last is usually only used for SSH).

## Architecture

The infrastructure I utilize in my development environment is slightly
complicated to fully understand, however, this comes with the benefit that it is
very secure. This section details the architecture used.

### Offline Primary Key

My primary PGP key is completely air-gapped and never touches a system which has
network access capabilities. This is accomplished by using a Raspberry Pi which
has had the Wifi/Bluetooth hardware disabled. The key is generated in a fresh
NixOS environment and is immediately backed up to an encrypted USB drive. All
future operations that need the primary key will happen in the dedicated
environment provided by the RPi.

### Secure Backups

A hardware encrypted USB storage device is used for securely holding the the
primary key backup, subkey backups, and the revocation certificate. A single
partition on the hardware encryped USB storage device is LUKS encrypted before
any backups are moved to it. This requires three separate passphrases to access
the primary key:

1. The passphrase that must be physically entered to unlock the USB device
1. The passphrase that is protecting the encrypted partition
1. The passphrase that is protecting the primary key itself

The public key is backed up to a second NTFS partition which is not encrypted
and can be mounted to my development machine for importing the public key.

### Yubikey

During generation, three subkeys are created for signing, encrypting, and
authentication. These subkeys are eventually transferred to one or more Yubikeys
using the smart card interface provided by Yubikey. Actual signing and
encryption operations happen using the subkeys which are automatically renewed
and/or rotated every year. Since the Yubikeys are configured in the offline
environment, the subkeys are also completely air gapped and are only accessible
through interacting with the Yubikey over the smart card interface (meaning,
they are protected by a pin).

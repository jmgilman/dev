# Bootstrap

This page provides instructions on bootstrapping my development environment on
my current hardware. The purpose is for recovery should my hardware need to be
reinstalled for any reason.

## Initial Setup Wizard

The below steps are performed in the startup wizard:

1. Select language and locale
1. Accept privacy agreement
1. Skip Migration Assistant
1. Sign-in with Apple ID
1. Accept EULA
1. Create account

- **Full Name:** Joshua Gilman
- **Account Name:** josh
- **Password:** ...

1. Enable location services
1. Select timezone
1. Skip analytics
1. Skip screentime
1. Enable dark mode

## Manual steps

The following are (unfortunate) manual steps:

1. Nuke the applications in the dock
1. Move all applications into an *Apple* folder

## Run Setup

Open a terminal and perform the following:

```bash
curl -s https://raw.githubusercontent.com/jmgilman/dev-setup/master/setup.sh -o setup.sh && \
curl -s https://raw.githubusercontent.com/jmgilman/dev-setup/master/setup.sh.sha256 -o setup.sh.sha256 && \
shasum -a 256 -c setup.sh.sha256
```

Verify that the checksum passes, and then run the script:

```bash
bash setup.sh
```

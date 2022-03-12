# Environment

A dedicated environment is made available for interacting with the primary GPG
key that I utilize across my environments. It consists of an air-gapped
Raspberry Pi with the necessary tools made available by NixOS. The image is
generateed on my development machine and flashed to an SD card for the RPi to
boot with.

## Setup

To create the environment, start by cloning the configuration files:

```bash
git clone https://github.com/jmgilman/dev-sec
cd dev-sec
```

Ensure that [multipass][01] is running and then run the following script:

```bash
./setup.sh
```

The script will create a new `multipass` instance and mount the repository
contents to it. Once the instance is running, proceed with the following script:

```bash
./build.sh
```

The script will execute `nix build` on the instance which will build the raw
NixOS image file. The file will be copied to the local directory when finished.
Extract the compressed image:

```bash
zstd -d nixos-sd-image-22.05.20220306.cf7e4ca-aarch64-linux.img.zst
```

Plug the RPi SD card into the local machine and verify it's device name:

```bash
diskutil list
```

Finally, flash the image to the SD card:

```bash
sudo dd if=nixos-sd-image-22.05.20220306.cf7e4ca-aarch64-linux.img of=/dev/disk4 bs=4m
```

Insert the SD card into the RPi and boot.

[01]: https://multipass.run/

#! /usr/bin/env bash
#
# Author: Joshua Gilman <joshuagilman@gmail.com>
#
#/ Usage: setup.sh
#/
#/ A simple installation script for configuring my personal development
#/ environment on an M1 based Apple MacBook.
#/

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

readonly yellow='\e[0;33m'
readonly green='\e[0;32m'
readonly red='\e[0;31m'
readonly reset='\e[0m'

readonly dotfiles='https://github.com/jmgilman/dotfiles'

# Nix
readonly nixVer='2.6.1'
readonly nixReleaseBase='https://releases.nixos.org'

# Brew
readonly brewRepo='https://raw.githubusercontent.com/Homebrew/install'
readonly brewCommitSha='e8114640740938c20cc41ffdbf07816b428afc49'
readonly brewChecksum='98a0040bd3dc4b283780a010ad670f6441d5da9f32b2cb83d28af6ad484a2c72'

# Usage: log MESSAGE
#
# Prints all arguments on the standard output stream
log() {
  printf "${yellow}>> %s${reset}\n" "${*}"
}

# Usage: success MESSAGE
#
# Prints all arguments on the standard output stream
success() {
  printf "${green} %s${reset}}\n" "${*}"
}

# Usage: error MESSAGE
#
# Prints all arguments on the standard error stream
error() {
  printf "${red}!!! %s${reset}\n" "${*}" 1>&2
}

# Usage: die MESSAGE
# Prints the specified error message and exits with an error status
die() {
  error "${*}"
  exit 1
}

# Usage: yesno MESSAGE
#
# Asks the user to confirm via y/n syntax. Exits if answer is no.
yesno() {
    read -p "${*} [y/n] " -n 1 -r
    printf "\n"
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
}

# Usage: isRequired NAME EXECUTABLE
#
# Asks the user permission to install NAME and then runs EXECUTABLE
isRequired() {
    log "It appears that ${1} is not installed and is required to continue."
    yesno "Would you like to install it?"

    log "Installing ${1}..."
    ${2}
    success "${1} was successfully installed"
}

# Usage: installXcode
#
# Downloads and installs the xcode command line tools
# Source: https://github.com/Homebrew/install/blob/master/install.sh#L846
chomp() {
  printf "%s" "${1/"$'\n'"/}"
}
installXcode() {
    log "Searching online for the Command Line Tools"

    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    clt_placeholder="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
    /usr/bin/sudo /usr/bin/touch "${clt_placeholder}"

    clt_label_command="/usr/sbin/softwareupdate -l |
                        grep -B 1 -E 'Command Line Tools' |
                        awk -F'*' '/^ *\\*/ {print \$2}' |
                        sed -e 's/^ *Label: //' -e 's/^ *//' |
                        sort -V |
                        tail -n1"
    clt_label="$(chomp "$(/bin/bash -c "${clt_label_command}")")"

    if [[ -n "${clt_label}" ]]
    then
        log "Installing ${clt_label}"
        /usr/bin/sudo "/usr/sbin/softwareupdate" "-i" "${clt_label}"
        /usr/bin/sudo "/usr/bin/xcode-select" "--switch" "/Library/Developer/CommandLineTools"
    fi

    /usr/bin/sudo "/bin/rm" "-f" "${clt_placeholder}"
}

# Usage: installNix
#
# Downloads and executes the nix installer script
installNix() {
    local nixURL="${nixReleaseBase}/nix/nix-${nixVer}/install"
    local checksumURL="${releaseBase}/nix/nix-${nixVer}/install.sha256"

    log "Downloading install script from ${nixURL}..."
    curl "${nixURL}" -o "${tmpDir}/nix.sh"
    local sha=$(curl "${checksumURL}")

    log "Validating checksum..."
    if ! echo "${sha} ${tmpDir}/nix.sh" | sha256sum -c
    then
        die "Checksum validation failed; cannot continue"
    fi

    log "Running nix installer..."
    bash "${tmpDir}/nix.sh"
    success "Nix installed successfully"
}

# Usage installBrew
#
# Downloads and executes the brew installer script
installBrew() {
    local brewURL="${brewRepo}/${brewCommitSha}/install.sh"

    log "Downloading install script from ${brewURL}..."
    curl "${brewURL}" -o "${tmpDir}/brew.sh"

    log "Validating checksum..."
    if ! echo "${brewChecksum} ${tmpDir}/brew.sh" | sha256sum -c
    then
        die "Checksum validation failed; cannot continue"
    fi

    log "Running brew installer..."
    bash "${tmpDir}/brew.sh"
    success "Brew installed successfully"
}

# need a scratch space for downloading files
tmpDir=$(mktemp -d -t dev-setup-XXXXXXXXXX)
if [[ ! -d "$tmpDir" ]]
then
    die "Failed creating a temporary directory; cannot continue"
fi

# xcode is needed for building most software from source
if ! /usr/bin/xcode-select -p &> /dev/null
then
    isRequired 'xcode' 'installXcode'
else
    log "xcode detected, skipping install"
fi


# rosetta is needed for running x86_64 applications
if ! /usr/bin/pgrep oahd &> /dev/null
then
    isRequired 'rosetta' 'softwareupdate --install-rosetta'
else
    log "rosetta detected, skipping install"
fi

# a rudimentary check to see if the nix binary is available
if ! command -v nix &> /dev/null
then
    isRequired 'nix' 'installNix'
fi

# a more full-featured check to validate it's actually installed correctly
if ! nix doctor &> /dev/null
then
    error 'nix doctor reports an unhealthy nix installation'
    isRequired 'nix' 'installNix'

    log "Please run this installer script again to continue"
    exit(1)
fi

log "Fetching dotfiles and initializing nix-darwin..."
nix shell nixpkgs#chezmoi -c chezmoi init ${dotfiles} && chezmoi apply

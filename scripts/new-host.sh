#!/usr/bin/env bash

set -euo pipefail

REPO="${NIXOS_CONFIG_REPO:-$HOME/nixos-config}"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <hostname>"
    echo
    echo "Example:"
    echo "  $0 new-laptop"
    exit 1
fi

HOST="$1"
TARGET="$REPO/hosts/$HOST"

if [[ ! -f /etc/nixos/hardware-configuration.nix ]]; then
    echo "ERROR: /etc/nixos/hardware-configuration.nix not found."
    echo "Run this on an installed NixOS system."
    exit 1
fi

if [[ -e "$TARGET" ]]; then
    echo "ERROR: Host already exists:"
    echo "  $TARGET"
    exit 1
fi

STATE_VERSION="$(
    sed -n \
      's/.*system\.stateVersion = "\([^"]*\)".*/\1/p' \
      /etc/nixos/configuration.nix |
    tail -n 1
)"

if [[ -z "$STATE_VERSION" ]]; then
    echo "ERROR: Could not determine system.stateVersion."
    echo "Check /etc/nixos/configuration.nix manually."
    exit 1
fi

mkdir -p "$TARGET"

cp /etc/nixos/hardware-configuration.nix \
   "$TARGET/hardware-configuration.nix"

cat > "$TARGET/configuration.nix" <<EOF
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop.nix
  ];

  networking.hostName = "$HOST";

  # ------------------------------------------------------------
  # Machine-specific configuration
  # ------------------------------------------------------------
  #
  # Add this machine's bootloader, filesystem, storage,
  # encryption and hardware-specific options here.
  #
  # Use /etc/nixos/configuration.nix from the fresh installation
  # as a reference.
  #
  # Do NOT copy these settings from another host blindly.

  system.stateVersion = "$STATE_VERSION";
}
EOF

echo
echo "Created:"
echo "  $TARGET/configuration.nix"
echo "  $TARGET/hardware-configuration.nix"
echo
echo "Next:"
echo
echo "1. Edit:"
echo "   $TARGET/configuration.nix"
echo
echo "2. Copy/adapt the machine-specific boot/storage settings from:"
echo "   /etc/nixos/configuration.nix"
echo
echo "3. Add this host to flake.nix:"
echo "   $HOST = mkHost \"$HOST\";"
echo
echo "4. Stage the files:"
echo "   git add ."
echo
echo "5. Run:"
echo "   nix flake check"

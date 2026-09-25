#!/usr/bin/env bash

set -euo pipefail

REPO="${NIXOS_CONFIG_REPO:-$HOME/nixos-config}"
HOST="$(hostname)"
ACTION="${1:-switch}"

case "$ACTION" in
    build|switch|boot)
        ;;
    check)
        echo "Checking flake..."
        cd "$REPO"
        nix flake check

        echo
        echo "Building host: $HOST"
        sudo nixos-rebuild build --flake "$REPO#$HOST"
        exit 0
        ;;
    *)
        echo "Usage: $0 {check|build|switch|boot}"
        exit 1
        ;;
esac

if [[ ! -f "$REPO/hosts/$HOST/configuration.nix" ]]; then
    echo "ERROR: No configuration exists for host:"
    echo "  $HOST"
    echo
    echo "Expected:"
    echo "  $REPO/hosts/$HOST/configuration.nix"
    exit 1
fi

echo "Repository : $REPO"
echo "Host       : $HOST"
echo "Action     : $ACTION"
echo

sudo nixos-rebuild "$ACTION" --flake "$REPO#$HOST"

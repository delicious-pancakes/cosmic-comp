#!/bin/bash
set -euo pipefail

BIN=/usr/bin/cosmic-comp
BACKUP="${BIN}.stock"

# --- backup the stock binary before install.sh replaces it ---
backup() {
    if [ -f "$BACKUP" ]; then
        echo "stock backup already exists at $BACKUP"
        return
    fi
    if [ ! -f "$BIN" ]; then
        echo "error: $BIN not found"
        exit 1
    fi
    sudo cp "$BIN" "$BACKUP"
    echo "backed up stock binary to $BACKUP"
}

# --- restore from backup ---
revert() {
    if [ ! -f "$BACKUP" ]; then
        echo "no backup found at $BACKUP"
        echo "trying: sudo apt reinstall cosmic-comp"
        sudo apt reinstall cosmic-comp
    else
        sudo cp "$BACKUP" "${BIN}.new"
        sudo mv "${BIN}.new" "$BIN"
        echo "restored stock binary from $BACKUP"
    fi
    sudo killall cosmic-comp
    echo "compositor will respawn with stock binary"
}

case "${1:-}" in
    backup)  backup ;;
    revert)  revert ;;
    *)
        echo "usage: $0 {backup|revert}"
        echo ""
        echo "  backup — save current /usr/bin/cosmic-comp before patching"
        echo "  revert — restore saved binary (or apt reinstall) and restart compositor"
        ;;
esac

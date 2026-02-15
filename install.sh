#!/bin/bash
set -euo pipefail

BIN=/usr/bin/cosmic-comp
SRC="$(dirname "$0")/target/release/cosmic-comp"

if [ ! -f "$SRC" ]; then
    echo "build first: cargo build --release"
    exit 1
fi

sudo cp "$SRC" "${BIN}.new"
sudo mv "${BIN}.new" "$BIN"
sudo killall cosmic-comp
echo "installed — compositor will respawn with patched binary"

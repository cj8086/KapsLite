#!/bin/bash
# Remenber to: chmod +x ksync.sh

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SOURCE_FILE="${SCRIPT_DIR}/karabiner.edn"
TARGET_FILE="$HOME/.config/karabiner.edn"


if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: $SOURCE_FILE does not exist!"
    exit 1
fi


mkdir -p "$(dirname "$TARGET_FILE")" || {
    echo "Error: unable to create target directory!"
    exit 1
}


echo "Syncing configuration file..."
if ! rsync -c "$SOURCE_FILE" "$TARGET_FILE"; then
    echo "Error: failed to syncronize!"
    exit 1
fi


if ! cmp -s "$SOURCE_FILE" "$TARGET_FILE"; then
    echo "Warning: inconsistent file content!"
    exit 1
fi


echo "Configuration file synced, running goku..."
if command -v goku &> /dev/null; then
    goku
    exit $?  # Return the exit code of goku
else
    echo "Error: unable to find \"goku\""
    exit 1
fi
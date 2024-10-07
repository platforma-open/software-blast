#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}"

if [ "$#" -ne 3 ]; then
    echo ""
    echo "Usage: '${0}' <version> <os> <arch>"
    echo "       '${0}' 2.16.0 linux x64"
    echo ""
    echo "  OS list:"
    echo "    linux"
    echo "    windows"
    echo "    macosx"
    echo ""
    echo "  Arch list:"
    echo "    x64"
    echo "    aarch64"
    echo ""
    exit 1
fi

#
# Script parameters
#
version="${1}"
os="${2}"
arch="${3}"

pl-pkg publish packages \
    --package-id="${version}" \
    --platform="${os}-${arch}"

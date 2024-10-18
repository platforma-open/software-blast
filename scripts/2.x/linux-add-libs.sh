#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}/../../"

if [ "$#" -ne 2 ]; then
    echo ""
    echo "Usage: '${0}' <version> <arch>"
    echo "       '${0}' 2.16.0 x64"
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
arch="${2}"

os="linux"
dst_root="dld"
dst_data_dir="${dst_root}/blast-${version}-${os}-${arch}"

# Copy libraries into the distribution
cp -R "libs/${arch}/" "${dst_data_dir}/bin/"

# Patch binaries so they find copied libraries
find "${dst_data_dir}/bin/" -type f -executable |
    while read -r binary; do
        patchelf \
            --set-rpath '$ORIGIN' \
            "${binary}"
    done

#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}"

if [ "$#" -ne 1 ]; then
    echo ""
    echo "Usage: '${0}' <version>"
    echo "       '${0}' 2.16.0"
    echo ""
    exit 1
fi

#
# Script parameters
#
version="${1}"

./2.x/pkg-download.sh "${version}" macosx x64
./2.x/pkg-download.sh "${version}" macosx aarch64
./2.x/pkg-download.sh "${version}" linux x64
./2.x/pkg-download.sh "${version}" linux aarch64
./2.x/pkg-download.sh "${version}" windows x64

pl-pkg build packages \
    --package-id="${version}" \
    --all-platforms

pl-pkg build descriptors \
    --package-id="${version}"

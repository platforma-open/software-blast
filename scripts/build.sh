#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"

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

# Fast-track: make descriptors at the very beginning as packages download may take a while
${script_dir}/2.x/pkg-download.sh "${version}" macosx x64
${script_dir}/2.x/pkg-download.sh "${version}" macosx aarch64

${script_dir}/2.x/pkg-download.sh "${version}" linux x64
${script_dir}/2.x/linux-add-libs.sh "${version}" x64
${script_dir}/2.x/pkg-download.sh "${version}" linux aarch64
${script_dir}/2.x/linux-add-libs.sh "${version}" aarch64

${script_dir}/2.x/pkg-download.sh "${version}" windows x64

pl-pkg build --all-platforms

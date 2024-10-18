#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}/../../"

base_url="https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+"

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
dst_root="dld"
dst_data_dir="${dst_root}/blast-${version}-${os}-${arch}"

dst_archive_path="${dst_root}/blast-${version}-${os}-${arch}.tar.gz"

function log() {
    printf "%s\n" "${*}"
}

function download() {
    local _ext="tar.gz"
    local _suffix=""

    local _os="${os}"
    local _arch="${arch}"

    if [ "${os}" == "windows" ]; then
        _os="win64"
    fi
    if [ "${os}" == "macosx" ]; then
        # for older versions of blast, download x64 instead of aarch64 (no aarch64 was built before 2.16.0)
        _arch="x64"
    fi

    local _url="${base_url}/${version}/ncbi-blast-${version}+-${_arch}-${_os}.${_ext}"

    local _show_progress=("--show-progress")
    if [ "${CI:-}" = "true" ]; then
        _show_progress=()
    fi

    log "Downloading '${_url}'"
    wget --quiet "${_show_progress[@]}" --output-document="${dst_archive_path}" "${_url}"
}

function unpack() {
    log "Unpacking archive for ${os} to '${dst_data_dir}'"

    rm -rf "${dst_data_dir}"
    mkdir "${dst_data_dir}"

    tar -x \
        -C "${dst_data_dir}" \
        --file "${dst_archive_path}" \
        --strip-components 1 \
        "ncbi-blast-${version}+"
}

mkdir -p "${dst_root}"
download
unpack

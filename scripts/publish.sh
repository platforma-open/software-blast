#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}/.."

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
files_to_check=(
    "dist/tengo/software/blast_formatter-${version}.sw.json"
    "dist/tengo/software/blast_formatter_vdb-${version}.sw.json"
    "dist/tengo/software/blast_vdb_cmd-${version}.sw.json"
    "dist/tengo/software/blastdb_aliastool-${version}.sw.json"
    "dist/tengo/software/blastdbcheck-${version}.sw.json"
    "dist/tengo/software/blastdbcmd-${version}.sw.json"
    "dist/tengo/software/blastn-${version}.sw.json"
    "dist/tengo/software/blastn_vdb-${version}.sw.json"
    "dist/tengo/software/blastp-${version}.sw.json"
    "dist/tengo/software/blastx-${version}.sw.json"
    "dist/tengo/software/convert2blastmask-${version}.sw.json"
    "dist/tengo/software/deltablast-${version}.sw.json"
    "dist/tengo/software/dustmasker-${version}.sw.json"
    "dist/tengo/software/makeblastdb-${version}.sw.json"
    "dist/tengo/software/makembindex-${version}.sw.json"
    "dist/tengo/software/makeprofiledb-${version}.sw.json"
    "dist/tengo/software/psiblast-${version}.sw.json"
    "dist/tengo/software/rpsblast-${version}.sw.json"
    "dist/tengo/software/rpstblastn-${version}.sw.json"
    "dist/tengo/software/segmasker-${version}.sw.json"
    "dist/tengo/software/tblastn-${version}.sw.json"
    "dist/tengo/software/tblastn_vdb-${version}.sw.json"
    "dist/tengo/software/tblastx-${version}.sw.json"
    "dist/tengo/software/windowmasker-${version}.sw.json"
)

for f in "${files_to_check[@]}"; do
    if ! [ -f "${f}" ]; then
        echo ""
        echo "No software descriptor found at '${f}'."
        echo ""
        echo "Looks like you're going to publish new version of blast distribution."
        echo "See README.md for the instructions on how to do this properly."
        echo ""

        exit 1
    fi
done

pl-pkg sign packages \
    --package-id="${version}" \
    --all-platforms \
    --sign-command='["gcloud-kms-sign", "{pkg}", "{pkg}.sig"]'

pl-pkg publish packages \
    --package-id="${version}" \
    --force \
    --all-platforms

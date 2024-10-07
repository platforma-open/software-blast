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

pl-pkg sign packages \
    --package-id="${version}" \
    --all-platforms \
    --sign-command='["gcloud-kms-sign", "{pkg}", "{pkg}.sig"]'

pl-pkg publish packages \
    --package-id="${version}" \
    --force \
    --all-platforms

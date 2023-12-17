#!/usr/bin/env bash
set -ex

CALLER_DIR="${PWD}"
WORKING_DIR="/tmp/.temp-$(basename "$0")"

echo "Install Bitcoin."

RELEASES_JSON_URL="https://api.github.com/repos/bitcoin/bitcoin/releases/latest"
RELEASE_VERSION="$(curl --silent --location "$RELEASES_JSON_URL" \
    | grep --max-count 1 "\"tag_name\": " \
    | sed "s|^\s*\".*\": \"v\(.*\)\".*\$|\1|")"

CHECKSUMS_URL="https://bitcoincore.org/bin/bitcoin-core-${RELEASE_VERSION}/SHA256SUMS"
PACKAGE_URL="https://bitcoincore.org/bin/bitcoin-core-${RELEASE_VERSION}/bitcoin-${RELEASE_VERSION}\
-x86_64-linux-gnu.tar.gz"
OUTPUT_FILE="bitcoin-${RELEASE_VERSION}-x86_64-linux-gnu.tar.gz"

mkdir "$WORKING_DIR"
cd "$WORKING_DIR"

download.sh --name guix-sigs.tar.gz \
    "https://codeload.github.com/bitcoin-core/guix.sigs/tar.gz/refs/heads/main"
compress.sh --decompress guix-sigs.tar.gz
rm guix-sigs.tar.gz
for FILE in guix.sigs-main/builder-keys/*.gpg; do
    cat "$FILE" | gpg --yes --dearmor >> signature-public-keys.gpg
done
rm -r guix.sigs-main
download.sh --name checksums "$CHECKSUMS_URL"
download.sh --name checksums.asc "${CHECKSUMS_URL}.asc"
gpg --keyring ./signature-public-keys.gpg --no-default-keyring --quiet \
        --verify checksums.asc checksums
rm checksums.asc signature-public-keys.gpg
download.sh --name "$OUTPUT_FILE" "$PACKAGE_URL"
sha256sum --ignore-missing --check checksums
rm checksums
compress.sh --decompress "$OUTPUT_FILE"
rm "$OUTPUT_FILE"
mv bitcoin-* bitcoin
rm bitcoin/bitcoin.conf bitcoin/README.md
mv bitcoin "${CALLER_DIR}/bitcoin"

rm -f -r "$WORKING_DIR"

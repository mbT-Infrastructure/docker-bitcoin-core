#!/usr/bin/env bash
set -e

mkdir --parents /media/bitcoin/config /media/bitcoin/data ~/.bitcoin/

sed --expression "s|###CHAIN###|${CHAIN}|g" \
    /opt/bitcoin/template/bitcoin.conf > ~/.bitcoin/bitcoin.conf

if [[ ! -f /media/bitcoin/config/bitcoin.conf ]]; then
    touch /media/bitcoin/config/bitcoin.conf
fi

exec "$@"

# Bitcoin Core image

This Container image extends the
[base image](https://github.com/mbT-Infrastructure/docker-base).

This image contains an in Installation of the Bitcoin Core software.

It starts bitcoind without a wallet.
The RPC auth cookie is available in `/media/bitcoin/data/.cookie`.


## Environment variables

- `CHAIN`
    - Use the specified chain, default: `main`.


## Volumes

- `/media/bitcoin/data`
    - The data directory of bitcoind.
- `/media/bitcoin/config`
    - Config directory for additional config for bitcoind in `bitcoin.conf`.


## Development

To build and run for development run:
```bash
docker compose --file docker-compose-dev.yaml up --build
```

To build the image locally run:
```bash
./docker-build.sh
```

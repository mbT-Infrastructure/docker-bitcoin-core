FROM madebytimo/scripts AS builder

COPY files/bitcoin-download.sh /usr/local/bin/

WORKDIR /root/builder
RUN bitcoin-download.sh


FROM madebytimo/base

WORKDIR /opt/bitcoin
COPY --from=builder /root/builder/bitcoin .
RUN mkdir /opt/bitcoin/template
COPY files/bitcoin.conf /opt/bitcoin/template

ENV CHAIN="main"

COPY entrypoint.sh /entrypoint.sh

WORKDIR /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/opt/bitcoin/bin/bitcoind" ]

FROM iexechub/sconecuratedimages-iexec:cli-alpine AS scone

FROM iexechub/sconecuratedimages-iexec:python-3.7.3-alpine-3.10

COPY --from=scone   /opt/scone/scone-cli    /opt/scone/scone-cli
COPY --from=scone   /usr/local/bin/scone    /usr/local/bin/scone
COPY --from=scone   /opt/scone/bin          /opt/scone/bin

################################

### install apk packages
RUN apk add --no-cache bash build-base gcc libgcc

### install python3 dependencies
RUN SCONE_MODE=sim pip3 install attrdict python-gnupg web3

### copy the code inside the image
COPY ./src /app
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

################################

###  protect file system with scone
COPY ./protect-fs.sh /protect-fs.sh
RUN bash /protect-fs.sh /app
RUN rm /protect-fs.sh /keytag

ENTRYPOINT /entrypoint.sh

#docker image build -t nexus.iex.ec/tee-hello-with-dataset:3.0.0 .

FROM sconecuratedimages/iexec:python-3.6.6-alpine3.6

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories \
 && apk update \
 && apk add --update-cache --no-cache libgcc libquadmath musl \
 && apk add --update-cache --no-cache libgfortran \
 && apk add --update-cache --no-cache lapack-dev \
 && apk --no-cache --update-cache add gcc gfortran python python-dev py-pip build-base wget freetype-dev libpng-dev \
 && apk add --no-cache --virtual .build-deps gcc musl-dev 

RUN SCONE_MODE=sim pip install cython scipy==1.2.0 scikit-learn nilearn matplotlib attrdict python-gnupg web3

RUN cp /usr/bin/python3.6 /usr/bin/python3

COPY signer	/signer

COPY app	/app

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT /docker-entrypoint.sh



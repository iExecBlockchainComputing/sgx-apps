FROM nexus.iex.ec/scone-python

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


#ENTRYPOINT python3 /app/test.py
ENTRYPOINT mkdir -p /iexec_in/data && unzip /iexec_in/smith_2009.zip -d /iexec_in/data && python3 app/nilearn_test.py sgx



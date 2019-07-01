#!/bin/bash
export IMAGE_NAME=$1
mkdir conf

docker build -f Dockerfile2 -t $IMAGE_NAME .

MRENCLAVE=$(docker run --device=/dev/isgx -e SCONE_HEAP=1G -e SCONE_HASH=1 -e SCONE_ALPINE=1 nexus.iex.ec/python_scone python)

docker run  -v "$PWD/python:/python" -v "$PWD/app:/app" -v "$PWD/signer:/signer" -v "$PWD/python/python3.6:/usr/lib/python3.6" -v "$PWD/conf:/conf" nexus.iex.ec/scone-cli sh -c \
"scone fspf create conf/fspf.pb; \
scone fspf addr conf/fspf.pb /  --not-protected --kernel /; \
scone fspf addr conf/fspf.pb /usr/lib/python3.6 --authenticated --kernel /usr/lib/python3.6; \
scone fspf addf conf/fspf.pb /usr/lib/python3.6 /usr/lib/python3.6;\
scone fspf addr conf/fspf.pb /usr/bin --authenticated --kernel /usr/bin; \
scone fspf addf conf/fspf.pb /usr/bin /usr/bin;\
scone fspf addr conf/fspf.pb /signer --authenticated --kernel /signer; \
scone fspf addf conf/fspf.pb /signer /signer;\
scone fspf addr conf/fspf.pb /app --authenticated --kernel /app; \
scone fspf addf conf/fspf.pb /app /app;\
scone fspf encrypt ./conf/fspf.pb > /conf/keytag;"


FSPF_TAG=$(cat conf/keytag | awk '{print $9}')
FSPF_KEY=$(cat conf/keytag | awk '{print $11}')

FINGERPRINT="$FSPF_KEY|$FSPF_TAG|$MRENCLAVE"
echo $FINGERPRINT
envsubst < DockerAddFspfTmp > DockerAddFspf

docker build -f DockerAddFspf -t $IMAGE_NAME .

echo "Fingerprint: $FINGERPRINT" > fingerprint

rm -r -f python
rm -r -f conf

rm -f DockerAddFspf

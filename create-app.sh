#!/bin/bash


IMAGE_NAME=$1

# build app with required dependencies and libs
docker build -f app-first-build.dockerfile -t $IMAGE_NAME .

# get mrenclave of python interpreter
MRENCLAVE=$(docker run \
                -e SCONE_MODE=sim \
                -e SCONE_HEAP=1G \
                -e SCONE_HASH=1 \
                -e SCONE_ALPINE=1 \
                nexus.iex.ec/python_scone python)

# create fspf.pb
docker run -e SCONE_MODE=sim \
    -v $PWD/python:/python \
    -v $PWD/app:/app \
    -v $PWD/signer:/signer \
    -v $PWD/python/python3.6:/usr/lib/python3.6 \
    -v $PWD/conf:/conf \
    nexus.iex.ec/scone-cli sh -c \
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

# get fingerprint
FSPF_TAG=$(cat conf/keytag | awk '{print $9}')
FSPF_KEY=$(cat conf/keytag | awk '{print $11}')
FINGERPRINT="$FSPF_KEY|$FSPF_TAG|$MRENCLAVE"
echo "Fingerprint: $FINGERPRINT" | tee fingerprint.txt

# copy fspf.pb into app image
case "$(uname -s)" in
    Linux*)     sed -i "s/@IMAGE@/$IMAGE_NAME/" app-second-build.dockerfile;;
    Darwin*)    sed -e "s/@IMAGE@/$IMAGE_NAME/" -i "" app-second-build.dockerfile;;
esac

docker build -f app-second-build.dockerfile -t $IMAGE_NAME .

rm -rf python
rm -rf conf

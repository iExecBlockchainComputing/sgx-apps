#!/bin/bash

# ./create-app.sh --app-name=<name:tag> --app-folder=<path> --dockerfile=dockerfile

#Check input params
for i in "$@"
do
case $i in
    --app-name=*)
    APP_NAME="${i#*=}"
    shift
    ;;
    --app-folder=*)
    APP_FOLDER="${i#*=}"
    shift
    ;;
    --dockerfile=*)
    DOCKERFILE="${i#*=}"
    shift
    ;;
esac
done

## REQUIRED
if [[ -z $APP_NAME ]]; then
    echo "--app-name=<image name> required"
    exit
fi
if [[ -z $APP_FOLDER ]]; then
    echo "--app-folder=<path> required"
    exit
fi
if [[ -z $DOCKERFILE ]]; then
    DOCKERFILE="dockerfile"
fi

# build app with required dependencies and libs
docker build -f "$APP_FOLDER/$DOCKERFILE" -t $APP_NAME ./$APP_FOLDER

# get mrenclave of python interpreter
MRENCLAVE=$(docker run \
                -e SCONE_MODE=sim \
                -e SCONE_HEAP=1G \
                -e SCONE_HASH=1 \
                -e SCONE_ALPINE=1 \
                nexus.iex.ec/python_scone python)

docker run --rm --entrypoint="" -v $PWD/python:/python $APP_NAME sh -c "cp -r /usr/lib/python3.6 /python;"

# create fspf.pb
docker run -e SCONE_MODE=sim \
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

rm -rf python

# get fingerprint
FSPF_TAG=$(cat conf/keytag | awk '{print $9}')
FSPF_KEY=$(cat conf/keytag | awk '{print $11}')
FINGERPRINT="$FSPF_KEY|$FSPF_TAG|$MRENCLAVE"

# copy fspf.pb into app image
case "$(uname -s)" in
    Linux*)     sed "s@IMAGE_NAME@$APP_NAME@" template.dockerfile > second-build.dockerfile;;
    Darwin*)    sed -e "s@IMAGE_NAME@$APP_NAME@" template.dockerfile > second-build.dockerfile;;
esac

docker build -f second-build.dockerfile -t $APP_NAME .

echo "Fingerprint: $FINGERPRINT" | tee fingerprint.txt

# clean
rm second-build.dockerfile
rm -rf conf

#!/bin/bash

# ./local-test.sh --dataset=<path/to/dataset> --app-name=<image:tag>

#Check input params
for i in "$@"
do
case $i in
    --app=*)
    APP="${i#*=}"
    shift
    ;;
    --app-fingerprint=*)
    APP_FINGERPRINT="${i#*=}"
    shift
    ;;
    --dataset=*)
    DATASET="${i#*=}"
    DATASET_NAME="${DATASET##*/}"
    DATASET_NAME="${DATASET_NAME%.zip}"
    shift
    ;;
    --dataset-secret=*)
    DATASET_SECRET="${i#*=}"
    shift
    ;;
esac
done


echo "Dataset name: $DATASET_NAME, pwd: $PWD"

##required
if [[ -z $APP ]]; then
    echo "--app=<image name> required"
    exit
fi


##adding default value
if [[ -z $APP_FINGERPRINT ]]; then
    APP_FINGERPRINT="fingerprint.txt"
fi
if [[ -z $DATASET_SECRET ]]; then
    DATASET_SECRET="$PWD/.tee-secrets/dataset/$DATASET_NAME.scone.secret"
fi

##parses fingerprint and secret, generate session conf file and upload the session to CAS
export FSPF_TAG=$(cut -d'|' -f2 <<< $(cat $APP_FINGERPRINT))
export FSPF_KEY=$(cut -d'|' -f1 <<< $(cat $APP_FINGERPRINT))
export MRENCLAVE=$(cut -d'|' -f3 <<< $(cat $APP_FINGERPRINT))

export DATA_FSPF_KEY=$(cut -d'|' -f1 <<< $(cat $DATASET_SECRET))
export DATA_FSPF_TAG=$(cut -d'|' -f2 <<< $(cat $DATASET_SECRET))

export SESSION_NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

if [[ -z $DATASET ]]; then
        envsubst < sessionTemplateNoData.yml > session.yml
else
        envsubst < sessionTemplate.yml > session.yml
fi

docker run --detach --device=/dev/isgx  -p 18766:18766 sconecuratedimages/iexec:las

docker run --detach --device=/dev/isgx  -p 18765:18765 -p 8081:8081 sconecuratedimages/iexec:cas


curl -k -s --cert client.crt --key client-key.key --data-binary @session.yml -X POST https://127.0.0.1:8081/session

##launches the app


docker run --network=host -e "SCONE_CAS_ADDR=127.0.0.1:18765" -e "SCONE_LAS_ADDR=127.0.0.1:18766" -e "SCONE_HEAP=2G" \
-e "SCONE_ALPINE=1" -e "SCONE_DEBUG=7" -e "SCONE_CONFIG_ID=$SESSION_NAME/app"  --device=/dev/isgx -v \
"$DATASET:/iexec_in/$DATASET_NAME" -e "DATASET_FILENAME=$DATASET_NAME" -v "$PWD/scone:/scone" -e "SCONE_VERSION=1" -e "SCONE_LOG=7" -it $APP

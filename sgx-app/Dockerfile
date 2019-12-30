FROM iexechub/python-scone

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories \
    && apk update \
    && apk add --update-cache --no-cache libgcc \
    && apk --no-cache --update-cache add gcc gfortran python python-dev py-pip build-base wget freetype-dev libpng-dev \
    && apk add --no-cache --virtual .build-deps gcc musl-dev


RUN SCONE_MODE=sim pip install attrdict python-gnupg web3

RUN cp /usr/bin/python3.6 /usr/bin/python3

COPY src /app

RUN SCONE_MODE=sim SCONE_HASH=1 SCONE_HEAP=1G SCONE_ALPINE=1		    \
	&& mkdir conf							    \
	&& scone fspf create fspf.pb 					    \
	&& scone fspf addr fspf.pb /  --not-protected --kernel /            \
	&& scone fspf addr fspf.pb /usr --authenticated --kernel /usr       \
	&& scone fspf addf fspf.pb /usr /usr 			            \
	&& scone fspf addr fspf.pb /bin --authenticated --kernel /bin       \
	&& scone fspf addf fspf.pb /bin /bin 			            \
	&& scone fspf addr fspf.pb /lib --authenticated --kernel /lib       \
	&& scone fspf addf fspf.pb /lib /lib 			            \
	&& find /etc -maxdepth 1 -not -name 'hosts' -not -name 'resolv.conf' -not -name 'hostname' -not -name 'etc' -not -name 'mtab' -print0 | xargs -t -n 1 -I {} scone fspf addr fspf.pb {} --authenticated --kernel {} \
 	&& find /etc -maxdepth 1 -not -name 'hosts' -not -name 'resolv.conf' -not -name 'hostname' -not -name 'etc' -not -name 'mtab' -print0 | xargs -t -n 1 -I {} scone fspf addf fspf.pb {} {} \
	&& scone fspf addr fspf.pb /sbin --authenticated --kernel /sbin     \
	&& scone fspf addf fspf.pb /sbin /sbin 			            \
	&& scone fspf addr fspf.pb /signer --authenticated --kernel /signer \
	&& scone fspf addf fspf.pb /signer /signer 			    \
	&& scone fspf addr fspf.pb /app --authenticated --kernel /app 	    \
	&& scone fspf addf fspf.pb /app /app 				    \
	&& scone fspf encrypt ./fspf.pb > /conf/keytag 			    \
	&& MRENCLAVE="$(SCONE_HASH=1 python)"			            \
	&& FSPF_TAG=$(cat conf/keytag | awk '{print $9}') 	            \
	&& FSPF_KEY=$(cat conf/keytag | awk '{print $11}')		    \
	&& FINGERPRINT="$FSPF_KEY|$FSPF_TAG|$MRENCLAVE"			    \
	&& echo $FINGERPRINT > conf/fingerprint.txt			    \
	&& printf "\n########################################################\nMREnclave: $FINGERPRINT\n########################################################\n\n"


ENTRYPOINT unzip -o /iexec_in/$IEXEC_DATASET_FILENAME -d /iexec_in && python3 /app/app.py

#docker image build -t nexus.iex.ec/sgx-app:it-1.0.1 .

########################################################
#MREnclave: 684075e1d075934cdfda68b0078f6577759c17c9185a24a43f47c961b32febfd|b3111d9c8c95cdb363858b49aede45bc|b84bc68bae8cdc8703ca4525b2cc16deffe9def4247498ebcc467830a67caf6d
########################################################

#docker image build -t nexus.iex.ec/sgx-app:it-1.0.2 .

########################################################
#MREnclave: b3fd442e062225342e799d167ff2e88ef460a0890b76aa29d5fed8938d27cc8c|e7daba8433800a8d0fda8bb9012e1f14|4e6758e38f332d8eb718bc0037dbdedd00d3bb196dd3ff894938b32156179c38
########################################################


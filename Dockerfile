FROM nexus.iex.ec/python_scone

RUN mkdir /iexec_in
COPY app.py /app.py

ENTRYPOINT mkdir -p /iexec_in/data && unzip /iexec_in/$DATASET_FILENAME -d /iexec_in/data && python3 /app.py

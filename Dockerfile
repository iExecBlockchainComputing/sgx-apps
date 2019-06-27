FROM nexus.iex.ec/python_scone

COPY app.py /app.py

ENTRYPOINT mkdir -p /data && unzip /iexec_in/$DATASET_FILENAME -d /data && python3 /app.py

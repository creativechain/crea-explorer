FROM python:3.6.6

RUN apt-get update && apt-get install -y vim make gcc libssl-dev

RUN pip3 install crea pymongo scrypt

CMD ["python", "/src/sync.py"]

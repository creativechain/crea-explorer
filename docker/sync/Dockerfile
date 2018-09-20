FROM python:3.6.6

RUN apt-get update && apt-get install -y make gcc libssl-dev

RUN pip3 install beem pymongo scrypt

CMD ["python", "/src/sync.py"]

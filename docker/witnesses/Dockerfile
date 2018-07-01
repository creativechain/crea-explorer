FROM python:3.6.6

ENV steemnode peer.vit.tube

RUN apt-get update && \
    apt-get install -y git make gcc libssl-dev libgmp-dev python-dev libxml2-dev libxslt1-dev zlib1g-dev

RUN git clone https://github.com/netuoso/piston-lib/ && cd piston-lib && python3 setup.py install --user

RUN pip3 install steem pymongo scrypt apscheduler pathlib

COPY . /src

CMD ["python3", "/src/witnesses.py"]

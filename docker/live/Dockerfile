FROM python:3.6.6

RUN apt-get update && \
    apt-get install -y vim git make gcc libssl-dev libgmp-dev python-dev libxml2-dev libxslt1-dev zlib1g-dev

RUN pip3 install crea pymongo scrypt autobahn

RUN pip3 install twisted

COPY . /src

EXPOSE 8681

CMD ["python", "/src/live.py"]

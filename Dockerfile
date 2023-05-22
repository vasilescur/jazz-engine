FROM ubuntu:22.04

RUN apt-get update && apt-get install -y python3.11 python3-pip vim software-properties-common
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1
RUN python -m pip install --upgrade pip

RUN apt-add-repository ppa:swi-prolog/stable
RUN apt-get update && apt-get install -y swi-prolog

ENTRYPOINT [ "/bin/bash" ]


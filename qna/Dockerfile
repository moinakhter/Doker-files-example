#Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL maintainer="dizzyassistant.com"
LABEL version="1.0"
LABEL description="Dizzy assistant question answering service."

ENV UNAME dizzy
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Changing root user password
RUN echo "root:dizzy" | chpasswd

# Update Ubuntu Software repository and install needed dependencies.
RUN apt-get update && apt-get install -y redis-server \
    build-essential \
    sudo \
    software-properties-common \
    libffi-dev

# Installing python version 3.9.13
RUN add-apt-repository ppa:deadsnakes/ppa -y

RUN apt install -y python3.9 \
    python3.9-minimal \
    python3.9-venv \
    libpython3.9-stdlib \
    libpython3.9-minimal \
    python3-pip

#changing python path to access environment python
RUN ln -sf /usr/bin/python3.9 /usr/local/bin/python3.9

RUN python3.9 -m pip install pipenv

#Adding a user with it's password
RUN useradd -m dizzy && echo "dizzy:dizzy" | chpasswd && adduser dizzy sudo

# Adding redis-server password to the redis.conf
RUN sed -i 's/# requirepass foobared/requirepass darvis/' /etc/redis/redis.conf

USER dizzy

ENV HOME /home/dizzy
WORKDIR /home/dizzy

CMD echo "dizzy" | su root service redis-server start &&  /home/dizzy/Dizzy/.venv/bin/python /home/dizzy/Dizzy/question_answering/__main__.py
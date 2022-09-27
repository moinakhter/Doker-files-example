#Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL maintainer="dizzyassistant.com"
LABEL version="1.0"
LABEL description="Dizzy assistant main service."

ENV UNAME dizzy

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Adding root password
RUN echo "root:dizzy" | chpasswd

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# Adding a user
RUN useradd -m dizzy && echo "dizzy:dizzy" | chpasswd && adduser dizzy sudo

# Update Ubuntu Software repository and install needed dependencies.
RUN apt-get update && apt-get install -y sudo \
    build-essential \
    tzdata \
    redis-server \
    software-properties-common \
    python3 \
    python3.9 \
    wget \
    curl

# Copying Pulse Configration file to the docker image.
COPY pulse-client.conf /etc/pulse/client.conf

# Copying Scripts files
COPY commands/ /home/${UNAME}/Dizzy/commands/
COPY services/ /home/${UNAME}/Dizzy/services/
COPY shells/ /home/${UNAME}/Dizzy/shells/


# Copying nltk_data directory to avoid waiting for downloading from the internet.
COPY nltk_data/ /home/${UNAME}/nltk_data/

# Delpying assistant command
RUN  bash -l /home/${UNAME}/Dizzy/commands/deploy.sh -d

#Installing dependencies of the system with python version
RUN assistant -o setup;
RUN  /home/${UNAME}/Dizzy/shells/python_install.sh
RUN ln -sf /usr/bin/python3.9 /usr/local/bin/python3.9

# setted default user for the docker image
USER dizzy

# installing pipenv using default user.
RUN python3.9 -m pip install pipenv


ENV HOME /home/dizzy
WORKDIR /home/dizzy

CMD [ ! -d /home/dizzy/Dizzy/.venv/lib/python3.9/site-packages/nltk ] &&  cd /home/dizzy/Dizzy/ &&  assistant -e setup; echo "dizzy" | su root service redis-server start && /home/dizzy/Dizzy/.venv/bin/python /home/dizzy/Dizzy/assistant/__main__.py

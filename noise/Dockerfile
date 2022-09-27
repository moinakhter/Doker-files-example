#Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL maintainer="dizzyassistant.com"
LABEL version="1.0"
LABEL description="Dizzy assistant noise suppression service."

ENV UNAME dizzy
# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Changing the root user password
RUN echo "root:dizzy" | chpasswd

# Update Ubuntu Software repository and install needed dependencies.
RUN apt-get update && apt-get install -y sudo \
    redis-server \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    libfann-dev \
    libffi-dev \
    libicu-dev \
    libjpeg-dev \
    libglib2.0-dev \
    libssl-dev \
    libtool \
    libpulse0 \
    pulseaudio  \
    portaudio19-dev \
    pulseaudio \
    pulseaudio-utils \
    build-essential \
    ladspa-sdk \
    nano \
    autoconf \
    automake \
    bison \
    build-essential \
    curl  \
    flac \
    git \
    jq \
    libfann-dev \
    libffi-dev \
    libicu-dev \
    libjpeg-dev \
    libglib2.0-dev \
    libssl-dev \
    libtool \
    locales \
    mpg123 \
    pkg-config \
    portaudio19-dev \
    pulseaudio \
    pulseaudio-utils \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    screen \
    sudo \
    swig \
    wget \
    htop \
    ffmpeg \
    net-tools \
    ssh \
    openssh-server \
    redis-server \
    alsa-utils \
    systemd systemd-sysv

RUN pip install rnnoise_cli

# Adding a user
RUN useradd -m dizzy && echo "dizzy:dizzy" | chpasswd && adduser dizzy sudo

# Copying Pulse Configration file to the docker image.
COPY pulse-client.conf /etc/pulse/client.conf

# Adding redis-server password to the redis.conf
RUN sed -i 's/# requirepass foobared/requirepass darvis/' /etc/redis/redis.conf

USER $UNAME

ENV HOME /home/dizzy
WORKDIR /home/dizzy

CMD echo "dizzy" | su root  service redis-server start &&  /home/dizzy/Dizzy/.venv/bin/python /home/dizzy/Dizzy/dependencies/noise_suppression/__main__.py activate
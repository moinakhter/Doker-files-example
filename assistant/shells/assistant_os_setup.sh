#!/usr/bin/env bash


sudo apt-get update && sudo apt-get install -y \
    pipenv \
    autoconf \
    automake \
    bison \
    build-essential \
    curl \
    flac \
    git \
    jq \
    libfann-dev \
    libffi-dev \
    libicu-dev \
    libjpeg-dev \
    libglib2.0-dev \
    libssl-dev \
    binutils \
    libtool \
    locales \
    mpg123 \
    pkg-config \
    portaudio19-dev \
    pulseaudio \
    pulseaudio-utils \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-venv \
    python3.9 \
    screen \
    sudo \
    swig \
    wget \
    htop \
    ffmpeg \
    nvidia-cuda-toolkit \
    net-tools \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    nano \
    ssh \
    openssh-server \
    redis-server \
    cmake \
    alsa-utils \
    alsa-base \
    alsa-tools \
    alsa-source \
    libsqlite3-dev \
    systemd systemd-sysv \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libreadline-dev \
    libbz2-dev


# Adding redis-server password to the redis.conf
sudo chmod u+x /etc/redis/redis.conf
sudo sed -i 's/# requirepass foobared/requirepass darvis/' /etc/redis/redis.conf
sudo systemctl restart redis
wait

# after installing dependncies time for installing python 3.9.13 and pipenv
USER_DIR=$(echo ~)

MY_PID=$!
EXIT_STATUS=$?
EXECUTION_STATUS=$( echo "$EXIT_STATUS" | grep 0 )

if [ "$EXECUTION_STATUS" == 0 ]; then
  sh ./python_install.sh
  sudo ln -sf /usr/bin/python3.9 /usr/local/bin/python3.9
  python3.9 -m pip install -U pip
  python3.9 -m pip install pipenv
  python3.9 -m pip install -U pipenv
  printf "${YELLOW}OS Dependencies Setup completed successfully${NC}\n"
  exit 0
else
  echo "Could not execute try agian!!"
  echo "The exit status of the process was $EXIT_STATUS"
  exit 0
fi

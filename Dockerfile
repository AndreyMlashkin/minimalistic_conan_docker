FROM ubuntu:latest

RUN \
  apt-get update && \
  apt-get install -y python3 python3-pip

RUN pip3 install conan

# install initial build tools using apt-get
RUN apt-get update && \
apt-get install -y make \
gcc \
g++ \
cmake

# compile build tools with conan:
COPY initial_profile /root/.conan/profiles/default
COPY requirements.txt requirements.txt
RUN conan install requirements.txt --build missing -g virtualenv

# remove initial build tools:
RUN apt-get remove -y make gcc g++

# try to compile using tools from conan:
COPY host_profile /root/.conan/profiles/host_profile
RUN ls -l -a && chmod +x activate.sh && . ./activate.sh && \
conan install zlib/1.2.12@ --build zlib -pr:b=default -pr:h=host_profile --build missing 

ENTRYPOINT /bin/sh


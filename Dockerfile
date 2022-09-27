FROM ubuntu:22.04

RUN \
  apt-get update && \
  apt-get install -y python3 python3-pip

RUN pip3 install conan

RUN apt-get update && \
apt-get install -y make \
gcc \
g++ \
cmake

COPY initial_profile /root/.conan/profiles/default
COPY requirements.txt requirements.txt
RUN conan install requirements.txt --build missing -g virtualenv
RUN apt-get remove -y make gcc g++

COPY host_profile /root/.conan/profiles/host_profile
RUN conan config set general.cmake_generator=Ninja
RUN conan config set tools.cmake.cmaketoolchain=Ninja

RUN ls -l -a && chmod +x activate.sh && . ./activate.sh && \
conan install zlib/1.2.12@ --build zlib -pr:b=default -pr:h=host_profile --build missing 

ENTRYPOINT /bin/sh


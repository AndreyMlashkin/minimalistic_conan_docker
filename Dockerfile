FROM ubuntu:latest

RUN \
  apt-get update && \
  apt-get install -y python3 python3-pip

RUN pip3 install conan --pre

# install initial build tools using apt-get
RUN apt-get update && \
apt-get install -y make \
gcc \
g++ \
cmake

# compile build tools with conan:
COPY build_profile /root/.conan2/profiles/build_profile
COPY requirements.txt requirements.txt
RUN conan install requirements.txt --build missing -g virtualenv --profile:build=build_profile --profile:host=build_profile

# remove initial build tools:
RUN apt-get remove -y make gcc g++

# try to compile using tools from conan:
COPY host_profile /root/.conan2/profiles/host_profile
RUN ls -l -a && chmod +x activate.sh && . ./activate.sh && \
cmake --help && \
echo $CC && \
echo $CXX && \
conan install zlib/1.2.13@ --build zlib -pr:b=host_profile -pr:h=host_profile --build missing

ENTRYPOINT /bin/sh


FROM ubuntu:latest

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends python3 python3-pip

RUN pip3 install conan

# install initial build tools using apt-get
RUN apt-get update && \
apt-get install -y make \
gcc \
g++ \
cmake

# compile build tools with conan:
RUN conan profile detect
COPY build_profile /root/.conan2/profiles/build_profile
COPY requirements.txt requirements.txt
RUN conan install requirements.txt --build missing -g VirtualBuildEnv --profile:build=build_profile --profile:host=build_profile

# remove initial build tools:
RUN apt-get remove -y make gcc g++

# try to compile using tools from conan:
COPY host_profile /root/.conan/profiles/host_profile
RUN ls -l -a && chmod +x conanbuild.sh && . ./conanbuild.sh && \
cmake --help && \
echo $CC && \
echo $CXX && \
conan install zlib/1.2.13@ --build zlib -pr:b=host_profile -pr:h=host_profile --build missing

ENTRYPOINT /bin/sh


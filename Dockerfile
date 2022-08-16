FROM alpine:latest

RUN apk add --no-cache linux-headers
RUN apk add --no-cache py3-pip
RUN pip3 install conan

COPY initial_profile /root/.conan/profiles/default

#TODO: unite commands from "apk add" to "apk del" into one to have a small docker layer. 
RUN apk add --no-cache make \
gcc \
g++ \
cmake

COPY build_profile /root/.conan/profiles/gcc_build
RUN conan new mypackage/1.0 -t
RUN conan create . --build missing --profile:host=gcc_build --profile:build=default

RUN apk del make gcc g++

ENTRYPOINT /bin/sh


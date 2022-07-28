FROM alpine:latest

RUN apk add --no-cache py3-pip
      
RUN pip3 install conan
COPY initial_profile /root/.conan/profiles/default
RUN apk add --no-cache make \
gcc \
g++ && \
conan install gcc/10.2.0@ --build missing && \
conan install cmake/3.23.1@ --build missing && \
apk del make gcc g++

RUN cat /root/.conan/profiles/default
COPY build_profile /root/.conan/profiles/default

# test if image is valid; to be deleted:
RUN conan install zlib/1.2.12@ --build missing

ENTRYPOINT /bin/sh


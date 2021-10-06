FROM ubuntu:18.04 as base-image

RUN apt-get update -qqy \
  && apt-get install -qqy --no-install-recommends \
        ssh \
        build-essential \
        libxml2-dev \
        libxslt1-dev \
        nodejs \
        gpg \
        curl \
        git \
        ruby-full \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && gem update --system \
 && gem install bundler:1.16.6



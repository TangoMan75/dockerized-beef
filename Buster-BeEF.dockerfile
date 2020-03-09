#/**
# * TangoMan Buster-BeEF.dockerfile
# *
# * @version  0.1.0
# * @author   "Matthias Morin" <mat@tangoman.io>
# * @licence  MIT
# * @link     https://github.com/TangoMan75/dockerized-beef
# */

# based on Debian 10 (buster)
FROM ruby:2.5.7-slim-buster

# Set default language (avoid perl utf8 error)
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

EXPOSE 80

# install all beef dependencies
RUN apt-get update -y \
    && apt-get install -y autoconf automake bison build-essential curl git libc6-dev libcurl4-openssl-dev libncurses5-dev libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt1-dev libyaml-dev nodejs openssl ruby-dev sqlite3 zlib1g zlib1g-dev \
    && echo "printf \"\\033[0;36m _____%17s_____\\n|_   _|___ ___ ___ ___|%5s|___ ___\\n  | | | .'|   | . | . | | | | .'|   |\\n  |_| |__,|_|_|_  |___|_|_|_|__,|_|_|\\n%14s|___|%6stangoman.io\033[0m\n\"" >> ~/.bashrc \
    && echo "alias ll='ls -alFh'\nalias cc='clear'\nalias xx='exit'\nalias ..='cd ..'" >> ~/.bashrc

WORKDIR /usr/src/app

# install beef
RUN git clone --depth 1 https://github.com/beefproject/beef . \
    && rm -rf .git \
    && rm -f Gemfile.lock \
    && gem install bundler \
    && bundle config set without 'test development' \
    && bundle install

# config default user and password (user: root, passwd: toor)
RUN sed -i -E '/^\s{8}user/ s/:\s*"\w+"/: "root"/' config.yaml \
    && sed -i -E '/^\s{8}passwd/ s/:\s*"\w+"/: "toor"/' config.yaml \
    && sed -i -E '/^\s{8}port/ s/:\s*"[0-9]+"/: "80"/' config.yaml

CMD [ "ruby", "beef", "-x" ]

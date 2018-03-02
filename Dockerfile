FROM ubuntu:xenial
MAINTAINER Bruce Shi <bruceshi@chinarenaissance.com>

USER root

# Setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Update 
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y build-essential git libpq-dev \
  imagemagick ghostscript redis-server postgresql-client yarn nodejs
RUN apt-get install -y sudo
RUN yarn global add phantomjs-prebuilt


#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Setup User
RUN useradd --home /home/worker -M worker -K UID_MIN=10000 -K GID_MIN=10000 -s /bin/bash
RUN mkdir /home/worker
RUN chown worker:worker /home/worker
RUN adduser worker sudo
RUN echo 'worker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER worker

ENV RUBY_VERSION 2.3.1

# Install RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c 'source ~/.rvm/scripts/rvm'

# Install Ruby
RUN /bin/bash -l -c 'rvm requirements'

RUN /bin/bash -l -c 'rvm install $RUBY_VERSION'
RUN /bin/bash -l -c 'rvm use $RUBY_VERSION --default'
RUN /bin/bash -l -c 'rvm rubygems current'

# Install bundler
RUN /bin/bash -l -c 'gem install bundler --no-doc --no-ri'




FROM ruby:2.3
MAINTAINER Bruce Shi <bruceshi@chinarenaissance.com>

ENV LC_ALL C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y build-essential git curl libpq-dev \
  imagemagick ghostscript redis-server postgresql-client yarn nodejs
RUN yarn global add phantomjs-prebuilt

RUN gem install bundler --no-ri --no-rdoc

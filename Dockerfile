FROM ruby:3.0.2

RUN apt-get update -qq && \
    apt-get install -y build-essential

RUN apt-get update \
    && apt-get install -y curl apt-transport-https wget \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn vim

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs \
    && apt-get clean

RUN mkdir /base_app
WORKDIR /base_app

COPY Gemfile /base_app/Gemfile
COPY Gemfile.lock /base_app/Gemfile.lock

ENV BUNDLER_VERSION 2.2.0
RUN gem update --system \
    && gem install bundler -v $BUNDLER_VERSION \
    && bundle install

COPY . /base_app

RUN mkdir -p tmp/sockets
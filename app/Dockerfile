FROM ruby:2.4.2-alpine3.6
RUN apk add --update alpine-sdk
RUN apk add --update postgresql-dev
RUN apk add --update curl-dev
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

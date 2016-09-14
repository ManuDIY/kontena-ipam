FROM alpine:3.4
MAINTAINER Kontena, Inc. <info@kontena.io>

RUN apk update && apk --update add ruby ruby-irb ruby-bigdecimal \
    ruby-io-console ruby-json ca-certificates libssl1.0 openssl libstdc++

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base openssl-dev && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install --without development test && \
    apk del build-dependencies

WORKDIR /app
ADD . /app

CMD ["bundle", "exec", "thin", "-C", "app/config/thin.yml", "start"]
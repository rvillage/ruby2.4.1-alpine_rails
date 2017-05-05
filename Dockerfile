FROM ruby:2.4.1-alpine
LABEL maintainer "rvillage <rvillage@gmail.com>"

ENV LANG ja_JP.UTF-8
ENV ENTRYKIT_VERSION 0.4.0

RUN set -ex \
    && apk --update --upgrade add --no-cache --virtual .build_entrykit \
         openssl \
    && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink \
    \
    && apk del .build_entrykit \
    \
    && apk add --no-cache \
         curl-dev ruby-dev build-base \
         libxml2-dev libxslt-dev tzdata postgresql-dev \
         ruby-json yaml nodejs

WORKDIR /usr/src/app

RUN bundle config build.nokogiri --use-system-libraries

ENTRYPOINT ["prehook", "ruby -v", "--", \
            "prehook", "bundle install -j3 --quiet", "--"]

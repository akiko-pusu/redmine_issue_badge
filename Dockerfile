FROM ruby:2.4.2
LABEL maintainer="AKIKO TAKANO / (Twitter: @akiko_pusu)" \
  description="Image to run Redmine simply with sqlite to try/review plugin."

#
# You can run target version of Redmine.
# If you use this Dockerfile only, try this:
#    $ docker build -t redmine_stable .
#    $ docker run -d -p 3000:3000 redmine_stable
#
# You can change Redmine version with arg
#    $ docker build --rm --build-arg REDMINE_VERSION=master -t redmine_master .
#    $ docker run -d -p 3000:3000 redmine_master
#

### get Redmine source
ARG REDMINE_VERSION="3.4-stable"

### Replace shell with bash so we can source files ###
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && echo "REDMINE_VERSION: ${REDMINE_VERSION}"

### install default sys packeges ###

RUN apt-get update
RUN apt-get install -qq -y \
    git vim            \
    sqlite3

RUN cd /tmp && git clone --depth 1 -b ${REDMINE_VERSION} https://github.com/redmine/redmine redmine
RUN echo "REDMINE_VERSION: ${REDMINE_VERSION}"
WORKDIR /tmp/redmine

RUN echo $'test:\n\
  adapter: sqlite3\n\
  database: /tmp/data/redmine_test.sqlite3\n\
  encoding: utf8mb4\n\
\n\
development:\n\
  adapter: sqlite3\n\
  database: /tmp/data/redmine_development.sqlite3\n\
  encoding: utf8mb4\n'\
>> config/database.yml

RUN gem update bundler
RUN bundle install --without mysql postgresql rmagick test
RUN bundle exec rake db:migrate
RUN bundle exec rake generate_secret_token
CMD bundle exec rails s -p 3000 -b '0.0.0.0'
EXPOSE 3000

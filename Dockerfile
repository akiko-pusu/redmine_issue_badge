FROM ruby:2.4.1
MAINTAINER AKIKO TAKANO / (Twitter: @akiko_pusu)

### get Redmine source
ARG REDMINE_VERSION="3.4-stable"
ARG REDMINE_LANG="en"

### Replace shell with bash so we can source files ###
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

### install default sys packeges ###

RUN apt-get update
RUN apt-get install -qq -y \
    git                    \
    sqlite3

RUN cd /tmp && git clone --depth 1 -b ${REDMINE_VERSION} https://github.com/redmine/redmine redmine
RUN echo "REDMINE_VERSION: ${REDMINE_VERSION}"
WORKDIR /tmp/redmine

RUN echo $'test:\n\
  adapter: sqlite3\n\
  database: redmine_test\n\
  host: 127.0.0.1\n\
  username: root\n\
  password: ""\n\
  encoding: utf8mb4\n\
\n\
development:\n\
  adapter: sqlite3\n\
  database: redmine_development\n\
  host: 127.0.0.1\n\
  username: root\n\
  password: ""\n\
  encoding: utf8mb4\n'\
>> config/database.yml

RUN gem install simplecov simplecov-rcov yard --no-rdoc --no-ri
RUN gem update bundler
ADD . /tmp/redmine/plugins/redmine_issue_badge
RUN bundle install --without mysql postgresql rmagick
RUN bundle exec rake db:migrate
RUN bundle exec rake redmine:plugins:migrate
RUN bundle exec rake generate_secret_token
EXPOSE 3000

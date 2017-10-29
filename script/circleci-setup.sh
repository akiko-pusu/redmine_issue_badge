#!/bin/sh
cd /tmp/
echo ${REDMINE_VERSION}
git clone --depth 1 -b ${REDMINE_VERSION} https://github.com/redmine/redmine redmine

# switch target version of redmine
cd /tmp/redmine
cat << HERE >> config/database.yml
test:
  adapter: mysql2
  database: redmine_test
  host: 127.0.0.1
  username: root
  password: ""
  encoding: utf8mb4
HERE

# move redmine source to wercker source directory
mkdir -p /tmp/redmine/plugins/${CIRCLE_PROJECT_REPONAME}

# Move Gemfile.local to Gemfile only for test
mv ~/repo/Gemfile.local ~/repo/Gemfile

mv ~/repo/* /tmp/redmine/plugins/${CIRCLE_PROJECT_REPONAME}/
mv ~/repo/.* /tmp/redmine/plugins/${CIRCLE_PROJECT_REPONAME}/
mv /tmp/redmine/* ~/repo/
mv /tmp/redmine/.* ~/repo/
ls -la ~/repo/

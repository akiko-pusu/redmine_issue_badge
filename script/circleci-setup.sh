#!/bin/sh
mysql -v
mysql -u root -e "SHOW VARIABLES LIKE 'sql_mode';"
cd /tmp/
hg clone https://bitbucket.org/redmine/redmine-all redmine

# switch target version of redmine
cd /tmp/redmine
hg pull
cat << HERE >> config/database.yml
test:
  adapter: mysql2
  database: redmine_test
  host: 127.0.0.1
  username: root
  password: ""
  encoding: utf8mb4
  sql_mode: false
HERE

# move redmine source to wercker source directory
echo
mkdir -p /tmp/redmine/plugins/${CIRCLE_PROJECT_REPONAME}

# Move Gemfile.local to Gemfile only for test
mv ~/repo/Gemfile.local ~/repo/Gemfile

mv ~/repo/* /tmp/redmine/plugins/${CIRCLE_PROJECT_REPONAME}/
mv ~/repo/.* /tmp/redmine/plugins/${CIRCLE_PROJECT_REPONAME}/
mv /tmp/redmine/* ~/repo/
mv /tmp/redmine/.* ~/repo/
ls -la ~/repo/

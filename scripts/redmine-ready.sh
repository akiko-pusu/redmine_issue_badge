#!/bin/sh
cd ..
rm -fr redmine-*
hg clone --updaterev ${REDMINE_TARGET} https://bitbucket.org/redmine/redmine-all redmine-target
cat << HERE >> redmine-target/config/database.yml
test:
  adapter: sqlite3
  database: db/test.sqlite3
HERE

mkdir -p redmine-target/plugins/${PLUGIN_NAME}
shopt -s dotglob
cp -r source/* redmine-target/plugins/${PLUGIN_NAME}/
cp -r source/.git redmine-target/plugins/${PLUGIN_NAME}/

cd source
ls -a | grep -v -E 'redmine-ready\.sh|wercker\.yml' | xargs rm -rf

shopt -s dotglob
mv ../redmine-target/* ./
gem install simplecov simplecov-rcov yard rspec
gem update bundler




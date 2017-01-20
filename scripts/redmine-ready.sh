#!/bin/sh
cd ..
rm -fr redmine-*
hg clone https://bitbucket.org/redmine/redmine-all redmine-trunk
cat << HERE >> redmine-trunk/config/database.yml
test:
  adapter: sqlite3
  database: db/test.sqlite3
HERE

mkdir -p redmine-trunk/plugins/${PLUGIN_NAME}
shopt -s dotglob
cp -r source/* redmine-trunk/plugins/${PLUGIN_NAME}/
cp -r source/.git redmine-trunk/plugins/${PLUGIN_NAME}/

cd source
ls -a | grep -v -E 'redmine-ready\.sh|wercker\.yml' | xargs rm -rf

shopt -s dotglob
mv ../redmine-trunk/* ./
gem install simplecov simplecov-rcov yard rspec
gem update bundler




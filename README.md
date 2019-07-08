# Redmine Issue Badge Plugin

[![Plugin info at redmine.org](https://img.shields.io/badge/Redmine-plugin-green.svg?)](http://www.redmine.org/plugins/redmine_issue_badge)
[![Circle CI](https://circleci.com/gh/akiko-pusu/redmine_issue_badge/tree/master.svg?style=shield&circle-token=156d098f75b4142fead83e9e4bd5871257acf3be)](https://circleci.com/gh/akiko-pusu/redmine_issue_badge)
[![Sider](https://img.shields.io/badge/Special%20Thanks!-Sider-blue.svg?)](https://sider.review/features)

Plugin to show the number of assigned issues with badge on top menu.

![screen shot](https://raw.githubusercontent.com/wiki/akiko-pusu/redmine_issue_badge/img/screen-in-case-no-assigned-issues.png)

### Plugin installation

1.  Copy the plugin directory into the plugins directory. Please note that
    plugin's folder name should be "redmine_issue_badge". If changed, some
    migration task will be failed.
2.  Do migration task.

    e.g. rake redmine:plugins:migrate RAILS_ENV=production

1.  (Re)Start Redmine.


### Uninstall

Try this:

*   rake redmine:plugins:migrate NAME=redmine_issue_badge VERSION=0
    RAILS_ENV=production


### Required Settings

This feature is activated as one of the user preferences.

1.  Login to your Redmine and go to "/my/account" page.
2.  Enable the option, described as "Show number of assigned issues with
    badge".
3.  After that, if you have assigned and opened issues, the number of issues
    is shown with badge.
4.  Click badge and firt 5 issues are displayed.

That's all.

### Quick try with using Docker

You can try quickly this plugin with Docker environment.
Please try:

```
$ https://github.com/akiko-pusu/redmine_issue_badge
$ docker-compose up -d
```

Please note: Yon don't have to download Redmine's source code, but source code of this plugin is required.

Run **docker-compose up -d** command and soon you can access Redmine running within Docker container.
After stating up container, please login as admin (password: admin) and access **http://localhost:3000/admin/plugins** .
Then, you can configure and activate this plugin.


![docker-compose-sample](https://raw.githubusercontent.com/wiki/akiko-pusu/redmine_issue_badge/img/plugin-with-docker.gif)


## Changelog

### 0.0.7

* Feature #82. Enabled to switch list issue order. (Oldest 5 or Latest 5)
* Merge pull request #92 to support Redmine4.0. (Thanks, kenji21)
* Some code refactoring.

Please note, this version does not spport Redmine4.x completely.
Since Redmine4.x is based on Rails that migration format must be changed.

Maybe new version, 0.1.0, which support Redmine4.x will be released soon.

### 0.0.6

* Bug fix for #49. Badge is not working for user created from LDAP user.
* Feature #52. Display background image when user’s assigned issue is empty.
* PR #48. Add simplified Chinese translation file. Thank you so much, Steven.W!
* Some code refactoring. Thanks to Sider (former SideCI), I am very saved!

### 0.0.5

Please note, this release is required to migrate.

* Feature #43. Add option to polling assigned issues count every 60 seconds. (Prototype)
* Feature #41. Add option to include / exclude option issues assigned to user's group.
* Bug fix for #36. Don’t render html in case current user is required password change just after login. Thanks, @nakat-t.
* Bug fix for #32. Escape subject includes html entities. Thank you so much @pousterlus.
* Change not to use fixtures and to use FactoryGirl for rspec.
* Some code refactoring. Special thanks to Sider, https://sider.review, which is automating code analysis system.

### 0.0.4.1

*   Bug fix for #28. Thank you so much @juxta73.

### 0.0.4

Code refactoring and change settings for CI.
From this version, need Redmine 3.3.1 or higher.

*   Change CI from drone.io to wercker
*   Convert README from rdoc to markdown.
*   Remove selenium-webdriver from plugin's Gemfile. (#24)
*   UserPreference setting is failed in case using Redmine3.3.1 or later. (#23)

### 0.0.3

*   Display badge when responsive mode (#17).
*   Enabled to activate badge for all the user on plugin's configuration
    screen. (#3)
*   Code Refactoring.
*   Add scss file and npm script to compile scss.


### 0.0.2

*   Fix. Redmine not at root (#13).
*   Fix. JS Bug (#5).
*   Fix. Wrong CSS (#4).
*   Merge PR: (#1) / Thank you so much, ykws!
*   Add README_ja, GPL.txt
*   Add rspec somple code for test.


### 0.0.1

*   First release


### Repository

*   https://github.com/akiko-pusu/redmine_issue_badge

### Run spec

Please see .circleci/config.yml for more details.
You can run only for the spec related this plugin via rake task.

```
$ cd REDMINE_ROOT_DIR
$ cp plugins/redmine_issue_badge/Gemfile.local plugins/redmine_issue_badge/Gemfile
$ bundle install --with test
$ export RAILS_ENV=test
$ bundle exec rake redmine_issue_badge:spec
```

Also you can run via rspec command like this:

```
$ bundle exec rspec -I plugins/redmine_issue_badge/spec \
            --format documentation plugins/redmine_issue_badge/spec/
```


### License

This software is licensed under the GNU GPL v2. See COPYRIGHT and COPYING for
details.

### Author

Akiko Takano (Twitter: @akiko_pusu) / GitHub: https://github.com/akiko-pusu/

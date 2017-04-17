# Redmine Issue Badge Plugin

Plugin to show the number of assigned issues with badge on top menu.

Build Status on wercker:

[![wercker status](https://app.wercker.com/status/60fa6d07854d0fa0cd8e961d2d10325d/s/ "wercker status")](https://app.wercker.com/project/byKey/60fa6d07854d0fa0cd8e961d2d10325d)

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

## Changelog

### 0.0.6

* Bug fix for #49. Badge is not working for user created from LDAP user.
* Feature #52. Display background image when user’s assigned issue is empty.
* PR #48. Add simplified Chinese translation file. Thank you so much, Steven.W!
* Some code refactoring. Thanks to SideCI, I am very saved!

### 0.0.5

Please note, this release is required to migrate.

* Feature #43. Add option to polling assigned issues count every 60 seconds. (Prototype)
* Feature #41. Add option to include / exclude option issues assigned to user's group.
* Bug fix for #36. Don’t render html in case current user is required password change just after login. Thanks, @nakat-t.
* Bug fix for #32. Escape subject includes html entities. Thank you so much @pousterlus.
* Change not to use fixtures and to use FactoryGirl for rspec.
* Some code refactoring. Special thanks to SideCI, https://sideci.com, which is automating code analysis system.

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


### License

This software is licensed under the GNU GPL v2. See COPYRIGHT and COPYING for
details.

### Author

Akiko Takano (Twitter: @akiko_pusu)

# Redmine Issue Badge Plugin

このプラグインは、Redmineの上部（ナビゲーションバー)上に、現在の自分の担当チケット数をバッジ表示させるプラグインです。

## インストール方法

(1) プラグインのソースを取得後、redmine/plugins/ ディレクトリ以下に配置して下さい。
   プラグインのディレクトリは、必ず "redmine_issue_badge" として下さい。
   (各プラグインのinit.rbで指定した名前とディレクトリ名が一致しないと起動や動作に影響が出ます）

   例) redmine／plugins／redmine_issue_badge

(2) DBマイグレーションを実行して下さい。

   例） rake redmine:plugins:migrate RAILS_ENV=production

(3) Redmineを再起動して下さい。

## アンインストール方法

以下のコマンドを実行して下さい:

* rake redmine:plugins:migrate NAME=redmine_issue_badge VERSION=0 RAILS_ENV=production

また、実施後に、plugins/redmine_issue_badge を削除して下さい。

## インストール後の設定

このプラグインの利用は、ユーザ単位での設定になります。

1. Redmineにログインし、 "/my/account" ページに移動します。
2. "担当チケット数をバッジ表示する" にチェックを入れます。
3. 設定を適用すると、担当チケットで未完了のものの数がバッジ表示されます。
4. バッジをクリックすると、5件分のチケットのタイトルとリンクが表示されます。

大規模運用になると、プラグインの組み込みで動作が遅くなる可能性があるので、全ユーザに一斉適用はせず、個人単位で有効無効を切り替えるようにしています。
また、Redmine自体がまだSPA的な作りになっていないことと、性能にインパクトを与えないよう、バッジ数のポーリングは行っていません。
（画面遷移が実行された際に、担当チケット数を再取得する仕組みになっています）

### 20170314 Updated: 

プラグインの管理画面から、ポーリングを有効にするオプションを追加しています。
バフォーマンスを考慮してデフォルトではOFF, 有効な場合も間隔は60秒にしています。
また、有効にした場合でセッションがきれたり、ajaxリクエストでエラーが発生した場合はポーリングをストップするようにしています。
こちらの機能については、バグ等のフィードバックをいただければ幸いです。


## リポジトリ

* https://github.com/akiko-pusu/redmine_issue_badge

## テストについて

ただいまテストについて勉強中です...。
このため、学習も兼ねて、rspecでのテストコードを書いています。
（また、機能は少ないですがフロント側での描画、cssの勉強を兼ねたプラグインになっています）
こちらにつきましても、フィードバックいただけると幸いです！

### 実行方法

redmineのインストールディレクトリに移動して、以下を実行します。

- specディレクトリ全てを指定すると、Capybaraでのe2eテストも走ります。
 - spec/features 以下が対象になります。
 - Selenium Webdriver + Chrome または phantomjs が必要になります。
 - Macの場合は、brew install phantomjs でOKです。
- デフォルトでは、redmine/ 以下の coverage/ ディレクトリにカバレッジレポートが生成されます。

```
# issue badgedの稼働には追加のgemは必要ありませんが、テストの場合はcapybaraやfactory_girlを使うので、
# Gemfileを配置します

% cp plugins/redmine_issue_badge/Gemfile.local plugins/redmine_issue_badge/Gemfile

# テスト用のDBの設定を行ってから、migration 実施
% bundle exec rake db:migrate RAILS_ENV=test
% bundle exec rake redmine:plugins:migrate RAILS_ENV=test

# rspecのため、rake redmine:plugins:test では実行されません。
# 直にrspecコマンドを売って下さい。もしくは、rake task を実行してください。
% bundle exec rspec -I plugins/redmine_issue_badge/spec plugins/redmine_issue_badge/spec
% bundle exec rake redmine_issue_badge:spec
```

#### 実行例

- spec/features/以下のe2eテストのみ対象
- phantomjs を利用（ブラウザは起動しません）
- htmlレポートを生成（report/plugin-test.html）カバレッジはデフォルトで coverage/ 以下

```
% bundle exec rspec -Iplugins/redmine_issue_badge/spec -fh -o report/plugin-test.html \
  plugins/redmine_issue_badge/spec/features/badge_spec.rb
```

- spec/features/以下のe2eテストのみ対象
- ドライバはseleiumを指定すると、Chromeが起動してテストを実施
- htmlレポートを生成（report/plugin-test.html）カバレッジはデフォルトで coverage/ 以下

```
% DRIVER=selenium bundle exec rspec -Iplugins/redmine_issue_badge/spec -fh -o report/plugin-test.html \
  plugins/redmine_issue_badge/spec/features/badge_spec.rb
```

#### werckerでのテスト

簡単なテストですが、テストの手順用のスクリプトが参照できます。

- https://app.wercker.com/akiko-pusu/redmine_issue_badge/runs

## License

This software is licensed under the GNU GPL v2. See COPYRIGHT and COPYING for details.

### Author / 作ったひと

Akiko Takano (Twitter: @akiko_pusu)

# frankly-note
frankly-note は Sinatra 製のフランク:)なメモ帳アプリケーションです。

# 始め方
予め PostgreSQL のデフォルトのユーザーで `sinatra_db` というデータベースを作成しておいてください。

PostgreSQL のインストールとデフォルトユーザーでのログイン。

```bash
brew install postgresql
brew services start postgresql
psql postgres
```

`sinatra_db` データベースを作成。

```bash
postgres=# create database sinatra_db;
postgres=# \q
```

任意の適当なディレクトリにこのアプリケーションを `git clone` してダウンロード。

```bash
mkdir my_note
cd my_note
git clone https://github.com/Akkkky/frankly-note.git
```
`frankly-note` ディレクトリに移動して `bundle install` で Gem をインストール。

```bash
cd frankly-note
bundle install
```
`app.rb` を実行。

```bash
ruby app.rb
```

ブラウザで http://localhost:4567/ にアクセス。

<img width="600px;" src="https://user-images.githubusercontent.com/6190966/104794311-1ae34d80-57ea-11eb-99bf-2650432468b4.png" />

イェイ！

# その他
`Ruby 2.7.2` での動作を確認しています。
`.ruby-version` を設置しているため rbenv がインストールされていれば自動でバージョンを 2.7.2 にしてくれます。

```bash
brew install rbenv
```

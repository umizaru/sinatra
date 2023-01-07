# 概要
シンプルなメモアプリです。</br>
メモの作成や削除、修正などを行うことができます。
# 手順
あなたのローカル環境で動作させるには以下の手順を実行してください。

## リポジトリのクローン、Gemのインストール
1. このリポジトリをクローンします。
2. ```sinatra```のフォルダに移動します。
3. ```bundle install```で必要なGemをインストールします。

## データ保存用のデータベースを作成
※データベースはPostgresSQLを使ってください。
1. PostgresSQLのユーザを作成する
```
CREATE USER username;
```

2. PostgresSQLにログインする
```
$ psql -U ユーザ名
```

3. データベースを作成する
```
$ ユーザ名=# CREATE DATABASE memoapp;
```

4. データベースに切り替える
```
$ ユーザ名=# \c memoapp;
```

5. テーブルを作成する
```
CREATE TABLE memos
(id integer NOT NULL,
title text NOT NULL,
message text NOT NULL,
PRIMARY KEY (id));
```
## アプリケーションに接続する
1. ```bundle exec ruby app.rb```でアプリケーションを実行します。
2. ブラウザで```http://localhost:4567```にアクセスします。

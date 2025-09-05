# MemoApp
## 概要
シンプルなWebフレームワークSinatraでWeb開発の基礎を学ぶために作成したメモアプリです

## 前提条件
この開発環境を構築するには、以下のツールがインストールされている必要があります
- Git（動作確認環境：version 2.47.1）
- Ruby（動作確認環境：version 3.4.5）
- Docker Desktop（動作確認環境：version 4.39.0）

## 環境構築
1. リポジトリをクローンします
```bash
git clone --branch feature/use-postgre_sql https://github.com/gon0821/Sinatra-practice.git
```

2. ディレクトリ移動します
```bash
cd Sinatra-practice
```

3. 必要なGemをインストールします
```bash
bundle install
```

4. PostgreSQLコンテナをバックグラウンドで起動し、データベースを起動させます
```bash
docker compose up -d
```

5. PostgreSQLコンテナにターミナルでログインします
```bash
docker compose exec db bash
```

6. PostgreSQLに接続し、`memos`テーブルが存在することを確認します
```bash
psql -U test_user -d memo_app -c '\dt;'

# 確認できたらコンテナから抜ける
exit
```

7. プログラムを実行し、サーバーを起動します
```bash
ruby myapp.rb
```

8. ブラウザで`localhost:4567`にアクセスします

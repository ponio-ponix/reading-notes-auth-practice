# reading-notes-auth-practice

`reading-notes-auth-practice` は、Rails で認証まわりの実装を切り出して練習するための個人用サンドボックスです。

本番のポートフォリオ本体にいきなり認証実装を入れる前に、以下を小さく分けて検証することを目的にしています。

- `SessionsController#create` の流れ
- `has_secure_password` を使った認証
- token 発行
- token digest の保存
- `AccessToken` モデル設計
- `expires_at` / `revoked_at` の扱い
- Rails の request / response / render の理解
- API としてのレスポンス設計

## このリポジトリの位置づけ

これは**本番ポートフォリオではありません**。  
認証実装を理解するための**練習用リポジトリ**です。

そのため、このリポジトリでは以下を優先します。

- 実装を小さく分けて試す
- 失敗や試行錯誤も残す
- エラーを踏みながら Rails / HTTP / 認証の理解を深める
- 本番に入れる前に認証処理の責務を整理する

## 現在の練習テーマ

現在は主に `Api::Auth::SessionsController#create` を対象に、以下を練習しています。

1. `email` / `password` の受け取り
2. 入力不正時のレスポンス
3. `User` の検索
4. password 照合
5. raw token の生成
6. token digest の生成
7. `AccessToken` への保存
8. クライアントへの token 返却

## 学習上の主な論点

このリポジトリでは、特に以下の論点を重点的に確認しています。

- `render` と `return` の違い
- 1 action 内でのレスポンス制御
- `204 / 200 / 422 / 500` の意味
- `has_secure_password` と `bcrypt`
- `password_digest` と `token_digest` の役割の違い
- `Digest::SHA256.digest` と `hexdigest` の違い
- `User` と `AccessToken` の責務分離
- `expires_at` と `revoked_at` の意味

## 使用技術

- Ruby
- Rails
- ActiveRecord
- SQLite / PostgreSQL（必要に応じて切り替え）
- bcrypt
- Digest
- curl（動作確認用）

## セットアップ

```bash
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

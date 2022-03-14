# 起動方法

## Google OAuth2のセットアップ
Google Developer ConsoleでOAuth2を設定、アプリ登録を実施しする。

## configファイル作成
Google Developer Consoleの認証情報からJSONファイルとしてダウンロードし
config.jsonにリネームして保存する。
```json
{
    "web": {
        "client_id": "クライアントID",
        "project_id": "プロジェクトID",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_secret": "クライアントシークレット",
        "redirect_uris": [
            "リダイレクト先URL"
        ],
        "javascript_origins": [
            "Javascript発行先"
        ]
    }
}
```

## 必要なモジュールのインストール
```bash
$ gem install webrick
$ gem install sinatra
$ gem install sinatra-contrib
```

## テストWEBアプリ起動
```bash
$ ruby google_oauth2_sample.rb
```

## WEBアプリアクセス
```
http://localhost:4567/
```

# Kintone

クラウド型データベースサービスKintone(https://kintone.cybozu.com/)のREST APIを使用するためのgemです。

## Installation

    gem install kintone

又は、Gemfileに

    gem 'kintone'

と書いて、`bundle install` コマンドを実行してください。

## Usage

    require 'kintone'

### レコード1件の取得/登録/更新

	api = Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu")
	# レコード取得
	api.record.get(8, 100) # get(アプリID, レコード番号)
	# レコード登録
	api.record.create(7, {"number" => {"value" => "123456"}}) # create(アプリID, レコードデータ)
	# レコード更新
	api.record.update(4, 1, {"string_multi" => {"value" => "changed!"}}) # update(アプリID, レコード番号, レコードデータ)

### 他APIへのリクエスト

	# フォーム設計情報取得
	api.get("form.json", {"app" => 4}) # => {"properties" => [{...}, ...]}
	# 複数レコード登録
	body = {"app" => 7, "records" => [{...}, ...]}
	api.post("records.json", body) # => {"ids" => ["100","101"]}

### ゲストスペースへのAPIリクエスト

	api = Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu")
	api.guest(1).record.get(8, 100)

APIの仕様等については、cybozu.com developers(https://developers.cybozu.com/)を見てください。

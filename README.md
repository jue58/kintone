# kintone

クラウド型データベースサービス[kintone](https://kintone.cybozu.com/)のREST APIを使用するためのgemです。

## Installation

    gem install kintone

又は、Gemfileに

    gem 'kintone'

と書いて、`bundle install` コマンドを実行してください。

## Usage

```ruby
require 'kintone'
api = Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu")
```

### 対応API
- レコード取得
- レコード登録
- レコード更新
- レコード削除
- フォーム設計情報取得

### レコード取得

```ruby
# レコード取得(レコード番号指定)
app = 8; id = 100
api.record.get(app, id) # => {"record" => {"record_id" => {"type" => "RECORD_NUMBER", "value" => "1"}}}

# レコード取得(クエリで取得)
app = 8; fields = ["record_id", "created_time", "dropdown"]
query = "updated_time > \"2012-02-03T09:00:00+0900\" and updated_time < \"2012-02-03T10:00:00+0900\" order by record_id asc limit 10 offset 20"
api.records.get(app, query, fields) # => {"records" => [{...}, ...]}
```

### レコード登録

```ruby
# レコード登録(1件)
app = 7
record = {"number" => {"value" => "123456"}}
api.record.create(app, record) # => {"id" => "100"}

# レコード登録(複数件)
app = 7
records = [{"number" => {"value" => "123456"}}, {"number" => {"value" => "7890"}}]
api.records.create(app, records) # => {"ids" => ["100", "101"]}
```

### レコード更新

```ruby
# レコード更新(1件)
app = 4; id = 1
record = {"string_multi" => {"value" => "changed!"}}
api.record.update(app, id, record) # => {}

# レコード更新(複数件)
app = 4
records = [{"id" => 1, "string_multi" => {"value" => "abcdef"}}, {"id" => 2, "string_multi" => {"value" => "opqrstu"}}]
api.records.update(app, records) # => {}
```

### レコード削除

```ruby
app = 8; ids = [100, 80]
api.records.delete(app, ids) # => {}
```

### フォーム設計情報取得

```ruby
app = 4
api.form.get(app) # => {"properties" => [{...}, ...]}
```

### 他APIへのリクエスト

```ruby
# フォーム設計情報取得
url = api.get_url("form")
api.get(url, {"app" => 4}) # => {"properties" => [{...}, ...]}

# 複数レコード登録
url = api.get_url("records")
body = {"app" => 7, "records" => [{...}, ...]}
api.post(url, body) # => {"ids" => ["100","101"]}
```

### ゲストスペースへのAPIリクエスト

```ruby
api.guest(1).record.get(8, 100)
```

APIの仕様等については、[cybozu.com developers](https://developers.cybozu.com/)を見てください。

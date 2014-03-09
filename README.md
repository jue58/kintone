# kintone

A Ruby gem for communicating with the [kintone](https://kintone.cybozu.com/us/) REST API

## Installation

    gem install kintone

or execute `bundle install` command after you insert the following into Gemfile

    gem 'kintone'

## Usage

```ruby
require 'kintone'
api = Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu")
```

### Suppored API
- Record retrieval
- Record register
- Record update
- Record delete
- Format retrieval

### Record retrieval

```ruby
# Record retrieval(Assign by Record Number)
app = 8; id = 100
api.record.get(app, id) # => {"record" => {"record_id" => {"type" => "RECORD_NUMBER", "value" => "1"}}}

# Records retrieval(Assign by Conditions by Query Strings)
app = 8; fields = ["record_id", "created_time", "dropdown"]
query = "updated_time > \"2012-02-03T09:00:00+0900\" and updated_time < \"2012-02-03T10:00:00+0900\" order by record_id asc limit 10 offset 20"
api.records.get(app, query, fields) # => {"records" => [{...}, ...]}
```

### Record register

```ruby
# Record register(single record)
app = 7
record = {"number" => {"value" => "123456"}}
api.record.create(app, record) # => {"id" => "100"}

# Records register(batch)
app = 7
records = [{"number" => {"value" => "123456"}}, {"number" => {"value" => "7890"}}]
api.records.create(app, records) # => {"ids" => ["100", "101"]}
```

### Record update

```ruby
# Record update(single record)
app = 4; id = 1
record = {"string_multi" => {"value" => "changed!"}}
api.record.update(app, id, record) # => {}

# Records update(batch)
app = 4
records = [{"id" => 1, "string_multi" => {"value" => "abcdef"}}, {"id" => 2, "string_multi" => {"value" => "opqrstu"}}]
api.records.update(app, records) # => {}
```

### Record delete

```ruby
app = 8; ids = [100, 80]
api.records.delete(app, ids) # => {}
```

### Format retrieval

```ruby
app = 4
api.form.get(app) # => {"properties" => [{...}, ...]}
```

### Other examples

```ruby
# Format retrieval
url = api.get_url("form")
api.get(url, {"app" => 4}) # => {"properties" => [{...}, ...]}

# Batch record register
url = api.get_url("records")
body = {"app" => 7, "records" => [{...}, ...]}
api.post(url, body) # => {"ids" => ["100","101"]}
```

### Access to guest spaces

```ruby
api.guest(1).record.get(8, 100)
```

see also [kintone developers](https://developers.kintone.com/)

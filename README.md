# kintone

A Ruby gem for communicating with the [kintone](https://kintone.cybozu.com/us/) REST API

## Requirements

- 2.1.0 or later

## Installation

    gem install kintone

or execute `bundle install` command after you insert the following into Gemfile

    gem 'kintone'

## Usage

```ruby
require 'kintone'
api = Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu")
```

### Supported API
- [Record retrieval](#record_retrieval)
- [Record register](#record_register)
- [Record update](#record_update)
- [Record delete](#record_delete)
- [Format retrieval](#format_retrieval)
- [Permissions](#permissions)
- [Space management]("space_management")

### <a name="record_retrieval"> Record retrieval

```ruby
# Record retrieval(Assign by Record Number)
app = 8; id = 100
api.record.get(app, id) # => {"record" => {"record_id" => {"type" => "RECORD_NUMBER", "value" => "1"}}}

# Records retrieval(Assign by Conditions by Query Strings)
app = 8; fields = ["record_id", "created_time", "dropdown"]
query = "updated_time > \"2012-02-03T09:00:00+0900\" and updated_time < \"2012-02-03T10:00:00+0900\" order by record_id asc limit 10 offset 20"
api.records.get(app, query, fields) # => {"records" => [{...}, ...]}
```

### <a name="record_register"> Record register

```ruby
# Record register(single record)
# Use Hash
app = 7
record = {"number" => {"value" => "123456"}}
api.record.register(app, record) # => {"id" => "100"}

# Use Kintone::Type::Record
app = 7
record = Kintone::Type::Record.new({number: "123456"})
api.record.register(app, record) # => {"id" => "100"}

# Records register(batch)
app = 7
records = [{"number" => {"value" => "123456"}}, {"number" => {"value" => "7890"}}]
api.records.register(app, records) # => {"ids" => ["100", "101"]}

# Deprecated
api.record.create(app, record)
api.records.create(app, records)
```

### <a name="record_update"> Record update

```ruby
# Record update(single record)
# Use Hash
app = 4; id = 1
record = {"string_multi" => {"value" => "changed!"}}
api.record.update(app, id, record) # => {}

# Use Kintone::Type::Record
app = 4; id = 1
record = Kintone::Type::Record.new({string_multi: "changed!"})
api.record.update(app, id, record) # => {}

# Records update(batch)
app = 4
records = [{"id" => 1, "string_multi" => {"value" => "abcdef"}}, {"id" => 2, "string_multi" => {"value" => "opqrstu"}}]
api.records.update(app, records) # => {}
```

### <a name="record_delete"> Record delete

```ruby
app = 8; ids = [100, 80]
api.records.delete(app, ids) # => {}
```

### <a name="format_retrieval"> Format retrieval

```ruby
app = 4
api.form.get(app) # => {"properties" => [{...}, ...]}
```

### <a name="permissions"> Permissions

```ruby
# App
app = 1
rights = [{"entity" => {"type" => "USER", "code" => "user1"}, "appEditable" => true, ...}, ...]
api.app_acl.update(app, rights) # => {}

# Records
id = 1
rights = [{"filterCond" => "...", "entities" => [{"entity" => {...}, "viewable" => false, ...}, ...]}, ...]
api.record_acl.update(id, rights) # => {}

#Fields
id = 1
rights = [{"code" => "Single_line_text_0", "entities" => [{"entity" => {...}, "accesibility" => "WRITE"}, ...]}, ...]
api.field_acl.update(id, rights) # => {}
```

### <a name="space_management"> Space management

```ruby
# Space information reference
id = 1
api.space.get(id) # => { "id" => "1", "name" => "space", "defaultThread" => "3", "isPrivate" => true, ...}

# Create space
id = 1; name = "sample space"
members = [{"entity" => {"type" => "USER", "code" => "user1"}, "isAdmin": true}, ...]
api.template_space.create(id, name, members, is_guest: true, fixed_member: false) # => {"id" => "1"}

# Space body update
id = 1; body = "<b>awesome space!</b>"
api.space_body.update(id, body) # => {}

# Space delete
id = 1
api.space.delete(id) # => {}
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

see also [kintone developers](http://developers.kintone.com/)

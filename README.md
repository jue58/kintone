# kintone

[![Build Status](https://travis-ci.org/jue58/kintone.svg?branch=master)](https://travis-ci.org/jue58/kintone)
[![codebeat badge](https://codebeat.co/badges/7f66de05-57a4-4712-9706-0f33169f530b)](https://codebeat.co/projects/github-com-jue58-kintone)
[![Coverage Status](https://coveralls.io/repos/github/jue58/kintone/badge.svg?branch=add-coveralls-settings)](https://coveralls.io/github/jue58/kintone?branch=add-coveralls-settings)
[![Inline docs](http://inch-ci.org/github/jue58/kintone.svg?branch=master&style=shields)](http://inch-ci.org/github/jue58/kintone)
[![Gem Version](https://badge.fury.io/rb/kintone.svg)](https://badge.fury.io/rb/kintone)

A Ruby gem for communicating with the [kintone](https://kintone.cybozu.com/us/) REST API

## Requirements

- ruby 2.1.0 or later

## Installation

    gem install kintone

or execute `bundle install` command after you insert the following into Gemfile

    gem 'kintone'

## Usage

```ruby
require 'kintone'

# Use password authentication
api = Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu")

# Use token authentication
api = Kintone::Api.new("example.cybozu.com", "authtoken")
```

### Supported API
- [Record retrieval](#record_retrieval)
- [Record register](#record_register)
- [Record update](#record_update)
- [Record delete](#record_delete)
- [Bulk request](#bulk_request)
- [File](#file)
- [Format retrieval](#format_retrieval)
- [Permissions](#permissions)
- [Space management](#space_management)
- [Guests](#guests)
- [Application information](#application_information)
- [API information](#api_information)

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

Query helper

```ruby
query =
  Kintone::Query.new do
    field(:updated_time) > "2012-02-03T09:00:00+0900"
    and!
    field(:updated_time) < "2012-02-03T10:00:00+0900"
    order_by(:record_id)
    limit(10)
    offset(20)
  end
# or
query =
  Kintone::Query.new do
    f(:updated_time) > "2012-02-03T09:00:00+0900"
    and!
    f(:updated_time) < "2012-02-03T10:00:00+0900"
    order_by(:record_id)
    limit(10)
    offset(20)
  end
query.to_s # => "updated_time > \"2012-02-03T09:00:00+0900\" and updated_time < \"2012-02-03T10:00:00+0900\" order by record_id asc limit 10 offset 20"
api.records.get(app, query, fields)

# Example
Kintone::Query.new do
  field(:Created_datetime) >= last_month
  and!
  precede do
    field(:text).like("Hello")
    and!
    field(:number) == 200
  end
  or!
  precede do
    field(:number) > 100
    and!
    field(:Created_by).in([login_user])
  end
  order_by(:record_id, :desc)
  limit(10)
  offset(20)
end
# => "Created_datetime >= LAST_MONTH() and (text like \"Hello\" and number = 200) or (number > 100 and Created_by in (LOGINUSER())) order by record_id desc limit 10 offset 20"
```

operator symbol | query helper
--- | ---
= | field(:code) == other
!= | field(:code) != other
> | field(:code) > other
< | field(:code) < other
>= | field(:code) >= other
<= | field(:code) <= other
in | field(:code).in(["A", "B"])
not in | field(:code).not_in(["A", "B"])
like | field(:code).like("Hello")
not like | field(:code).not_like("Hello")
and | and!
or | or!
() | precede do; end

function | query helper
--- | ---
LOGINUSER() | login_user
NOW() | now
TODAY() | today
THIS_MONTH() | this_month
LAST_MONTH() | last_month
THIS_YEAR() | this_year

option | query helper
--- | ---
order by | order_by(:code, :asc or :desc)
limit | limit(20)
offset | offset(30)

### <a name="record_register"> Record register

```ruby
# Record register(single record)
# Use Hash
app = 7
record = {"number" => {"value" => "123456"}}
api.record.register(app, record) # => {"id" => "100", "revision" => "1"}

# Use Kintone::Type::Record
app = 7
record = Kintone::Type::Record.new(number: "123456")
api.record.register(app, record) # => {"id" => "100", "revision" => "1"}

# Records register(batch)
# Use Hash
app = 7
records = [
  {"number" => {"value" => "123456"}},
  {"number" => {"value" => "7890"}}
]
api.records.register(app, records) # => {"ids" => ["100", "101"], "revisions" => ["1", "1"]}

# Use Kintone::Type::Record
app = 7
records = [
  Kintone::Type::Record.new(number: "123456"),
  Kintone::Type::Record.new(number: "7890")
]
api.records.register(app, records) # => {"ids" => ["100", "101"], "revisions" => ["1", "1"]}
```

### <a name="record_update"> Record update

```ruby
# Record update(single record)
# Use Hash
app = 4; id = 1
record = {"string_multi" => {"value" => "changed!"}}
api.record.update(app, id, record) # => {"revision" => "2"}

# Use Kintone::Type::Record
app = 4; id = 1
record = Kintone::Type::Record.new({string_multi: "changed!"})
api.record.update(app, id, record) # => {"revision" => "2"}

# With revision
api.record.update(app, id, record, revision: 1)

# Records update(batch)
# Use Hash
app = 4
records = [
  {"id" => 1, "record" => {"string_multi" => {"value" => "abcdef"}}},
  {"id" => 2, "record" => {"string_multi" => {"value" => "opqrstu"}}}
]
api.records.update(app, records) # => {"records" => [{"id" => "1", "revision" => "2"}, {"id" => "2", "revision" => "2"}]}

# Use Kintone::Type::Record
app = 4
records = [
  {id: 1, record: Kintone::Type::Record.new(string_multi: "abcdef")},
  {id: 2, record: Kintone::Type::Record.new(string_multi: "opqrstu")}
]
api.records.update(app, records) # => {"records" => [{"id" => "1", "revision" => "2"}, {"id" => "2", "revision" => "2"}]}

# with revision
records = [
  {id: 1, revision: 1, record: Kintone::Type::Record.new(string_multi: "abcdef")},
  {id: 2, revision: 1, record: Kintone::Type::Record.new(string_multi: "opqrstu")}
]
api.records.update(app, records)
```

### <a name="record_delete"> Record delete

```ruby
app = 8; ids = [100, 80]
api.records.delete(app, ids) # => {}

# With revision
revisions = [1, 1]
api.records.delete(app, ids, revisions: revisions)
```

### <a name="bulk_request"> Bulk request

```ruby
requests = {"requests" => [{"method" => "POST", ...}, {"method" => "PUT", ...}]}
api.bulk.request(requests) # => {"results" => [...]}
```

### <a name="file"> File

```ruby
# File upload
file_key = api.file.register("/path/to/file", "text/plain", "file.txt")

# File download
file = api.file.get(file_key)
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
# Space information
id = 1
api.space.get(id) # => { "id" => "1", "name" => "space", "defaultThread" => "3", "isPrivate" => true, ...}

# Create space
id = 1; name = "sample space"
members = [{"entity" => {"type" => "USER", "code" => "user1"}, "isAdmin": true}, ...]
api.template_space.create(id, name, members, is_guest: true, fixed_member: false) # => {"id" => "1"}

# Space body update
id = 1; body = "<b>awesome space!</b>"
api.space_body.update(id, body) # => {}

# Space members
id = 1
members = api.space_members.get(id) # => {"members"=>[{"entity"=>{"type"=>"USER", "code"=> "user1"}, ...}, ...]}
members << {"entity" => {"type" => "GROUP", "code" => "group1"}}
members = api.space_members.update(id, members) # => {}

# Space thread update
id = 1; name = "thread name"
body = "<b>awesome thread!</b>"
api.space_thread.update(id, name: name, body: body) # => {}

# Space guests
id = 1
guests = ["hoge@example.com"]
api.guest(1).space_guests.update(id, guests) # => {}

# Space delete
id = 1
api.space.delete(id) # => {}
```

### <a name="guests"> Guests

```ruby
# Add guest
guests = [{code: "hoge@example.com", password: "p@ssword", timezone: "Asia/Tokyo", name: "Tokyo, Saburo", ...}, ...]
api.guests.register(guests) # => {}

# delete guest
guests = ["hoge@example.com", "fuga@example.com"]
api.guests.delete(guests) # => {}
```

### <a name="application_information"> Application information

```ruby
id = 4
api.app.get(id) # => {"appId" => "4", "code" => "", ...}

name = "test"; codes = ["FOO", "BAR"]
api.apps.get({ name: name, codes: codes }) # => { "apps" => [{...}, ...] }
```

### <a name="api_information"> API information

```ruby
api.apis.get # => {"baseUrl" => "https://example.cybozu.com/k/v1/", "apis" => {"records/get" => {"link" => "apis/records/get.json"}}}

api.apis.get_details_of("apis/records/get.json") # => {"id" => "GetRecords", "baseUrl" => "https://example.cybozu.com/k/v1/", ...}

api.apis.get_details_of_key("records/get") # => {"id" => "GetRecords", "baseUrl" => "https://example.cybozu.com/k/v1/", ...}
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

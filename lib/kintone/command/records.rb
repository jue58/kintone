require 'kintone/command'

class Kintone::Command::Records < Kintone::Command
  def self.path
    'records'
  end

  def get(app, query, fields)
    params = { app: app, query: query }
    fields.each_with_index { |v, i| params["fields[#{i}]"] = v }
    @api.get(@url, params)
  end

  def create(app, records)
    @api.post(@url, app: app, records: records)
  end

  def update(app, records)
    @api.put(@url, app: app, records: records)
  end

  def delete(app, ids)
    params = { app: app }
    ids.each_with_index { |v, i| params["ids[#{i}]"] = v }
    @api.delete(@url, params)
  end
end

require 'kintone/command'
require 'kintone/api'

class Kintone::Command::Records
  PATH = "records.json"

  def initialize(api)
    @api = api
  end

  def get(app, query, fields)
    params = {:app => app, :query => query}
    fields.each_with_index {|v, i| params["fields[#{i}]"] = v}
    return @api.get(PATH, params)
  end

  def create(app, records)
    return @api.post(PATH, {:app => app, :records => records})
  end

  def update(app, records)
    return @api.put(PATH, {:app => app, :records => records})
  end

  def delete(app, ids)
    params = {:app => app}
    ids.each_with_index {|v, i| params["ids[#{i}]"] = v}
    return @api.delete(PATH, params)
  end
end

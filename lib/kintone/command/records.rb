require 'kintone/command'

class Kintone::Command::Records < Kintone::Command
  def self.path
    'records'
  end

  def get(app, query, fields)
    params = { app: app, query: query.to_s }
    fields.each_with_index { |v, i| params["fields[#{i}]"] = v }
    @api.get(@url, params)
  end

  def register(app, records)
    @api.post(@url, app: app, records: records.to_kintone)
  end

  def update(app, records)
    @api.put(@url, app: app, records: records.to_kintone)
  end

  def delete(app, ids, revisions: nil)
    params = { app: app, ids: ids }
    params[:revisions] = revisions if revisions
    @api.delete(@url, params)
  end

  alias_method :create, :register
end

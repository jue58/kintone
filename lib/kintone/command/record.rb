require 'kintone/command'

class Kintone::Command::Record < Kintone::Command
  def self.path
    'record'
  end

  def get(app, id)
    @api.get(@url, app: app, id: id)
  end

  def register(app, record)
    @api.post(@url, app: app, record: record.to_kintone)
  end

  def update(app, id, record, revision: nil)
    body = { app: app, id: id, record: record.to_kintone }
    body[:revision] = revision if revision
    @api.put(@url, body)
  end

  alias create register
end

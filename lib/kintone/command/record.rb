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

  def create(app, record)
    register(app, record)
  end

  def update(app, id, record)
    @api.put(@url, app: app, id: id, record: record.to_kintone)
  end
end

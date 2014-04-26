require 'kintone/command'

class Kintone::Command::Record < Kintone::Command
  def self.path
    return "record"
  end

  def get(app, id)
    @api.get(@url, {:app => app, :id => id})
  end

  def create(app, record)
    @api.post(@url, {:app => app, :record => record})
  end

  def update(app, id, record)
    @api.put(@url, {:app => app, :id => id, :record => record})
  end
end

require 'kintone/command'
require 'kintone/api'

class Kintone::Command::Record
  PATH = "record"

  def initialize(api)
    @api = api
    @url = @api.get_url(PATH)
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

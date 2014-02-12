require 'kintone/command'
require 'kintone/api'

class Kintone::Command::Form
  PATH = "form"

  def initialize(api)
    @api = api
    @url = @api.get_url(PATH)
  end

  def get(app)
    @api.get(@url, {:app => app})
  end
end

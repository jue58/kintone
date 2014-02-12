require 'kintone/command'
require 'kintone/api'

class Kintone::Command::Form
  PATH = "form.json"

  def initialize(api)
    @api = api
  end

  def get(app)
    @api.get(PATH, {:app => app})
  end
end

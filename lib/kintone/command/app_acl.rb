require 'kintone/command'
require 'kintone/api'

class Kintone::Command::AppAcl
  PATH = "app/acl"

  def initialize(api)
    @api = api
    @url = @api.get_url(PATH)
  end

  def update(app, rights)
    @api.put(@url, {:app => app, :rights => rights})
  end
end

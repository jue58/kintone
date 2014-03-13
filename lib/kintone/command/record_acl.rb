require 'kintone/command'
require 'kintone/api'

class Kintone::Command::RecordAcl
  PATH = "record/acl"

  def initialize(api)
    @api = api
    @url = @api.get_url(PATH)
  end

  def update(id, rights)
    @api.put(@url, {:id => id, :rights => rights})
  end
end

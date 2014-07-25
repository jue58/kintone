require 'kintone/api'

class Kintone::Command
  def self.path
    '/'
  end

  def initialize(api)
    @api = api
    @url = @api.get_url(self.class.path)
  end
end

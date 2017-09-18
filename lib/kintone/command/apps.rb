require 'kintone/command'

class Kintone::Command::Apps < Kintone::Command
  def self.path
    'apps'
  end

  def get(params = {})
    response = @api.get(@url, params)
    response['apps']
  end
end

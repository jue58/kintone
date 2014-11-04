require 'kintone/command'

class Kintone::Command::App < Kintone::Command
  def self.path
    'app'
  end

  def get(id)
    @api.get(@url, id: id)
  end
end

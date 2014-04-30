require 'kintone/command'

class Kintone::Command::Space < Kintone::Command
  def self.path
    return "space"
  end

  def get(id)
    return @api.get(@url, {id: id})
  end
end

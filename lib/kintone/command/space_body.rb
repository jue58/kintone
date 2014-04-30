require 'kintone/command'

class Kintone::Command::SpaceBody < Kintone::Command
  def self.path
    return "space/body"
  end

  def update(id, body)
    return @api.put(@url, {id: id, body: body})
  end
end

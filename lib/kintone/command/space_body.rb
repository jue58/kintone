require 'kintone/command'

class Kintone::Command::SpaceBody < Kintone::Command
  def self.path
    'space/body'
  end

  def update(id, body)
    @api.put(@url, id: id, body: body)
  end
end

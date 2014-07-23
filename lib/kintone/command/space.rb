require 'kintone/command'

class Kintone::Command::Space < Kintone::Command
  def self.path
    "space"
  end

  def get(id)
    @api.get(@url, { id: id })
  end

  def delete(id)
    @api.delete(@url, { id: id })
  end
end

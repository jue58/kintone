require 'kintone/command'

class Kintone::Command::FieldAcl < Kintone::Command
  def self.path
    return "field/acl"
  end

  def update(id, rights)
    @api.put(@url, {:id => id, :rights => rights})
  end
end

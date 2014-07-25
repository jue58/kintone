require 'kintone/command'

class Kintone::Command::RecordAcl < Kintone::Command
  def self.path
    'record/acl'
  end

  def update(id, rights)
    @api.put(@url, id: id, rights: rights)
  end
end

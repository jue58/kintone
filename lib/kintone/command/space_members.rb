require 'kintone/command'

class Kintone::Command::SpaceMembers < Kintone::Command
  def self.path
    'space/members'
  end

  def get(id)
    response = @api.get(@url, id: id)
    response['members']
  end

  def update(id, members)
    @api.put(@url, id: id, members: members)
  end
end

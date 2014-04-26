require 'kintone/command'

class Kintone::Command::TemplateSpace < Kintone::Command
  def self.path
    return "template/space"
  end

  def create(id, name, members, is_guest: false, fixed_member: false)
    return @api.post(@url, {id: id, name: name, members: members, isGuest: is_guest, fixedMember: fixed_member})
  end
end

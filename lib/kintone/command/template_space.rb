require 'kintone/command'

class Kintone::Command::TemplateSpace < Kintone::Command
  def self.path
    'template/space'
  end

  def create(id, name, members, is_guest: false, fixed_member: false)
    body = { id: id, name: name, members: members, isGuest: is_guest, fixedMember: fixed_member }
    @api.post(@url, body)
  end
end

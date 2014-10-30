require 'kintone/command'

class Kintone::Command::SpaceGuests < Kintone::Command
  def self.path
    'space/guests'
  end

  def update(id, guests)
    @api.put(@url, id: id, guests: guests)
  end
end

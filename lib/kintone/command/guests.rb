require 'kintone/command'

class Kintone::Command::Guests < Kintone::Command
  def self.path
    'guests'
  end

  def create(guests)
    @api.post(@url, guests: guests)
  end
end

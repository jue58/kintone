require 'kintone/command'

class Kintone::Command::Apis < Kintone::Command
  def self.path
    'apis'
  end

  def get
    @api.get(@url)
  end
end

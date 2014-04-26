require 'kintone/command'

class Kintone::Command::Form < Kintone::Command
  def self.path
    return "form"
  end

  def get(app)
    @api.get(@url, {:app => app})
  end
end

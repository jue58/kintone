require 'kintone/command'

class Kintone::Command::File < Kintone::Command
  def self.path
    'file'
  end

  def register(app, file)
    @api.file_post(@url, file)
  end
end

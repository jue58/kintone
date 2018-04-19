require 'kintone/command'

class Kintone::Command::PreviewForm < Kintone::Command
  def self.path
    'preview/form'
  end

  def get(app)
    @api.get(@url, app: app)
  end
end

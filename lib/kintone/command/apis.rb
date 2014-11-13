require 'kintone/command'

class Kintone::Command::Apis < Kintone::Command
  def self.path
    'apis'
  end

  def get
    @api.get(@url)
  end

  def get_details_of(link)
    url = Kintone::Api::BASE_PATH + link
    @api.get(url)
  end
end

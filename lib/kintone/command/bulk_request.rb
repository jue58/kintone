require 'kintone/command'

class Kintone::Command::BulkRequest < Kintone::Command
  def self.path
    'bulkRequest'
  end

  def request(requests)
    response = @api.post(@url, requests: requests)
    response['results']
  end
end

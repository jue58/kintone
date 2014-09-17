require 'kintone/command'

class Kintone::Command::SpaceThread < Kintone::Command
  def self.path
    'space/thread'
  end

  def update(id, name: nil, body: nil)
    request_body = { id: id }
    request_body[:name] = name if name
    request_body[:body] = body if body
    @api.put(@url, request_body)
  end
end

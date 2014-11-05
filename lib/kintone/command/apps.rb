require 'kintone/command'

class Kintone::Command::Apps < Kintone::Command
  def self.path
    'apps'
  end

  def get(params = {})
    query = {}
    params.keys.each do |key|
      if params[key].is_a?(Array)
        params[key].each_with_index { |v, i| query["#{key}[#{i}]"] = v }
      else
        query[key] = params[key]
      end
    end
    response = @api.get(@url, query)
    response['apps']
  end
end

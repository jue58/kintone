require 'kintone/api'

module Kintone::Uri
  class Record
    PATH = "/k/v1/record.json"
  
    def initialize(api)
      @api = api
    end

    def get(app, id)
      @api.get(PATH, {:app => app, :id => id})
    end
  end
end

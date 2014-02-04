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

    def create(app, record)
      @api.post(PATH, {:app => app, :record => record})
    end

    def update(app, id, record)
      @api.put(PATH, {:app => app, :id => id, :record => record})
    end
  end
end

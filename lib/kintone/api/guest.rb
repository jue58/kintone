require 'forwardable'
require 'kintone/api'

class Kintone::Api
  class Guest
    extend Forwardable

    GUEST_PATH = "/k/guest/%s/v1/"

    def initialize(space_id, api)
      @api = api
      @guest_path = GUEST_PATH % space_id
    end

    def get_url(command)
      return @guest_path + (COMMAND % command)
    end

    def record
      return Kintone::Command::Record.new(self)
    end

    def records
      return Kintone::Command::Records.new(self)
    end

    def form
      return Kintone::Command::Form.new(self)
    end

    def app_acl
      return Kintone::Command::AppAcl.new(self)
    end

    def record_acl
      return Kintone::Command::RecordAcl.new(self)
    end

    def field_acl
      return Kintone::Command::FieldAcl.new(self)
    end

    def_delegators :@api, :get, :post, :put, :delete
  end
end

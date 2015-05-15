require 'forwardable'
require 'kintone/api'
require 'kintone/command/space_guests'

class Kintone::Api
  class Guest
    extend Forwardable

    GUEST_PATH = '/k/guest/%s/v1/'

    def initialize(space_id, api)
      @api = api
      @guest_path = GUEST_PATH % space_id
    end

    def get_url(command)
      @guest_path + (COMMAND % command)
    end

    def record
      Kintone::Command::Record.new(self)
    end

    def records
      Kintone::Command::Records.new(self)
    end

    def form
      Kintone::Command::Form.new(self)
    end

    def app_acl
      Kintone::Command::AppAcl.new(self)
    end

    def record_acl
      Kintone::Command::RecordAcl.new(self)
    end

    def field_acl
      Kintone::Command::FieldAcl.new(self)
    end

    def space
      Kintone::Command::Space.new(self)
    end

    def space_body
      Kintone::Command::SpaceBody.new(self)
    end

    def space_thread
      Kintone::Command::SpaceThread.new(self)
    end

    def space_members
      Kintone::Command::SpaceMembers.new(self)
    end

    def space_guests
      Kintone::Command::SpaceGuests.new(self)
    end

    def app
      Kintone::Command::App.new(self)
    end

    def apps
      Kintone::Command::Apps.new(self)
    end

    def bulk
      Kintone::Command::BulkRequest.new(self)
    end

    def_delegators :@api, :get, :post, :put, :delete
  end
end

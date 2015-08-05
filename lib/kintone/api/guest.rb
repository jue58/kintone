require 'forwardable'
require 'kintone/api'
require 'kintone/command/accessor'

class Kintone::Api
  class Guest
    extend Forwardable

    GUEST_PATH = '/k/guest/%s/v1/'
    ACCESSIBLE_COMMAND = [
      :record,
      :records,
      :form,
      :app_acl,
      :record_acl,
      :field_acl,
      :space,
      :space_body,
      :space_thread,
      :space_members,
      :space_guests,
      :app,
      :apps,
      :bulk_request,
      :bulk
    ].freeze

    def_delegators :@api, :get, :post, :put, :delete

    def initialize(space_id, api)
      @api = api
      @guest_path = GUEST_PATH % space_id
    end

    def get_url(command)
      @guest_path + (COMMAND % command)
    end

    def method_missing(name, *args)
      if ACCESSIBLE_COMMAND.include?(name)
        CommandAccessor.send(name, self)
      else
        super(name, *args)
      end
    end

    class CommandAccessor
      extend Kintone::Command::Accessor
    end
  end
end

class Kintone::Command
  # common
  autoload :Record, 'kintone/command/record'
  autoload :Records, 'kintone/command/records'
  autoload :BulkRequest, 'kintone/command/bulk_request'
  autoload :Form, 'kintone/command/form'
  autoload :App, 'kintone/command/app'
  autoload :Apps, 'kintone/command/apps'
  autoload :AppAcl, 'kintone/command/app_acl'
  autoload :RecordAcl, 'kintone/command/record_acl'
  autoload :FieldAcl, 'kintone/command/field_acl'
  autoload :Space, 'kintone/command/space'
  autoload :SpaceBody, 'kintone/command/space_body'
  autoload :SpaceThread, 'kintone/command/space_thread'
  autoload :SpaceMembers, 'kintone/command/space_members'
  autoload :File, 'kintone/command/file'

  # other than guest
  autoload :TemplateSpace, 'kintone/command/template_space'
  autoload :Guests, 'kintone/command/guests'
  autoload :Apis, 'kintone/command/apis'

  # guest only
  autoload :SpaceGuests, 'kintone/command/space_guests'

  module Accessor
    # common
    def record(api)
      Record.new(api)
    end

    def records(api)
      Records.new(api)
    end

    def bulk_request(api)
      BulkRequest.new(api)
    end

    def form(api)
      Form.new(api)
    end

    def app(api)
      App.new(api)
    end

    def apps(api)
      Apps.new(api)
    end

    def app_acl(api)
      AppAcl.new(api)
    end

    def record_acl(api)
      RecordAcl.new(api)
    end

    def field_acl(api)
      FieldAcl.new(api)
    end

    def space(api)
      Space.new(api)
    end

    def space_body(api)
      SpaceBody.new(api)
    end

    def space_thread(api)
      SpaceThread.new(api)
    end

    def space_members(api)
      SpaceMembers.new(api)
    end

    def file(api)
      File.new(api)
    end

    # other than guest
    def template_space(api)
      TemplateSpace.new(api)
    end

    def guests(api)
      Guests.new(api)
    end

    def apis(api)
      Apis.new(api)
    end

    # guest only
    def space_guests(api)
      SpaceGuests.new(api)
    end

    alias bulk bulk_request
  end
end

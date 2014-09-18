require 'spec_helper'
require 'kintone/command/space_members'
require 'kintone/api'

describe Kintone::Command::SpaceMembers do
  let(:target) { Kintone::Command::SpaceMembers.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/space/members.json'
      )
        .with(query: { id: id })
        .to_return(body: response_data.to_json, status: 200)
    end

    subject { target.get(id) }

    let(:id) { 1 }

    def response_data
      {
        'members' => members
      }
    end

    def members
      [
        {
          'entity' => { 'type' => 'USER', 'code' => 'user1' },
          'isAdmin' => false,
          'isImplicit' => true
        }
      ]
    end

    it { expect(subject).to match members }
  end

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/v1/space/members.json'
      )
        .with(body: request_data.to_json)
        .to_return(body: '{}', status: 200)
    end

    subject { target.update(id, members) }

    let(:id) { 1 }
    let(:members) do
      [
        {
          'entity' => { 'type' => 'USER', 'code' => 'user1' },
          'isAdmin' => false,
          'isImplicit' => true
        }
      ]
    end

    def request_data
      {
        'id' => 1,
        'members' => [
          {
            'entity' => { 'type' => 'USER', 'code' => 'user1' },
            'isAdmin' => false,
            'isImplicit' => true
          }
        ]
      }
    end

    it { expect(subject).to be_truthy }
  end
end

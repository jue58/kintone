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
        .to_return(
          body: response_data.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get(id) }

    let(:id) { 1 }
    let(:response_data) { { 'members' => members } }
    let(:members) do
      [
        {
          'entity' => { 'type' => 'USER', 'code' => 'user1' },
          'isAdmin' => false,
          'isImplicit' => true
        }
      ]
    end

    it { expect(subject).to match members }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/space/members.json'
        )
          .with(query: { id: id })
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/v1/space/members.json'
      )
        .with(body: request_data.to_json)
        .to_return(
          body: '{}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
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

    let(:request_data) do
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

    context 'fail to request' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/v1/space/members.json'
        )
          .with(body: request_data.to_json)
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end
end

require 'spec_helper'
require 'kintone/command/template_space'
require 'kintone/api'

describe Kintone::Command::TemplateSpace do
  let(:target) { Kintone::Command::TemplateSpace.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#create' do
    before(:each) do
      stub_request(
        :post,
        'https://example.cybozu.com/k/v1/template/space.json'
      )
        .with(body: request_data.to_json)
        .to_return(
          body: '{"id":"1"}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.create(id, name, members, is_guest: is_guest, fixed_member: fixed_member) }

    let(:id) { 1 }
    let(:name) { 'sample space' }
    let(:members) { [] }
    let(:is_guest) { false }
    let(:fixed_member) { false }
    let(:request_data) do
      {
        id: id,
        name: name,
        members: members,
        isGuest: is_guest,
        fixedMember: fixed_member
      }
    end

    it { expect(subject).to eq 'id' => '1' }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :post,
          'https://example.cybozu.com/k/v1/template/space.json'
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

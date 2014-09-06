require 'spec_helper'
require 'kintone/command/field_acl'
require 'kintone/api'

describe Kintone::Command::FieldAcl do
  let(:target) { Kintone::Command::FieldAcl.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#update' do
    subject { target.update(id, rights) }

    context '' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/v1/field/acl.json'
        )
          .with(body: { 'id' => 1, 'rights' => { 'p1' => 'abc', 'p2' => 'def' } }.to_json)
          .to_return(body: '{}', status: 200)
      end

      let(:id) { 1 }
      let(:rights) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { expect(subject).to eq({}) }
    end
  end
end

require 'spec_helper'
require 'kintone/command/record_acl'
require 'kintone/api'

describe Kintone::Command::RecordAcl do
  let(:target) { Kintone::Command::RecordAcl.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#update' do
    subject { target.update(id, rights) }

    context '' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/v1/record/acl.json'
        )
          .with(body: { 'id' => 1, 'rights' => { 'p1' => 'abc', 'p2' => 'def' } }.to_json)
          .to_return(body: '{}', status: 200, headers: {'Content-type' => 'application/json'})
      end

      let(:id) { 1 }
      let(:rights) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { expect(subject).to eq({}) }
    end
  end
end

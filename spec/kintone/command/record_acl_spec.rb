require 'spec_helper'
require 'kintone/command/record_acl'
require 'kintone/api'

describe Kintone::Command::RecordAcl do
  let(:target) { Kintone::Command::RecordAcl.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/v1/record/acl.json'
      )
        .with(body: request_body.to_json)
        .to_return(
          body: '{}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.update(id, rights) }

    let(:id) { 1 }
    let(:rights) { { 'p1' => 'abc', 'p2' => 'def' } }
    let(:request_body) { { 'id' => 1, 'rights' => { 'p1' => 'abc', 'p2' => 'def' } } }

    it { expect(subject).to eq({}) }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/v1/record/acl.json'
        )
          .with(body: request_body.to_json)
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

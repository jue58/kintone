require 'spec_helper'
require 'kintone/command/field_acl'
require 'kintone/api'

describe Kintone::Command::FieldAcl do
  let(:target) { Kintone::Command::FieldAcl.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/v1/field/acl.json'
      )
        .with(body: { 'id' => 1, 'rights' => { 'p1' => 'abc', 'p2' => 'def' } }.to_json)
        .to_return(
          body: '{}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    let(:id) { 1 }
    let(:rights) { { 'p1' => 'abc', 'p2' => 'def' } }

    subject { target.update(id, rights) }

    it { expect(subject).to eq({}) }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/v1/field/acl.json'
        )
          .with(body: { 'id' => 1, 'rights' => { 'p1' => 'abc', 'p2' => 'def' } }.to_json)
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

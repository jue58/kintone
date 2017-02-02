require 'spec_helper'
require 'kintone/command/space'
require 'kintone/api'

describe Kintone::Command::Space do
  let(:target) { Kintone::Command::Space.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/space.json'
      )
        .with(query: { id: 1 })
        .to_return(
          body: result.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get(id) }

    let(:id) { 1 }
    let(:result) { { 'id' => '1', 'name' => 'sample space' } }

    it { expect(subject).to eq(result) }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/space.json'
        )
          .with(query: { id: 1 })
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#delete' do
    before(:each) do
      stub_request(
        :delete,
        'https://example.cybozu.com/k/v1/space.json'
      )
        .with(body: { id: 1 }.to_json)
        .to_return(
          body: '{}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.delete(id) }

    let(:id) { 1 }

    it { expect(subject).to be_truthy }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :delete,
          'https://example.cybozu.com/k/v1/space.json'
        )
          .with(body: { id: 1 }.to_json)
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

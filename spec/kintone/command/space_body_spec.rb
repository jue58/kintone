require 'spec_helper'
require 'kintone/command/space_body'
require 'kintone/api'

describe Kintone::Command::SpaceBody do
  let(:target) { Kintone::Command::SpaceBody.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/v1/space/body.json'
      )
        .with(body: { id: 1, body: '<b>総務課</b>専用のスペースです。' }.to_json)
        .to_return(
          body: '{}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.update(id, body) }

    let(:id) { 1 }
    let(:body) { '<b>総務課</b>専用のスペースです。' }

    it { expect(subject).to eq({}) }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/v1/space/body.json'
        )
          .with(body: { id: 1, body: '<b>総務課</b>専用のスペースです。' }.to_json)
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

require 'spec_helper'
require 'kintone/command/form'
require 'kintone/api'

describe Kintone::Command::Form do
  let(:target) { Kintone::Command::Form.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/form.json?app=4'
      )
        .to_return(
          body: '{"result":"ok"}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get(app) }

    let(:app) { 4 }

    it { expect(subject).to eq 'result' => 'ok' }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/form.json?app=4'
        )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end
end

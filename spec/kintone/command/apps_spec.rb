require 'spec_helper'
require 'kintone/command/apps'

describe Kintone::Command::Apps do
  let(:target) { Kintone::Command::Apps.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    subject { target.get(params) }

    context '引数にHashのデータを指定した場合' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/apps.json'
        )
          .with(body: params.to_json)
          .to_return(
            body: { apps: [] }.to_json,
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      where(:params) do
        [
          [{ ids: [100, 200] }],
          [{ ids: [] }],
          [{ ids: nil }],
          [{ codes: ['AAA', 'BBB'] }],
          [{ codes: [] }],
          [{ codes: nil }],
          [{ name: '名前' }],
          [{ name: '' }],
          [{ name: nil }],
          [{ spaceIds: [100, 200] }],
          [{ spaceIds: [] }],
          [{ spaceIds: nil }],
          [{ limit: 100 }],
          [{ limit: nil }],
          [{ offset: 100 }],
          [{ offset: nil }],
          [{}]
        ]
      end

      with_them do
        it { is_expected.to be_a_kind_of(Array) }
      end
    end

    context '引数にnilを指定した場合' do
      let(:params) { nil }

      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/apps.json'
        )
          .with(body: params.to_h.to_json)
          .to_return(
            body: { apps: [] }.to_json,
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      it { is_expected.to be_a_kind_of(Array) }
    end

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/apps.json'
        )
          .with(body: params.to_json)
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      let(:params) { { ids: [100, 200] } }

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end
end

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
          .with(query: query)
          .to_return(
            body: { apps: [] }.to_json,
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      where(:params, :query) do
        [
          [{ ids: [100, 200] }, 'ids[0]=100&ids[1]=200'],
          [{ ids: [] }, nil],
          [{ ids: nil }, 'ids'],
          [{ codes: ['AAA', 'BBB'] }, 'codes[0]=AAA&codes[1]=BBB'],
          [{ codes: [] }, nil],
          [{ codes: nil }, 'codes'],
          [{ name: '名前' }, 'name=名前'],
          [{ name: '' }, 'name='],
          [{ name: nil }, 'name'],
          [{ spaceIds: [100, 200] }, 'spaceIds[0]=100&spaceIds[1]=200'],
          [{ spaceIds: [] }, nil],
          [{ spaceIds: nil }, 'spaceIds'],
          [{ limit: 100 }, 'limit=100'],
          [{ limit: nil }, 'limit'],
          [{ offset: 100 }, 'offset=100'],
          [{ offset: nil }, 'offset'],
          [{}, nil]
        ]
      end

      with_them do
        it { is_expected.to be_a_kind_of(Array) }
      end
    end

    context '引数にnilを指定した場合' do
      let(:params) { nil }

      it { expect { subject }.to raise_error NoMethodError }
    end

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/apps.json'
        )
          .with(query: query)
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      let(:params) { { ids: [100, 200] } }
      let(:query) { 'ids[0]=100&ids[1]=200' }

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end
end

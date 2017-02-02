require 'spec_helper'
require 'kintone/command/bulk_request'
require 'kintone/api'

describe Kintone::Command::BulkRequest do
  let(:target) { Kintone::Command::BulkRequest.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#request' do
    before(:each) do
      stub_request(
        :post,
        'https://example.cybozu.com/k/v1/bulkRequest.json'
      )
        .with(body: { requests: requests }.to_json)
        .to_return(
          body: { 'results' => results }.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.request(requests) }

    let(:requests) do
      [
        {
          method: 'POST',
          api: '/k/v1/record.json',
          payload: {
            app: 1972,
            record: {
              '文字列__1行' => {
                value: '文字列__1行を追加します。'
              }
            }
          }
        },
        {
          method: 'PUT',
          api: '/k/v1/record.json',
          payload: {
            app: 1973,
            id: 33,
            revision: 2,
            record: {
              '文字列__1行' => {
                value: '文字列__1行を更新します。'
              }
            }
          }
        },
        {
          method: 'DELETE',
          api: '/k/v1/records.json',
          payload: {
            app: 1974,
            ids: [10, 11],
            revisions: [1, 1]
          }
        }
      ]
    end

    let(:results) do
      [
        { 'id' => '39', 'revision' => '1' },
        { 'revision' => '34' },
        {}
      ]
    end

    it { is_expected.to eq results }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :post,
          'https://example.cybozu.com/k/v1/bulkRequest.json'
        )
          .with(body: { requests: requests }.to_json)
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

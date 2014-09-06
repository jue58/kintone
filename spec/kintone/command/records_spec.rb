require 'spec_helper'
require 'kintone/command/records'
require 'kintone/api'

describe Kintone::Command::Records do
  let(:target) { Kintone::Command::Records.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    subject { target.get(app, query, fields) }
    let(:app) { 8 }
    let(:query) { '' }
    let(:fields) { [] }

    context 'アプリIDだけ指定した時' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/records.json?app=8&query='
        )
          .to_return(body: response_data.to_json, status: 200)
      end

      def response_data
        { 'records' => [{ 'record_id' => { 'type' => 'RECORD_NUMBER', 'value' => '1' } }] }
      end

      it { expect(subject).to eq response_data }
    end

    context '条件に文字列を含むqueryを指定した時' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/records.json?app=8&query=updated_time%20%3e%20%222012%2d02%2d03T09%3a00%3a00%2b0900%22%20and%20updated_time%20%3c%20%222012%2d02%2d03T10%3a00%3a00%2b0900%22'
        )
          .to_return(body: response_data.to_json, status: 200)
      end

      let(:query) { "updated_time > \"2012-02-03T09:00:00+0900\" and updated_time < \"2012-02-03T10:00:00+0900\"" } # rubocop:disable Style/LineLength

      def response_data
        { 'records' => [{ 'record_id' => { 'type' => 'RECORD_NUMBER', 'value' => '1' } }] }
      end

      it { expect(subject).to eq response_data }
    end

    context '項目に全角文字を含むfieldsを指定した時' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/records.json?app=8&query=&fields%5b0%5d=%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89%E7%95%AA%E5%8F%B7&fields%5b1%5d=created_time&fields%5b2%5d=dropdown'
        )
          .to_return(body: response_data.to_json, status: 200)
      end

      let(:fields) { %w(レコード番号 created_time dropdown) }

      def response_data
        { 'records' => [{ 'record_id' => { 'type' => 'RECORD_NUMBER', 'value' => '1' } }] }
      end

      it { expect(subject).to eq response_data }
    end

    context 'queryにnilを指定した時' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/records.json?'
        )
          .with(query: { app: 8, query: nil })
          .to_return(body: response_data.to_json, status: 200)
      end

      let(:query) { nil }

      def response_data
        { 'records' => [{ 'record_id' => { 'type' => 'RECORD_NUMBER', 'value' => '1' } }] }
      end

      it { expect(subject).to eq response_data }
    end

    context 'fieldsにnilを指定した時' do
      let(:fields) { nil }

      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end

  describe '#register' do
    subject { target.register(app, records) }

    context '' do
      def records_data
        [
          {
            'rich_editor' => { 'value' => 'testtest' }
          },
          {
            'user_select' => { 'value' => [{ 'code' => 'suzuki' }] }
          }
        ]
      end

      before(:each) do
        stub_request(
          :post,
          'https://example.cybozu.com/k/v1/records.json'
        )
          .with(body: { 'app' => 7, 'records' => records_data }.to_json)
          .to_return(body: "{\"ids\":[\"100\", \"101\"]}", status: 200)
      end

      let(:app) { 7 }
      let(:records) { records_data }

      it { expect(subject).to eq 'ids' => %w(100 101) }
    end
  end

  describe '#update' do
    subject { target.update(app, records) }

    context '' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/v1/records.json'
        )
          .with(body: { 'app' => 4, 'records' => records_data }.to_json)
          .to_return(body: '{}', status: 200)
      end

      let(:app) { 4 }
      let(:records) { records_data }

      def records_data
        [
          { 'id' => 1, 'record' => { 'string_1' => { 'value' => 'abcdef' } } },
          { 'id' => 2, 'record' => { 'string_multi' => { 'value' => 'opqrstu' } } }
        ]
      end

      it { expect(subject).to eq({}) }
    end
  end

  describe '#delete' do
    subject { target.delete(app, ids) }

    context '' do
      before(:each) do
        stub_request(
          :delete,
          'https://example.cybozu.com/k/v1/records.json?app=1&ids[0]=100&ids[1]=80'
        )
          .to_return(body: '{}', status: 200)
      end

      let(:app) { 1 }
      let(:ids) { [100, 80] }

      it { expect(subject).to eq({}) }
    end
  end
end

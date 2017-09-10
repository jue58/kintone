require 'spec_helper'
require 'kintone/command/apis'

describe Kintone::Command::Apis do
  let(:target) { Kintone::Command::Apis.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/apis.json'
      )
        .to_return(
          body: response_data.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get }

    def response_data
      {
        'baseUrl' => 'https://example.cybozu.com/k/v1/',
        'apis' => {
          'records/get' => {
            'link' => 'apis/records/get.json'
          }
        }
      }
    end

    it { is_expected.to eq(response_data) }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/apis.json'
        )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#get_details_of' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/apis/records/get.json'
      )
        .to_return(
          body: response_data.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get_details_of(link) }

    let(:link) { 'apis/records/get.json' }

    def response_data
      {
        'id' => 'GetRecords',
        'baseUrl' => 'https://example.cybozu.com/k/v1/',
        'path' => 'records.json',
        'httpMethod' => 'GET'
      }
    end

    it { is_expected.to eq(response_data) }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/apis/records/get.json'
        )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#get_details_of_key' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/apis.json'
      )
        .to_return(
          body: apis_response_data.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )

      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/apis/records/get.json'
      )
        .to_return(
          body: api_response_data.to_json,
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get_details_of_key(key) }

    def apis_response_data
      {
        'baseUrl' => 'https://example.cybozu.com/k/v1/',
        'apis' => {
          'records/get' => {
            'link' => 'apis/records/get.json'
          }
        }
      }
    end

    def api_response_data
      {
        'id' => 'GetRecords',
        'baseUrl' => 'https://example.cybozu.com/k/v1/',
        'path' => 'records.json',
        'httpMethod' => 'GET'
      }
    end

    context 'with key that exists' do
      let(:key) { 'records/get' }

      it { is_expected.to eq(api_response_data) }
    end

    context 'with key that does not exists' do
      let(:key) { 'records/hoge' }

      it { expect { subject }.to raise_error NoMethodError }
    end

    context 'with nil' do
      let(:key) { nil }

      it { expect { subject }.to raise_error NoMethodError }
    end

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/apis/records/get.json'
        )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      let(:key) { 'records/get' }

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end
end

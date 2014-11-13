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
        .to_return(body: response_data.to_json, status: 200)
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
  end

  describe '#get_details_of' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/apis/records/get.json'
      )
        .to_return(body: response_data.to_json, status: 200)
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
  end
end

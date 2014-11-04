require 'spec_helper'
require 'kintone/command/app'

describe Kintone::Command::App do
  let(:target) { Kintone::Command::App.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/app.json'
      )
        .with(query: { id: id })
        .to_return(body: response_data.to_json, status: 200)
    end

    subject { target.get(id) }

    let(:id) { 4 }

    def response_data
      {
        appId: '4',
        code: '',
        name: 'アプリ',
        description: 'よいアプリです'
      }
    end

    it { is_expected.to be_kind_of(Hash) }
  end
end

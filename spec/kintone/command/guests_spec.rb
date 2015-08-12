require 'spec_helper'
require 'kintone/command/guests'
require 'kintone/api'

describe Kintone::Command::Guests do
  let(:target) { Kintone::Command::Guests.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#register' do
    before(:each) do
      stub_request(
        :post,
        'https://example.cybozu.com/k/v1/guests.json'
      )
        .with(body: { guests: guests }.to_json)
        .to_return(body: '{}', status: 200)
    end

    subject { target.register(guests) }

    let(:guests) do
      [
        {
          code: 'hoge@example.com',
          password: 'password',
          timezone: 'Asia/Tokyo',
          locale: 'ja',
          image: '78a586f2-e73e-4a70-bec2-43976a60746e',
          name: '東京 三郎',
          surNameReading: 'とうきょう',
          givenNameReading: 'さぶろう',
          company: 'サイボウズ株式会社',
          division: '営業部',
          phone: '999-456-7890',
          callto: 'tokyo3rou'
        }
      ]
    end

    it { is_expected.to be_truthy }
  end

  describe '#delete' do
    before(:each) do
      stub_request(
        :delete,
        'https://example.cybozu.com/k/v1/guests.json'
      )
        .with(body: { guests: guests }.to_json)
        .to_return(body: '{}', status: 200)
    end

    subject { target.delete(guests) }

    let(:guests) do
      [
        'guest1@example.com',
        'guest2@example.com',
        'guest3@example.com'
      ]
    end

    it { is_expected.to be_truthy }
  end
end

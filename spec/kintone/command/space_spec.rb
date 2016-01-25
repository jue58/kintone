require 'spec_helper'
require 'kintone/command/space'
require 'kintone/api'

describe Kintone::Command::Space do
  let(:target) { Kintone::Command::Space.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    subject { target.get(id) }

    context '' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/space.json'
        )
          .with(query: { id: 1 })
          .to_return(body: result.to_json, status: 200, headers: {'Content-type' => 'application/json'})
      end

      let(:id) { 1 }

      def result
        {
          'id' => '1',
          'name' => 'sample space'
        }
      end

      it { expect(subject).to eq(result) }
    end
  end

  describe '#delete' do
    subject { target.delete(id) }

    context '' do
      before(:each) do
        stub_request(
          :delete,
          'https://example.cybozu.com/k/v1/space.json'
        )
          .with(body: { id: 1 }.to_json)
          .to_return(body: '{}', status: 200, headers: {'Content-type' => 'application/json'})
      end

      let(:id) { 1 }

      it { expect(subject).to be_truthy }
    end
  end
end

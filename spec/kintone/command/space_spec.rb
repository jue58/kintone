require 'spec_helper'
require 'kintone/command/space'
require 'kintone/api'

describe Kintone::Command::Space do
  let(:target) { Kintone::Command::Space.new(api) }
  let(:api) { Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu") }

  describe "#get" do
    subject { target.get(id) }

    context "" do
      before(:each) do
        stub_request(
          :get,
          "https://example.cybozu.com/k/v1/space.json?id=1"
        ).
        to_return(:body => result.to_json)
      end

      let(:id) { 1 }

      def result
        return {
          "id" => "1",
          "name" => "sample space"
        }
      end

      it { expect(subject).to eq(result) }
    end
  end
end

require 'spec_helper'
require 'kintone/command/app_acl'
require 'kintone/api'

describe Kintone::Command::AppAcl do
  let(:target) { Kintone::Command::AppAcl.new(api) }
  let(:api) { Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu") }

  describe "#update" do
    subject { target.update(app, rights) }

    context "" do
      before(:each) do
        stub_request(
          :put,
          "https://example.cybozu.com/k/v1/app/acl.json"
        ).
        with(:body => {"app" => 1, "rights" => {"p1" => "abc", "p2" => "def"}}.to_json).
        to_return(:body => "{}", :status => 200)
      end

      let(:app) { 1 }
      let(:rights) { {"p1" => "abc", "p2" => "def"} }

      it { expect(subject).to eq({}) }
    end
  end
end

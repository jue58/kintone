require 'kintone/command/form'
require 'kintone/api'

describe Kintone::Command::Form do
  let(:target) { Kintone::Command::Form.new(api) }
  let(:api) { Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu") }

  describe "#get" do
    subject { target.get(app) }

    context "" do
      before(:each) do
        stub_request(
          :get,
          "https://example.cybozu.com/k/v1/form.json?app=4"
        ).
        to_return(:body => "{\"result\":\"ok\"}", :status => 200)
      end

      let(:app) { 4 }

      it { expect(subject).to eq({"result" => "ok"})}
    end
  end
end

require 'spec_helper'
require 'kintone/command/record'
require 'kintone/api'

describe Kintone::Command::Record do
  let(:target) { Kintone::Command::Record.new(api) }
  let(:api) { Kintone::Api.new("www.example.com", "Administrator", "cybozu") }

  describe "#get" do
    subject { target.get(app, id) }

    context "引数が整数型の時" do
      before(:each) do
        stub_request(
          :get,
          "https://www.example.com/k/v1/record.json?app=100&id=1"
        ).
        to_return(:body => "{\"result\":\"ok\"}", :status => 200)
      end

      let(:app) { 100 }
      let(:id) { 1 }

      it { expect(subject).to eq({"result" => "ok"}) }
    end

    context "引数が数字の文字列の時" do
      before(:each) do
        stub_request(
          :get,
          "https://www.example.com/k/v1/record.json?app=100&id=1"
        ).
        to_return(:body => "{\"result\":\"ok\"}", :status => 200)
      end

      let(:app) { "100" }
      let(:id) { "1" }

      it { expect(subject).to eq({"result" => "ok"}) }
    end
  end
end

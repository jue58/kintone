require 'spec_helper'
require 'kintone/api'
require 'kintone/api/guest'
require 'kintone/command/record'
require 'kintone/command/records'

describe Kintone::Api do
  let(:target) { Kintone::Api.new(domain, user, password) }
  let(:domain) { "www.example.com" }
  let(:user) { "Administrator" }
  let(:password) { "cybozu" }

  describe "#get_url" do
    subject { target.get_url(command) }

    context "" do
      let(:command) { "path" }
      it { expect(subject).to eq("/k/v1/path.json") }
    end
  end

  describe "#guest" do
    subject { target.guest(space) }

    context "引数が数値の1の時" do
      let(:space) { 1 }

      it { expect(subject).to be_a_kind_of(Kintone::Api::Guest) }
      it { expect(subject.instance_variable_get(:@guest_path)).to eq("/k/guest/1/v1/") }
    end

    context "引数がnilの時" do
      let(:space) { nil }
      xit { expect(subject.instance_variable_get(:@guest_path)).to eq("/k/guest//v1/") }
    end

    context "引数に数字以外の文字が含まれる時" do
      let(:space) { "2.1" }
      xit { expect(subject.instance_variable_get(:@guest_path)).to eq("/k/guest//v1/") }
    end
  end

  describe "#get" do
    before(:each) do
      stub_request(
        :get,
        "https://www.example.com/k/v1/path?p1=abc&p2=def"
      ).
      with(:headers => {"X-Cybozu-Authorization" => "QWRtaW5pc3RyYXRvcjpjeWJvenU="}).
      to_return(:body => "{\"abc\":\"def\"}", :status => 200)
    end

    subject { target.get(path, params) }
    let(:path) { "/k/v1/path" }
    let(:params) { {"p1" => "abc", "p2" => "def"} }

    it { expect(subject).to eq({"abc" => "def"}) }
  end

  describe "#post" do
    before(:each) do
      stub_request(
        :post,
        "https://www.example.com/k/v1/path"
      ).
      with(:headers => {"X-Cybozu-Authorization" => "QWRtaW5pc3RyYXRvcjpjeWJvenU=", "Content-Type" => "application/json"},
           :body => "{\"p1\":\"abc\",\"p2\":\"def\"}").
      to_return(:body => "{\"abc\":\"def\"}", :status => 200)
    end

    subject { target.post(path, body) }
    let(:path) { "/k/v1/path" }
    let(:body) { {"p1" => "abc", "p2" => "def"} }

    it { expect(subject).to eq({"abc" => "def"}) }
  end

  describe "#put" do
    before(:each) do
      stub_request(
        :put,
        "https://www.example.com/k/v1/path"
      ).
      with(:headers => {"X-Cybozu-Authorization" => "QWRtaW5pc3RyYXRvcjpjeWJvenU=", "Content-Type" => "application/json"},
           :body => "{\"p1\":\"abc\",\"p2\":\"def\"}").
      to_return(:body => "{\"abc\":\"def\"}", :status => 200)
    end

    subject { target.put(path, body) }
    let(:path) { "/k/v1/path" }
    let(:body) { {"p1" => "abc", "p2" => "def"} }

    it { expect(subject).to eq({"abc" => "def"}) }
  end
  
  describe "#delete" do
    before(:each) do
      stub_request(
        :delete,
        "https://www.example.com/k/v1/path?p1=abc&p2=def"
      ).
      with(:headers => {"X-Cybozu-Authorization" => "QWRtaW5pc3RyYXRvcjpjeWJvenU="}).
      to_return(:body => "{\"abc\":\"def\"}", :status => 200)
    end

    subject { target.delete(path, params) }
    let(:path) { "/k/v1/path" }
    let(:params) { {"p1" => "abc", "p2" => "def"} }

    it { expect(subject).to eq({"abc" => "def"}) }
  end

  describe "#record" do
    subject { target.record }

    it { expect(subject).to be_a_kind_of(Kintone::Command::Record) }
  end

  describe "#records" do
    subject { target.records }

    it { expect(subject).to be_a_kind_of(Kintone::Command::Records) }
  end

  describe "#form" do
    subject { target.form }

    it { expect(subject).to be_a_kind_of(Kintone::Command::Form) }
  end

  describe "#app_acl" do
    subject { target.app_acl }

    it { expect(subject).to be_a_kind_of(Kintone::Command::AppAcl) }
  end

  describe "#record_acl" do
    subject { target.record_acl }

    it { expect(subject).to be_a_kind_of(Kintone::Command::RecordAcl) }
  end

  describe "#field_acl" do
    subject { target.field_acl }

    it { expect(subject).to be_a_kind_of(Kintone::Command::FieldAcl) }
  end

  describe "#template_space" do
    subject { target.template_space }

    it { expect(subject).to be_a_kind_of(Kintone::Command::TemplateSpace) }
  end
end

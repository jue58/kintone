require 'spec_helper'
require 'kintone/api/guest'
require 'kintone/api'

describe Kintone::Api::Guest do
  let(:target) { Kintone::Api::Guest.new(space, api) }
  let(:space) { 1 }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get_url' do
    subject { target.get_url(command) }

    let(:command) { 'path' }

    it { expect(subject).to eq('/k/guest/1/v1/path.json') }
  end

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/guest/1/v1/path.json'
      )
        .with(
          headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
          query: params
        )
        .to_return(body: "{\"abc\":\"def\"}", status: 200)
    end

    subject { target.get(path, params) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:params) { { p1: 'abc', p2: 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }
  end

  describe '#post' do
    before(:each) do
      stub_request(
        :post,
        'https://example.cybozu.com/k/guest/1/v1/path.json'
      )
        .with(
          headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
          body: "{\"p1\":\"abc\",\"p2\":\"def\"}"
        )
        .to_return(body: "{\"abc\":\"def\"}", status: 200)
    end

    subject { target.post(path, body) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }
  end

  describe '#put' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/guest/1/v1/path.json'
      )
        .with(
          headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
          body: "{\"p1\":\"abc\",\"p2\":\"def\"}"
        )
        .to_return(body: "{\"abc\":\"def\"}", status: 200)
    end

    subject { target.put(path, body) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }
  end

  describe '#delete' do
    before(:each) do
      stub_request(
        :delete,
        'https://example.cybozu.com/k/guest/1/v1/path.json?p1=abc&p2=def'
      )
        .with(headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' })
        .to_return(body: "{\"abc\":\"def\"}", status: 200)
    end

    subject { target.delete(path, params) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:params) { { 'p1' => 'abc', 'p2' => 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }
  end

  describe '#record' do
    subject { target.record }

    it { expect(subject).to be_a_kind_of(Kintone::Command::Record) }
  end

  describe '#records' do
    subject { target.records }

    it { expect(subject).to be_a_kind_of(Kintone::Command::Records) }
  end

  describe '#form' do
    subject { target.form }

    it { expect(subject).to be_a_kind_of(Kintone::Command::Form) }
  end

  describe '#app_acl' do
    subject { target.app_acl }

    it { expect(subject).to be_a_kind_of(Kintone::Command::AppAcl) }
  end

  describe '#record_acl' do
    subject { target.record_acl }

    it { expect(subject).to be_a_kind_of(Kintone::Command::RecordAcl) }
  end

  describe '#field_acl' do
    subject { target.field_acl }

    it { expect(subject).to be_a_kind_of(Kintone::Command::FieldAcl) }
  end

  describe '#space' do
    subject { target.space }

    it { expect(subject).to be_a_kind_of(Kintone::Command::Space) }
  end

  describe '#space_body' do
    subject { target.space_body }

    it { expect(subject).to be_a_kind_of(Kintone::Command::SpaceBody) }
  end

  describe '#space_thread' do
    subject { target.space_thread }

    it { expect(subject).to be_a_kind_of(Kintone::Command::SpaceThread) }
  end
end

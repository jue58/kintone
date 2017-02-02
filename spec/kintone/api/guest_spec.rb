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
        .to_return(
          body: '{"abc":"def"}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get(path, params) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:params) { { p1: 'abc', p2: 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/guest/1/v1/path.json'
        )
          .with(
            headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
            query: params
          )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#post' do
    before(:each) do
      stub_request(
        :post,
        'https://example.cybozu.com/k/guest/1/v1/path.json'
      )
        .with(
          headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
          body: '{"p1":"abc","p2":"def"}'
        )
        .to_return(
          body: '{"abc":"def"}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.post(path, body) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :post,
          'https://example.cybozu.com/k/guest/1/v1/path.json'
        )
          .with(
            headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
            body: '{"p1":"abc","p2":"def"}'
          )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#put' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/guest/1/v1/path.json'
      )
        .with(
          headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
          body: '{"p1":"abc","p2":"def"}'
        )
        .to_return(
          body: '{"abc":"def"}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.put(path, body) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :put,
          'https://example.cybozu.com/k/guest/1/v1/path.json'
        )
          .with(
            headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' },
            body: '{"p1":"abc","p2":"def"}'
          )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#delete' do
    before(:each) do
      stub_request(
        :delete,
        'https://example.cybozu.com/k/guest/1/v1/path.json'
      )
        .with(
          body: { 'p1' => 'abc', 'p2' => 'def' }.to_json,
          headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' }
        )
        .to_return(
          body: '{"abc":"def"}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.delete(path, params) }

    let(:path) { '/k/guest/1/v1/path.json' }
    let(:params) { { 'p1' => 'abc', 'p2' => 'def' } }

    it { expect(subject).to eq 'abc' => 'def' }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :delete,
          'https://example.cybozu.com/k/guest/1/v1/path.json'
        )
          .with(
            body: { 'p1' => 'abc', 'p2' => 'def' }.to_json,
            headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' }
          )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
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

  describe '#space_members' do
    subject { target.space_members }

    it { expect(subject).to be_a_kind_of(Kintone::Command::SpaceMembers) }
  end

  describe '#space_guests' do
    subject { target.space_guests }

    it { expect(subject).to be_a_kind_of(Kintone::Command::SpaceGuests) }
  end

  describe '#app' do
    subject { target.app }

    it { is_expected.to be_a_kind_of(Kintone::Command::App) }
  end

  describe '#apps' do
    subject { target.apps }

    it { is_expected.to be_a_kind_of(Kintone::Command::Apps) }
  end

  describe '#bulk_request' do
    subject { target.bulk_request }

    it { is_expected.to be_a_kind_of(Kintone::Command::BulkRequest) }
  end

  describe '#bulk' do
    subject { target.bulk }

    it { is_expected.to be_a_kind_of(Kintone::Command::BulkRequest) }
  end
end

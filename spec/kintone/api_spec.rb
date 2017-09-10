require 'spec_helper'
require 'kintone/api'
require 'kintone/api/guest'
require 'kintone/command/record'
require 'kintone/command/records'

describe Kintone::Api do
  let(:target) { Kintone::Api.new(domain, user, password) }
  let(:domain) { 'www.example.com' }

  context 'ユーザー認証の時' do
    let(:user) { 'Administrator' }
    let(:password) { 'cybozu' }

    describe '#get_url' do
      subject { target.get_url(command) }

      let(:command) { 'path' }

      it { is_expected.to eq('/k/v1/path.json') }
    end

    describe '#guest' do
      subject { target.guest(space) }

      context '引数が数値の1の時' do
        let(:space) { 1 }

        it { is_expected.to be_a_kind_of(Kintone::Api::Guest) }
        it { expect(subject.instance_variable_get(:@guest_path)).to eq('/k/guest/1/v1/') }
      end

      context '引数がnilの時' do
        let(:space) { nil }
        xit { expect(subject.instance_variable_get(:@guest_path)).to eq('/k/guest//v1/') }
      end

      context '引数に数字以外の文字が含まれる時' do
        let(:space) { '2.1' }
        xit { expect(subject.instance_variable_get(:@guest_path)).to eq('/k/guest//v1/') }
      end
    end

    describe '#get' do
      before(:each) do
        stub_request(
          :get,
          'https://www.example.com/k/v1/path'
        )
          .with(
            query: query,
            headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' }
          )
          .to_return(
            body: '{"abc":"def"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      subject { target.get(path, params) }

      let(:path) { '/k/v1/path' }

      context 'with some params' do
        let(:params) { { 'p1' => 'abc', 'p2' => 'def' } }
        let(:query) { 'p1=abc&p2=def' }

        it { is_expected.to eq 'abc' => 'def' }
      end

      context 'with empty params' do
        let(:params) { {} }
        let(:query) { nil }

        it { is_expected.to eq 'abc' => 'def' }
      end

      context 'with nil' do
        let(:params) { nil }
        let(:query) { nil }

        it { expect { subject }.to raise_error NoMethodError }
      end

      context 'with no params' do
        subject { target.get(path) }

        let(:query) { nil }

        it { is_expected.to eq 'abc' => 'def' }
      end

      context 'fail to request' do
        before(:each) do
          stub_request(
            :get,
            'https://www.example.com/k/v1/path'
          )
            .with(
              query: query,
              headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' }
            )
            .to_return(
              body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
              status: 500
            )
        end

        let(:params) { {} }
        let(:query) { nil }

        it { expect { subject }.to raise_error Kintone::KintoneError }
      end
    end

    describe '#post' do
      before(:each) do
        stub_request(
          :post,
          'https://www.example.com/k/v1/path'
        )
          .with(
            headers: {
              'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=',
              'Content-Type' => 'application/json'
            },
            body: '{"p1":"abc","p2":"def"}'
          )
          .to_return(
            body: '{"abc":"def"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      subject { target.post(path, body) }
      let(:path) { '/k/v1/path' }
      let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { is_expected.to eq 'abc' => 'def' }

      context 'fail to request' do
        before(:each) do
          stub_request(
            :post,
            'https://www.example.com/k/v1/path'
          )
            .with(
              headers: {
                'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=',
                'Content-Type' => 'application/json'
              },
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
          'https://www.example.com/k/v1/path'
        )
          .with(
            headers: {
              'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=',
              'Content-Type' => 'application/json'
            },
            body: '{"p1":"abc","p2":"def"}'
          )
          .to_return(
            body: '{"abc":"def"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      subject { target.put(path, body) }
      let(:path) { '/k/v1/path' }
      let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { is_expected.to eq 'abc' => 'def' }

      context 'fail to request' do
        before(:each) do
          stub_request(
            :put,
            'https://www.example.com/k/v1/path'
          )
            .with(
              headers: {
                'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=',
                'Content-Type' => 'application/json'
              },
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
          'https://www.example.com/k/v1/path'
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
      let(:path) { '/k/v1/path' }
      let(:params) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { is_expected.to eq 'abc' => 'def' }

      context 'fail to request' do
        before(:each) do
          stub_request(
            :delete,
            'https://www.example.com/k/v1/path'
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

    describe '#post_file' do
      before(:each) do
        stub_request(
          :post,
          'https://www.example.com/k/v1/path'
        )
          .with(headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' }) { attachment } # rubocop:disable Metrics/LineLength
          .to_return(
            body: '{"fileKey":"abc"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )

        expect(Faraday::UploadIO).to receive(:new).with(path, content_type, original_filename).and_return(attachment) # rubocop:disable Metrics/LineLength
      end

      subject { target.post_file(url, path, content_type, original_filename) }
      let(:attachment) { double('attachment') }
      let(:url) { '/k/v1/path' }
      let(:path) { '/path/to/file.txt' }
      let(:content_type) { 'text/plain' }
      let(:original_filename) { 'fileName.txt' }

      it { is_expected.to eq 'abc' }

      context 'fail to request' do
        before(:each) do
          stub_request(
            :post,
            'https://www.example.com/k/v1/path'
          )
            .with(headers: { 'X-Cybozu-Authorization' => 'QWRtaW5pc3RyYXRvcjpjeWJvenU=' }) { attachment } # rubocop:disable Metrics/LineLength
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

      it { is_expected.to be_a_kind_of(Kintone::Command::Record) }
    end

    describe '#records' do
      subject { target.records }

      it { is_expected.to be_a_kind_of(Kintone::Command::Records) }
    end

    describe '#form' do
      subject { target.form }

      it { is_expected.to be_a_kind_of(Kintone::Command::Form) }
    end

    describe '#app_acl' do
      subject { target.app_acl }

      it { is_expected.to be_a_kind_of(Kintone::Command::AppAcl) }
    end

    describe '#record_acl' do
      subject { target.record_acl }

      it { is_expected.to be_a_kind_of(Kintone::Command::RecordAcl) }
    end

    describe '#field_acl' do
      subject { target.field_acl }

      it { is_expected.to be_a_kind_of(Kintone::Command::FieldAcl) }
    end

    describe '#template_space' do
      subject { target.template_space }

      it { is_expected.to be_a_kind_of(Kintone::Command::TemplateSpace) }
    end

    describe '#space' do
      subject { target.space }

      it { is_expected.to be_a_kind_of(Kintone::Command::Space) }
    end

    describe '#space_body' do
      subject { target.space_body }

      it { is_expected.to be_a_kind_of(Kintone::Command::SpaceBody) }
    end

    describe '#space_thread' do
      subject { target.space_thread }

      it { is_expected.to be_a_kind_of(Kintone::Command::SpaceThread) }
    end

    describe '#space_members' do
      subject { target.space_members }

      it { is_expected.to be_a_kind_of(Kintone::Command::SpaceMembers) }
    end

    describe '#guests' do
      subject { target.guests }

      it { is_expected.to be_a_kind_of(Kintone::Command::Guests) }
    end

    describe '#app' do
      subject { target.app }

      it { is_expected.to be_a_kind_of(Kintone::Command::App) }
    end

    describe '#apps' do
      subject { target.apps }

      it { is_expected.to be_a_kind_of(Kintone::Command::Apps) }
    end

    describe '#apis' do
      subject { target.apis }

      it { is_expected.to be_a_kind_of(Kintone::Command::Apis) }
    end

    describe '#bulk_request' do
      subject { target.bulk_request }

      it { is_expected.to be_a_kind_of(Kintone::Command::BulkRequest) }
    end

    describe '#bulk' do
      subject { target.bulk }

      it { is_expected.to be_a_kind_of(Kintone::Command::BulkRequest) }
    end

    describe '#file' do
      subject { target.file }

      it { is_expected.to be_a_kind_of(Kintone::Command::File) }
    end
  end

  context 'APIトークン認証の時' do
    let(:user) { 'token-api' }
    let(:password) { nil }

    describe '#get' do
      before(:each) do
        stub_request(
          :get,
          'https://www.example.com/k/v1/path'
        )
          .with(query: query, headers: { 'X-Cybozu-API-Token' => 'token-api' })
          .to_return(
            body: '{"abc":"def"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      subject { target.get(path, params) }

      let(:path) { '/k/v1/path' }

      context 'with no params' do
        subject { target.get(path) }

        let(:query) { nil }

        it { is_expected.to eq 'abc' => 'def' }
      end
    end

    describe '#post' do
      before(:each) do
        stub_request(
          :post,
          'https://www.example.com/k/v1/path'
        )
          .with(
            headers: { 'X-Cybozu-API-Token' => 'token-api', 'Content-Type' => 'application/json' },
            body: '{"p1":"abc","p2":"def"}'
          )
          .to_return(
            body: '{"abc":"def"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      subject { target.post(path, body) }
      let(:path) { '/k/v1/path' }
      let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { is_expected.to eq 'abc' => 'def' }
    end

    describe '#put' do
      before(:each) do
        stub_request(
          :put,
          'https://www.example.com/k/v1/path'
        )
          .with(
            headers: { 'X-Cybozu-API-Token' => 'token-api', 'Content-Type' => 'application/json' },
            body: '{"p1":"abc","p2":"def"}'
          )
          .to_return(
            body: '{"abc":"def"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      subject { target.put(path, body) }
      let(:path) { '/k/v1/path' }
      let(:body) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { is_expected.to eq 'abc' => 'def' }
    end

    describe '#delete' do
      before(:each) do
        stub_request(
          :delete,
          'https://www.example.com/k/v1/path'
        )
          .with(
            body: { 'p1' => 'abc', 'p2' => 'def' }.to_json,
            headers: { 'X-Cybozu-API-Token' => 'token-api' }
          )
          .to_return(
            body: '{"abc":"def"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end

      subject { target.delete(path, params) }
      let(:path) { '/k/v1/path' }
      let(:params) { { 'p1' => 'abc', 'p2' => 'def' } }

      it { is_expected.to eq 'abc' => 'def' }
    end

    describe '#post_file' do
      before(:each) do
        stub_request(
          :post,
          'https://www.example.com/k/v1/path'
        )
          .with(headers: { 'X-Cybozu-API-Token' => 'token-api' })
          .to_return(
            body: '{"fileKey":"abc"}',
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )

        expect(Faraday::UploadIO).to receive(:new).with(path, content_type, original_filename).and_return(attachment) # rubocop:disable Metrics/LineLength
      end

      subject { target.post_file(url, path, content_type, original_filename) }
      let(:attachment) { double('attachment') }
      let(:url) { '/k/v1/path' }
      let(:path) { '/path/to/file.txt' }
      let(:content_type) { 'text/plain' }
      let(:original_filename) { 'fileName.txt' }

      it { is_expected.to eq 'abc' }
    end
  end
end

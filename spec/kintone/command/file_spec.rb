require 'spec_helper'
require 'kintone/command/file'
require 'kintone/api'

describe Kintone::Command::File do
  let(:target) { Kintone::Command::File.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/file.json?fileKey=file-key-string'
      )
        .to_return(body: attachment, status: 200, headers: { 'Content-type' => 'image/gif' })
    end

    subject { target.get(fileKey) }

    let(:attachment) { Base64.decode64('data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==') } # rubocop:disable Metrics/LineLength
    let(:fileKey) { 'file-key-string' }

    it { expect(subject).to eq attachment }

    context 'fail to request' do
      before(:each) do
        stub_request(
          :get,
          'https://example.cybozu.com/k/v1/file.json?fileKey=file-key-string'
        )
          .to_return(
            body: '{"message":"不正なJSON文字列です。","id":"1505999166-897850006","code":"CB_IJ01"}',
            status: 500,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it { expect { subject }.to raise_error Kintone::KintoneError }
    end
  end

  describe '#register' do
    before(:each) do
      expect(api)
        .to receive(:post_file)
        .with(target.instance_variable_get('@url'), path, content_type, original_filename)
        .and_return('c15b3870-7505-4ab6-9d8d-b9bdbc74f5d6')
    end

    subject { target.register(path, content_type, original_filename) }

    let(:path) { '/path/to/file.txt' }
    let(:content_type) { 'text/plain' }
    let(:original_filename) { 'fileName.txt' }

    it { is_expected.to eq 'c15b3870-7505-4ab6-9d8d-b9bdbc74f5d6' }

    xcontext 'fail to request' do
      # Should consider how to test
    end
  end
end

require 'spec_helper'
require 'kintone/command/preview_form'
require 'kintone/api'

describe Kintone::Command::PreviewForm do
  let(:target) { Kintone::Command::PreviewForm.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://example.cybozu.com/k/v1/preview/form.json'
      )
        .with(body: request_body.to_json)
        .to_return(
          body: '{"result":"ok"}',
          status: 200,
          headers: { 'Content-type' => 'application/json' }
        )
    end

    subject { target.get(app) }

    let(:app) { 1 }
    let(:request_body) { { app: app } }

    it { expect(subject).to eq 'result' => 'ok' }
  end
end

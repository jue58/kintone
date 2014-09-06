require 'spec_helper'
require 'kintone/command/record'
require 'kintone/api'

describe Kintone::Command::Record do
  let(:target) { Kintone::Command::Record.new(api) }
  let(:api) { Kintone::Api.new('www.example.com', 'Administrator', 'cybozu') }

  describe '#get' do
    subject { target.get(app, id) }

    context '引数が整数型の時' do
      before(:each) do
        stub_request(
          :get,
          'https://www.example.com/k/v1/record.json?app=8&id=100'
        )
          .to_return(body: "{\"result\":\"ok\"}", status: 200)
      end

      let(:app) { 8 }
      let(:id) { 100 }

      it { expect(subject).to eq 'result' => 'ok' }
    end

    context '引数が数字の文字列の時' do
      before(:each) do
        stub_request(
          :get,
          'https://www.example.com/k/v1/record.json?app=8&id=100'
        )
          .to_return(body: "{\"result\":\"ok\"}", status: 200)
      end

      let(:app) { '8' }
      let(:id) { '100' }

      it { expect(subject).to eq 'result' => 'ok' }
    end
  end

  describe '#create' do
    before(:each) do
      stub_request(
        :post,
        'https://www.example.com/k/v1/record.json'
      )
        .with(body: { 'app' => 7, 'record' => hash_record }.to_json)
        .to_return(body: "{\"id\":\"100\"}", status: 200)
    end

    subject { target.create(app, record) }

    let(:app) { 7 }
    let(:record) { hash_record }

    def hash_record
      {
        'number' => { 'value' => '123456' },
        'rich_editor' => { 'value' => 'testtest' },
        'user_select' => { 'value' => [{ 'code' => 'sato' }] }
      }
    end

    it { expect(subject).to eq 'id' => '100' }
  end

  describe '#update' do
    def hash_record
      {
        'string_multi' => { 'value' => 'character string is changed' }
      }
    end

    before(:each) do
      stub_request(
        :put,
        'https://www.example.com/k/v1/record.json'
      )
        .with(body: { 'app' => 4, 'id' => 1, 'record' => hash_record }.to_json)
        .to_return(body: '{}', status: 200)
    end

    subject { target.update(app, id, record) }

    let(:app) { 4 }
    let(:id) { 1 }
    let(:record) { hash_record }

    it { expect(subject).to eq({}) }
  end
end

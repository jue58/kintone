require 'spec_helper'
require 'kintone/command/record'
require 'kintone/api'
require 'kintone/type/record'

describe Kintone::Command::Record do
  let(:target) { Kintone::Command::Record.new(api) }
  let(:api) { Kintone::Api.new('www.example.com', 'Administrator', 'cybozu') }

  describe '#get' do
    before(:each) do
      stub_request(
        :get,
        'https://www.example.com/k/v1/record.json?app=8&id=100'
      )
        .to_return(body: "{\"result\":\"ok\"}", status: 200)
    end

    subject { target.get(app, id) }

    where(:app, :id) do
      [
        [8, 100],
        ['8', '100']
      ]
    end

    with_them do
      it { expect(subject).to eq 'result' => 'ok' }
    end
  end

  describe '#register' do
    before(:each) do
      stub_request(
        :post,
        'https://www.example.com/k/v1/record.json'
      )
        .with(body: { 'app' => 7, 'record' => hash_record }.to_json)
        .to_return(body: "{\"id\":\"100\"}", status: 200)
    end

    subject { target.register(app, record) }

    let(:app) { 7 }

    def hash_record
      {
        'number' => { 'value' => '123456' },
        'rich_editor' => { 'value' => 'testtest' },
        'user_select' => { 'value' => [{ 'code' => 'sato' }] }
      }
    end

    def record_record
      Kintone::Type::Record.new(
        number: '123456',
        rich_editor: 'testtest',
        user_select: [{ 'code' => 'sato' }]
      )
    end

    where(:record, :result) do
      [
        [hash_record, { 'id' => '100' }],
        [record_record, { 'id' => '100' }]
      ]
    end

    with_them do
      it { expect(subject).to eq result }
    end
  end

  describe '#update' do
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

    def hash_record
      {
        'string_multi' => { 'value' => 'character string is changed' }
      }
    end

    def record_record
      Kintone::Type::Record.new(string_multi: 'character string is changed')
    end

    where(:record, :result) do
      [
        [hash_record, {}],
        [record_record, {}]
      ]
    end

    with_them do
      it { expect(subject).to match result }
    end
  end
end

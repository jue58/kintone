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
        .with(body: request_body.to_json)
        .to_return(body: response_body.to_json, status: 200)
    end

    subject { target.register(app, record) }

    let(:app) { 7 }
    let(:request_body) do
      {
        'app' => 7,
        'record' => {
          'number' => { 'value' => '123456' },
          'rich_editor' => { 'value' => 'testtest' },
          'user_select' => { 'value' => [{ 'code' => 'sato' }] }
        }
      }
    end
    let(:response_body) { { 'id' => '100', 'revision' => '1' } }

    context 'use hash' do
      let(:record) do
        {
          'number' => { 'value' => '123456' },
          'rich_editor' => { 'value' => 'testtest' },
          'user_select' => { 'value' => [{ 'code' => 'sato' }] }
        }
      end

      it { expect(subject).to eq response_body }
    end

    context 'use record' do
      let(:record) do
        Kintone::Type::Record.new(
          number: '123456',
          rich_editor: 'testtest',
          user_select: [{ 'code' => 'sato' }]
        )
      end

      it { expect(subject).to eq response_body }
    end
  end

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://www.example.com/k/v1/record.json'
      )
        .with(body: request_body.to_json)
        .to_return(body: response_body.to_json, status: 200)
    end

    subject { target.update(app, id, record) }

    let(:app) { 4 }
    let(:id) { 1 }
    let(:hash_record) { { 'string_multi' => { 'value' => 'character string is changed' } } }
    let(:record_record) { Kintone::Type::Record.new(string_multi: 'character string is changed') }
    let(:response_body) { { revision: '2' } }

    context 'without revision' do
      let(:request_body) { { 'app' => 4, 'id' => 1, 'record' => hash_record } }

      context 'use hash' do
        let(:record) { hash_record }

        it { expect(subject).to match 'revision' => '2' }
      end

      context 'use record' do
        let(:record) { record_record }

        it { expect(subject).to match 'revision' => '2' }
      end
    end

    context 'with revision' do
      subject { target.update(app, id, record, revision: revision) }

      let(:revision) { 1 }
      let(:request_body) { { 'app' => 4, 'id' => 1, 'record' => hash_record, 'revision' => 1 } }

      context 'use hash' do
        let(:record) { hash_record }

        it { expect(subject).to match 'revision' => '2' }
      end

      context 'use record' do
        let(:record) { record_record }

        it { expect(subject).to match 'revision' => '2' }
      end
    end
  end
end

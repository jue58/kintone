require 'spec_helper'
require 'kintone/command/space_thread'
require 'kintone/api'

describe Kintone::Command::SpaceThread do
  let(:target) { Kintone::Command::SpaceThread.new(api) }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#update' do
    before(:each) do
      stub_request(
        :put,
        'https://example.cybozu.com/k/v1/space/thread.json'
      )
        .with(body: request_body)
        .to_return(body: '{}', status: 200,
                   headers: { 'Content-type' => 'application/json' })
    end

    subject { target.update(id, name: name, body: body) }

    let(:id) { 1 }

    where(:name, :body, :request_body) do
      [
        [
          'example thread',
          '<b>awesome thread!</b>',
          '{"id":1,"name":"example thread","body":"<b>awesome thread!</b>"}'
        ],
        [
          nil,
          '<b>awesome thread!</b>',
          '{"id":1,"body":"<b>awesome thread!</b>"}'
        ],
        [
          'example thread',
          nil,
          '{"id":1,"name":"example thread"}'
        ],
        [
          nil,
          nil,
          '{"id":1}'
        ]
      ]
    end

    with_them do
      it { expect(subject).to be_truthy }
    end
  end
end

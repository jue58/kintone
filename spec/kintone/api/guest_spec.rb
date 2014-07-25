require 'spec_helper'
require 'kintone/api/guest'
require 'kintone/api'

describe Kintone::Api::Guest do
  let(:target) { Kintone::Api::Guest.new(space, api) }
  let(:space) { 1 }
  let(:api) { Kintone::Api.new('example.cybozu.com', 'Administrator', 'cybozu') }

  describe '#get_url' do
    subject { target.get_url(command) }
    context '' do
      let(:command) { 'path' }

      it { expect(subject).to eq('/k/guest/1/v1/path.json') }
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
end

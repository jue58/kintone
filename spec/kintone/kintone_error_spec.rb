require 'spec_helper'
require 'kintone/kintone_error'

describe Kintone::KintoneError do
  let(:target) { Kintone::KintoneError.new(messages, http_status) }

  describe '#message' do
    subject { target.message }

    let(:messages) do
      {
        'message' => '不正なJSON文字列です。',
        'id' => '1505999166-897850006',
        'code' => 'CB_IJ01'
      }
    end

    let(:http_status) { 500 }

    it { is_expected.to eq '500 [CB_IJ01] 不正なJSON文字列です。(1505999166-897850006)' }
  end
end

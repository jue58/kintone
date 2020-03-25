require 'spec_helper'
require 'kintone/kintone_error'

describe Kintone::KintoneError do
  let(:target) { Kintone::KintoneError.new(messages, http_status) }

  describe '#message' do
    subject { target.message }

    context '不正なJSONの場合' do
      let(:messages) do
        {
          'message' => '不正なJSON文字列です。',
          'id' => '1505999166-897850006',
          'code' => 'CB_IJ01'
        }
      end

      let(:http_status) { 500 }

      it { is_expected.to eq '500 [CB_IJ01] 不正なJSON文字列です。(1505999166-897850006)' }

      describe '#message_text' do
        subject { target.message_text }
        it { is_expected.to eq '不正なJSON文字列です。' }
      end

      describe '#id' do
        subject { target.id }
        it { is_expected.to eq '1505999166-897850006' }
      end

      describe '#code' do
        subject { target.code }
        it { is_expected.to eq 'CB_IJ01' }
      end

      describe '#http_status' do
        subject { target.http_status }
        it { is_expected.to eq 500 }
      end

      describe '#errors' do
        subject { target.errors }
        it { is_expected.to be_nil }
      end
    end

    context 'Validation Errorの場合' do
      let(:messages) do
        {
          'message' => '入力内容が正しくありません。',
          'id' => '1505999166-836316825',
          'code' => 'CB_VA01',
          'errors' => {
            'record.field_code.value' => {
              'messages' => ['必須です。']
            }
          }
        }
      end

      let(:http_status) { 400 }

      it { is_expected.to eq '400 [CB_VA01] 入力内容が正しくありません。(1505999166-836316825)' }

      describe '#message_text' do
        subject { target.message_text }
        it { is_expected.to eq '入力内容が正しくありません。' }
      end

      describe '#id' do
        subject { target.id }
        it { is_expected.to eq '1505999166-836316825' }
      end

      describe '#code' do
        subject { target.code }
        it { is_expected.to eq 'CB_VA01' }
      end

      describe '#http_status' do
        subject { target.http_status }
        it { is_expected.to eq 400 }
      end

      describe '#errors' do
        subject { target.errors['record.field_code.value']['messages'].first }
        it { is_expected.to eq '必須です。' }
      end
    end

    context 'bulk requestでValidation Errorが発生した場合' do
      let(:messages) do
        {
          'results' =>
            [
              {
                "code" => "CB_VA01",
                "id" => "49ZYc7Nv0dbvJ7N4lVEu",
                "message" => "入力内容が正しくありません。",
                "errors" => {
                  "record.取消"=> {
                    "messages"=>["必須です。"]
                  }
                }
              },
              {}
            ]
          }
      end

      let(:http_status) { 400 }

      it { is_expected.to eq '400 [CB_VA01] 入力内容が正しくありません。(49ZYc7Nv0dbvJ7N4lVEu)' }

      describe '#message_text' do
        subject { target.message_text }
        it { is_expected.to eq '入力内容が正しくありません。' }
      end

      describe '#id' do
        subject { target.id }
        it { is_expected.to eq '49ZYc7Nv0dbvJ7N4lVEu' }
      end

      describe '#code' do
        subject { target.code }
        it { is_expected.to eq 'CB_VA01' }
      end

      describe '#http_status' do
        subject { target.http_status }
        it { is_expected.to eq 400 }
      end

      describe '#errors' do
        subject { target.errors['record.取消']['messages'].first }
        it { is_expected.to eq '必須です。' }
      end
    end
  end
end

require 'spec_helper'
require 'kintone/type/record'

describe Kintone::Type::Record do
  let(:target) { Kintone::Type::Record.new }

  describe '#to_kitnone' do
    subject { target.to_kintone }

    context 'データが登録されているとき' do
      before(:each) do
        target[:a] = 1
        target[:b] = 2
      end

      it { expect(subject).to match a: { value: 1 }, b: { value: 2 } }
    end

    context 'データが登録されてないとき' do
      it { expect(subject).to be_empty }
    end

    context 'initializeで初期値を指定したとき' do
      let(:target) { Kintone::Type::Record.new(default) }

      where(:default, :result) do
        [
          [{ a: 1, b: 2 }, { a: { value: 1 }, b: { value: 2 } }],
          [[[:a, 1], [:b, 2]], {}]
        ]
      end

      with_them do
        it { expect(subject).to match result }
      end
    end
  end
end

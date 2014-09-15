require 'spec_helper'
require 'kintone/query'

describe Kintone::Query do
  describe '#to_s' do
    subject { target.to_s }

    context '==' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text) == '"Hello, world."' }, 'text = "Hello, world."'],
          [Kintone::Query.new { field(:text) == 'Hello, world.' }, 'text = "Hello, world."'],
          [Kintone::Query.new { field('作成日時') == now }, '作成日時 = NOW()'],
          [Kintone::Query.new { field('作成日時') == today }, '作成日時 = TODAY()'],
          [Kintone::Query.new { field('作成日時') == this_month }, '作成日時 = THIS_MONTH()'],
          [Kintone::Query.new { field('作成日時') == last_month }, '作成日時 = LAST_MONTH()'],
          [Kintone::Query.new { field('作成日時') == this_year }, '作成日時 = THIS_YEAR()'],
          [Kintone::Query.new { field(:number) == 100 }, 'number = 100']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context '!=' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text) != '"Hello, world."' }, 'text != "Hello, world."'],
          [Kintone::Query.new { field(:text) != 'Hello, world.' }, 'text != "Hello, world."'],
          [Kintone::Query.new { field('作成日時') != now }, '作成日時 != NOW()'],
          [Kintone::Query.new { field('作成日時') != today }, '作成日時 != TODAY()'],
          [Kintone::Query.new { field('作成日時') != this_month }, '作成日時 != THIS_MONTH()'],
          [Kintone::Query.new { field('作成日時') != last_month }, '作成日時 != LAST_MONTH()'],
          [Kintone::Query.new { field('作成日時') != this_year }, '作成日時 != THIS_YEAR()'],
          [Kintone::Query.new { field(:number) != 100 }, 'number != 100']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context '>' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text) > '"Hello, world."' }, 'text > "Hello, world."'],
          [Kintone::Query.new { field(:text) > 'Hello, world.' }, 'text > "Hello, world."'],
          [Kintone::Query.new { field('作成日時') > now }, '作成日時 > NOW()'],
          [Kintone::Query.new { field('作成日時') > today }, '作成日時 > TODAY()'],
          [Kintone::Query.new { field('作成日時') > this_month }, '作成日時 > THIS_MONTH()'],
          [Kintone::Query.new { field('作成日時') > last_month }, '作成日時 > LAST_MONTH()'],
          [Kintone::Query.new { field('作成日時') > this_year }, '作成日時 > THIS_YEAR()'],
          [Kintone::Query.new { field(:number) > 100 }, 'number > 100']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context '<' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text) < '"Hello, world."' }, 'text < "Hello, world."'],
          [Kintone::Query.new { field(:text) < 'Hello, world.' }, 'text < "Hello, world."'],
          [Kintone::Query.new { field('作成日時') < now }, '作成日時 < NOW()'],
          [Kintone::Query.new { field('作成日時') < today }, '作成日時 < TODAY()'],
          [Kintone::Query.new { field('作成日時') < this_month }, '作成日時 < THIS_MONTH()'],
          [Kintone::Query.new { field('作成日時') < last_month }, '作成日時 < LAST_MONTH()'],
          [Kintone::Query.new { field('作成日時') < this_year }, '作成日時 < THIS_YEAR()'],
          [Kintone::Query.new { field(:number) < 100 }, 'number < 100']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context '>=' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text) >= '"Hello, world."' }, 'text >= "Hello, world."'],
          [Kintone::Query.new { field(:text) >= 'Hello, world.' }, 'text >= "Hello, world."'],
          [Kintone::Query.new { field('作成日時') >= now }, '作成日時 >= NOW()'],
          [Kintone::Query.new { field('作成日時') >= today }, '作成日時 >= TODAY()'],
          [Kintone::Query.new { field('作成日時') >= this_month }, '作成日時 >= THIS_MONTH()'],
          [Kintone::Query.new { field('作成日時') >= last_month }, '作成日時 >= LAST_MONTH()'],
          [Kintone::Query.new { field('作成日時') >= this_year }, '作成日時 >= THIS_YEAR()'],
          [Kintone::Query.new { field(:number) >= 100 }, 'number >= 100']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context '<=' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text) <= '"Hello, world."' }, 'text <= "Hello, world."'],
          [Kintone::Query.new { field(:text) <= 'Hello, world.' }, 'text <= "Hello, world."'],
          [Kintone::Query.new { field('作成日時') <= now }, '作成日時 <= NOW()'],
          [Kintone::Query.new { field('作成日時') <= today }, '作成日時 <= TODAY()'],
          [Kintone::Query.new { field('作成日時') <= this_month }, '作成日時 <= THIS_MONTH()'],
          [Kintone::Query.new { field('作成日時') <= last_month }, '作成日時 <= LAST_MONTH()'],
          [Kintone::Query.new { field('作成日時') <= this_year }, '作成日時 <= THIS_YEAR()'],
          [Kintone::Query.new { field(:number) <= 100 }, 'number <= 100']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context 'in' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:dropdown).in(['"A"', '"B"']) }, 'dropdown in ("A", "B")'],
          [Kintone::Query.new { field(:dropdown).in(%w(A B)) }, 'dropdown in ("A", "B")'],
          [Kintone::Query.new { field(:dropdown).in([:A, :B]) }, 'dropdown in ("A", "B")'],
          [Kintone::Query.new { field(:dropdown).in([100, 200]) }, 'dropdown in (100, 200)'],
          [Kintone::Query.new { field('作成者').in([login_user]) }, '作成者 in (LOGINUSER())']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context 'not in' do
      where(:target, :result) do
        [
          [
            Kintone::Query.new { field(:dropdown).not_in(['"A"', '"B"']) },
            'dropdown not in ("A", "B")'
          ],
          [
            Kintone::Query.new { field(:dropdown).not_in(%w(A B)) },
            'dropdown not in ("A", "B")'
          ],
          [
            Kintone::Query.new { field(:dropdown).not_in([:A, :B]) },
            'dropdown not in ("A", "B")'
          ],
          [
            Kintone::Query.new { field(:dropdown).not_in([100, 200]) },
            'dropdown not in (100, 200)'
          ],
          [
            Kintone::Query.new { field('作成者').not_in([login_user]) },
            '作成者 not in (LOGINUSER())'
          ]
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context 'like' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text).like('Hello') }, 'text like "Hello"'],
          [Kintone::Query.new { field(:text).like('"Hello"') }, 'text like "Hello"'],
          [Kintone::Query.new { field(:text).like(:Hello) }, 'text like "Hello"']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context 'not like' do
      where(:target, :result) do
        [
          [Kintone::Query.new { field(:text).not_like('Hello') }, 'text not like "Hello"'],
          [Kintone::Query.new { field(:text).not_like('"Hello"') }, 'text not like "Hello"'],
          [Kintone::Query.new { field(:text).not_like(:Hello) }, 'text not like "Hello"']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context 'and!' do
      let(:target) do
        Kintone::Query.new do
          field(:text).like 'Hello'
          and!
          field(:number) > 100
        end
      end

      def result
        'text like "Hello" and number > 100'
      end

      it { expect(subject).to eq result }
    end

    context 'or!' do
      let(:target) do
        Kintone::Query.new do
          field(:text).like 'Hello'
          or!
          field(:number) > 100
        end
      end

      def result
        'text like "Hello" or number > 100'
      end

      it { expect(subject).to eq result }
    end

    context 'precede' do
      let(:target) do
        Kintone::Query.new do
          precede do
            field(:text).like 'Hello'
            or!
            field(:number) > 100
          end
          and!
          precede do
            field(:text2).not_like 'Hello'
            and!
            field(:number2) <= 100
          end
        end
      end

      def result
        '(text like "Hello" or number > 100) and (text2 not like "Hello" and number2 <= 100)'
      end

      it { expect(subject).to eq result }
    end

    context 'order by' do
      where(:target, :result) do
        [
          [Kintone::Query.new { order_by(:record_id, :asc) }, 'order by record_id asc'],
          [Kintone::Query.new { order_by(:record_id, :desc) }, 'order by record_id desc'],
          [Kintone::Query.new { order_by(:record_id) }, 'order by record_id asc'],
          [Kintone::Query.new { order_by('作成日時', :desc) }, 'order by 作成日時 desc']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context 'limit' do
      where(:target, :result) do
        [
          [Kintone::Query.new { limit(20) }, 'limit 20'],
          [Kintone::Query.new { limit('20') }, 'limit 20']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end

    context 'offset' do
      where(:target, :result) do
        [
          [Kintone::Query.new { offset(30) }, 'offset 30'],
          [Kintone::Query.new { offset('30') }, 'offset 30']
        ]
      end

      with_them do
        it { expect(subject).to eq result }
      end
    end
  end
end

require 'kintone/query/extension'

class Kintone::Query
  def initialize(&block)
    @query = []
    instance_eval(&block) if block_given?
  end

  def field(code)
    condition = Field.new(code)
    @query << condition
    condition
  end

  def and!
    @query << 'and'
  end

  def or!
    @query << 'or'
  end

  def precede(&block)
    @query << "(#{Kintone::Query.new(&block)})" if block_given?
  end

  def login_user
    function_string('LOGINUSER()')
  end

  def now
    function_string('NOW()')
  end

  def today
    function_string('TODAY()')
  end

  def this_month
    function_string('THIS_MONTH()')
  end

  def last_month
    function_string('LAST_MONTH()')
  end

  def this_year
    function_string('THIS_YEAR()')
  end

  def order_by(field, sort = :asc)
    @query << "order by #{field} #{sort}"
  end

  def limit(count)
    @query << "limit #{count}"
  end

  def offset(index)
    @query << "offset #{index}"
  end

  def to_s
    @query.map(&:to_s).join(' ')
  end

  def inspect
    to_s
  end

  alias f field

  private

  def function_string(function)
    function.instance_eval do
      class << self
        define_method :query_format, proc { self }
      end
    end
    function
  end

  class Field
    using Kintone::Query::Extention

    def initialize(code)
      @code = code.to_s
    end

    def ==(other)
      save('=', other.query_format)
    end

    def !=(other)
      save('!=', other.query_format)
    end

    def >(other)
      save('>', other.query_format)
    end

    def <(other)
      save('<', other.query_format)
    end

    def >=(other)
      save('>=', other.query_format)
    end

    def <=(other)
      save('<=', other.query_format)
    end

    def in(other)
      other = "(#{other.map { |v| v.query_format }.join(', ')})" if other.is_a?(Array)
      save('in', other)
    end

    def not_in(other)
      other = "(#{other.map { |v| v.query_format }.join(', ')})" if other.is_a?(Array)
      save('not in', other)
    end

    def like(other)
      save('like', other.query_format)
    end

    def not_like(other)
      save('not like', other.query_format)
    end

    def to_s
      "#{@code} #{@condition} #{@other}"
    end

    def inspect
      to_s
    end

    private

    def save(condition, other)
      @condition ||= condition
      @other ||= other
    end
  end
end

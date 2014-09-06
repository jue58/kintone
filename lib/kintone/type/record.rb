module Kintone::Type
  class Record < Hash
    def initialize(default = nil)
      default.each { |k, v| store(k, v) } if default.is_a?(Hash)
    end

    def to_kintone
      map { |k, v| [k, { value: v }] }.to_h
    end
  end
end

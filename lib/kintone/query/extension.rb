class Kintone::Query
  module Extention
    refine Object do
      def query_format
        self
      end
    end

    refine Symbol do
      def query_format
        "\"#{self}\""
      end
    end

    refine String do
      def query_format
        if self =~ /\A".+"\z/ then self
        else "\"#{self}\""
        end
      end
    end
  end
end

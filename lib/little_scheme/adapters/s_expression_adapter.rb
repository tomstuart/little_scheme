require 'atom'
require 'delegate'
require 'list'

module LittleScheme
  module Adapters
    class SExpressionAdapter < SimpleDelegator
      def atom?
        __getobj__.is_a?(Atom)
      end

      def list?
        __getobj__.is_a?(List)
      end

      def s_expression?
        true
      end

      def ==(other)
        super other.__getobj__
      end

      def s_expressions
        __getobj__.send(:array).map(&self.class.method(:new))
      end
    end
  end
end

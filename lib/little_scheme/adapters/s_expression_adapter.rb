require 'delegate'
require 'evaluator'
require 'list'

module LittleScheme
  module Adapters
    class SExpressionAdapter < SimpleDelegator
      def atom?
        __getobj__.atom?
      end

      def list?
        __getobj__.is_a?(List)
      end

      def is_a?(klass)
        __getobj__.is_a?(klass)
      end

      def evaluate(environment)
        evaluator = ::Evaluator.new
        result = evaluator.evaluate(__getobj__, environment)
        self.class.new(result)
      end
    end
  end
end

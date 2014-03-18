require 'delegate'
require 'evaluator'

module LittleScheme
  module Adapters
    class SExpressionAdapter < SimpleDelegator
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

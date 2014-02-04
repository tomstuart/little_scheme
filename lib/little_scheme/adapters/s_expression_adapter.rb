require 'atom'
require 'delegate'
require 'evaluator'
require 'list'
require 'little_scheme/adapters/environment_adapter'

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

      def evaluate(environment)
        environment = EnvironmentAdapter.new(environment)
        result = Evaluator.new(__getobj__).evaluate(environment)
        self.class.new(result)
      end
    end
  end
end

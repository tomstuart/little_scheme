require 'little_scheme/adapters/s_expression_adapter'

module LittleScheme
  module Adapters
    class ProgramAdapter < Struct.new(:s_expressions)
      def initialize(s_expressions)
        super s_expressions.map(&SExpressionAdapter.method(:new))
      end

      def evaluate(environment)
        s_expressions.first.evaluate(environment)
      end
    end
  end
end

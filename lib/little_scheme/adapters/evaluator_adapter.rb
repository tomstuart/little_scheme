module LittleScheme
  module Adapters
    class EvaluatorAdapter
      def evaluate(program, environment)
        program.evaluate(environment)
      end
    end
  end
end

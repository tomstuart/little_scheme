require 'little_scheme/evaluator'

module EvaluateHelper
  def evaluate_s_expression(s_expression, environment)
    LittleScheme::Evaluator.new.evaluate(s_expression, environment)
  end
end

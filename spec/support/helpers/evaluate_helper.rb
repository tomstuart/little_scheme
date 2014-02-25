require 'little_scheme/evaluator'

module EvaluateHelper
  def evaluate_program(program, environment)
    LittleScheme::Evaluator.new.evaluate(program, environment)
  end

  def evaluate_s_expression(s_expression, environment)
    evaluate_program(s_expression, environment)
  end
end

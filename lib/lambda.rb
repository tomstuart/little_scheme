class Lambda
  attr_reader :parameter_name, :expression

  def initialize(parameter_name, expression)
    @parameter_name = parameter_name
    @expression = expression
  end

  def evaluate(env, argument)
    local_env = env.merge(parameter_name.symbol => argument.evaluate(env))
    expression.evaluate(local_env)
  end
end

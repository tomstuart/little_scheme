class Lambda
  attr_reader :parameter, :expression

  def initialize(parameter, expression)
    @parameter = parameter
    @expression = expression
  end

  def evaluate(env, argument)
    local_env = env.merge(parameter.symbol => argument.evaluate(env))
    expression.evaluate(local_env)
  end
end

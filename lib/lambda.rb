class Lambda
  attr_reader :parameters, :expression

  def initialize(parameters, expression)
    @parameters = parameters
    @expression = expression
  end

  def evaluate(env, arguments)
    key_value_pairs = parameters.zip(arguments).map { |parameter, argument| [parameter.symbol, argument.evaluate(env)] }
    extra_env = Hash[key_value_pairs]
    local_env = env.merge(extra_env)
    expression.evaluate(local_env)
  end
end

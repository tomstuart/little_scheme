class Lambda
  attr_reader :parameters, :expression

  def initialize(parameters, expression)
    @parameters = parameters
    @expression = expression
  end

  def apply(env, arguments)
    key_value_pairs = parameters.zip(arguments).map { |parameter, argument| [parameter.symbol, argument.evaluate(env)] }
    arguments_env = Hash[key_value_pairs]
    local_env = env.merge(arguments_env)
    expression.evaluate(local_env)
  end
end

class Evaluator
  class Quote
    def evaluate(env, arguments)
      arguments.first
    end
  end

  def evaluate(program, env={})
    env_with_primitives = env.merge \
      quote: Quote.new

    program.evaluate(env_with_primitives)
  end
end

class Evaluator
  class Lambda
    def evaluate(env, arguments)
      parameters = arguments.first.array
      expression = arguments.last

      ::Lambda.new(parameters, expression)
    end
  end

  class Quote
    def evaluate(env, arguments)
      arguments.first
    end
  end

  class Cond
    def evaluate(env, arguments)
      arguments.detect { |list| list.car.evaluate(env) == Atom::TRUE }.cdr.car.evaluate(env)
    end
  end

  class Or
    def evaluate(env, arguments)
      arguments.first.evaluate(env) == Atom::TRUE ? Atom::TRUE : arguments.last.evaluate(env)
    end
  end

  def evaluate(program, env={})
    env_with_primitives = env.merge lambda: Lambda.new, quote: Quote.new, cond: Cond.new, or: Or.new

    program.evaluate(env_with_primitives)
  end
end

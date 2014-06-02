class Evaluator
  class Keyword
    def initialize(&block)
      @block = block
    end

    def apply(env, arguments)
      @block.call(env, arguments)
    end
  end

  class Primitive
    def initialize(operation)
      @operation = operation
    end

    def apply(env, arguments)
      first_argument, *other_arguments = arguments.map { |a| a.evaluate(env) }
      first_argument.send(@operation, *other_arguments)
    end
  end

  KEYWORDS = {
    lambda: Keyword.new { |env, arguments|
      parameters = arguments.first.array
      expression = arguments.last

      Lambda.new(parameters, expression)
    },
    quote: Keyword.new { |env, arguments|
      arguments.first
    },
    cond: Keyword.new { |env, arguments|
      arguments.detect { |list| list.car == Atom.new(:else) || list.car.evaluate(env) == Atom::TRUE }.cdr.car.evaluate(env)
    },
    or: Keyword.new { |env, arguments|
      arguments.first.evaluate(env) == Atom::TRUE ? Atom::TRUE : arguments.last.evaluate(env)
    }
  }

  PRIMITIVES = {
    car: Primitive.new(:car),
    cdr: Primitive.new(:cdr),
    cons: Primitive.new(:cons),
    null?: Primitive.new(:null?),
    atom?: Primitive.new(:atom?),
    eq?: Primitive.new(:eq?),
    zero?: Primitive.new(:zero?),
    number?: Primitive.new(:number?),
    add1: Primitive.new(:add1),
    sub1: Primitive.new(:sub1)
  }

  INITIAL_ENVIRONMENT = KEYWORDS.merge(PRIMITIVES)

  def evaluate(program, env={})
    program.evaluate(INITIAL_ENVIRONMENT.merge(env))
  end
end

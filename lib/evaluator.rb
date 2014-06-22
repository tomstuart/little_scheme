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

  class Predicate < Primitive
    def apply(env, arguments)
      value = super
      raise "Predicate #{@operation} called, but received non boolean value '#{value.inspect}'" unless [TrueClass, FalseClass].include? value.class
      Atom.from_boolean(value)
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
    },
    and: Keyword.new { |env, arguments|
      arguments.first.evaluate(env) == Atom::FALSE ? Atom::FALSE : arguments.last.evaluate(env)
    }
  }

  PRIMITIVES = {
    car: Primitive.new(:car),
    cdr: Primitive.new(:cdr),
    cons: Primitive.new(:cons),
    null?: Predicate.new(:null?),
    atom?: Predicate.new(:atom?),
    eq?: Predicate.new(:eq?),
    zero?: Predicate.new(:zero?),
    number?: Predicate.new(:number?),
    add1: Primitive.new(:add1),
    sub1: Primitive.new(:sub1)
  }

  INITIAL_ENVIRONMENT = KEYWORDS.merge(PRIMITIVES)

  def evaluate(program, env={})
    program.evaluate(INITIAL_ENVIRONMENT.merge(env))
  end
end

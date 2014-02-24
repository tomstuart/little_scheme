class Evaluator
  def initialize(program)
    @program = program
  end

  def evaluate(env={})
    case @program
    when Atom
      env[@program.symbol]
    when List
      function, argument = @program.car, @program.cdr.car

      operation = function.symbol
      case argument
      when Atom
        self.class.new(argument).evaluate(env).send(operation)
      when List
        self.class.new(argument).evaluate(env).send(operation)
      else
        raise
      end
    else
      raise
    end
  end
end

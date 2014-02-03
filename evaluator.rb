class Evaluator
  def initialize(program)
    @program = program
  end

  def evaluate(env={})
    function, argument = @program.car, @program.cdr.car

    operation = function.symbol
    case argument
    when Atom
      env[argument.symbol].send(operation)
    else
      raise
    end
  end
end

class Evaluator
  def initialize(program)
    @program = program
  end

  def evaluate(env={})
    function, argument = @program.car, @program.cdr.car

    case function.symbol
    when :car
      case argument
      when Atom
        env[argument.symbol].car
      else
        raise
      end
    when :cdr
      case argument
      when Atom
        env[argument.symbol].cdr
      else
        raise
      end
    else
      raise
    end
  end
end

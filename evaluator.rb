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
      when List
        argument.car
      end
    when :cdr
      case argument
      when Atom
        env[argument.symbol].cdr
      when List
        argument.cdr
      end
    else
      raise
    end
  end
end

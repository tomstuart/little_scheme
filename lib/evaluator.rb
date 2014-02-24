class Evaluator
  def evaluate(program, env={})
    case program
    when Atom
      env[program.symbol]
    when List
      function, argument = program.car, program.cdr.car
      first_argument = evaluate(argument, env)
      case operation = function.symbol
      when :cons
        second_argument = evaluate(program.cdr.cdr.car, env)
        first_argument.send(operation, second_argument)
      when :car, :cdr
        first_argument.send(operation)
      else
        raise
      end
    else
      raise
    end
  end
end

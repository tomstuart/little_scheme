class Evaluator
  def evaluate(program, env={})
    case program
    when Atom
      env[program.symbol]
    when List
      function, argument = program.car, program.cdr.car
      case operation = function.symbol
      when :cons
        second_argument = evaluate(program.cdr.cdr.car, env)
        evaluate(argument, env).send(operation, second_argument)
      when :car, :cdr
        evaluate(argument, env).send(operation)
      else
        raise
      end
    else
      raise
    end
  end
end

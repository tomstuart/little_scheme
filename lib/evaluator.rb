class Evaluator
  def evaluate(program, env={})
    case program
    when Atom
      env[program.symbol]
    when List
      function, arguments = program.car, program.cdr.send(:array)
      first_argument = evaluate(arguments[0], env)
      case operation = function.symbol
      when :cons
        second_argument = evaluate(arguments[1], env)
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

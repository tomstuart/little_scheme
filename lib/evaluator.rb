class Evaluator
  def evaluate(program, env={})
    case program
    when Atom
      env[program.symbol]
    when List
      function, arguments = program.car, program.cdr.send(:array)
      first_argument = evaluate(arguments[0], env)
      operation = function.symbol
      other_arguments = arguments[1..-1].map { |a| evaluate(a, env) }
      first_argument.send(operation, *other_arguments)
    else
      raise
    end
  end
end

class Evaluator
  def evaluate(program, env={})
    case program
    when Atom
      env[program.symbol]
    when List
      function, *arguments = program.send(:array)
      operation = function.symbol
      first_argument, *other_arguments = arguments.map { |a| evaluate(a, env) }
      first_argument.send(operation, *other_arguments)
    else
      raise
    end
  end
end

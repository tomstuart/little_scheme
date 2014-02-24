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
      case operation = function.symbol
      when :cons
        second_argument = self.class.new(@program.cdr.cdr.car).evaluate(env)
        self.class.new(argument).evaluate(env).send(operation, second_argument)
      when :car, :cdr
        self.class.new(argument).evaluate(env).send(operation)
      else
        raise
      end
    else
      raise
    end
  end
end

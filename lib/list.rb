require 'lambda'

class List
  def initialize(*array)
    @array = array
  end

  def evaluate(env)
    function, *arguments = array
    if function.is_a? List
      expression = function.cdr.cdr.car
      parameter = function.cdr.car.car

      Lambda.new(parameter, expression).evaluate(env, arguments.first)
    else
      operation = function.symbol
      if env.key?(operation)
        env[operation].evaluate(env, arguments.first)
      else
        case operation
        when :lambda
          Lambda.new(arguments.first.car, arguments.last)
        when :quote
          arguments.first
        when :cond
          arguments.detect { |list| list.car.evaluate(env) == Atom::TRUE }.cdr.car.evaluate(env)
        when :or
          arguments.first.evaluate(env) == Atom::TRUE ? Atom::TRUE : arguments.last.evaluate(env)
        else
          first_argument, *other_arguments = arguments.map { |a| a.evaluate(env) }
          first_argument.send(operation, *other_arguments)
        end
      end
    end
  end

  def car
    raise if @array.empty?
    @array.first
  end

  def cdr
    raise if @array.empty?
    self.class.new(*@array[1..-1])
  end

  def cons(list)
    list.prepend(self)
  end

  def prepend(sexp)
    List.new(sexp, *array)
  end

  def null?
    array.empty? ? Atom::TRUE : Atom::FALSE
  end

  def atom?
    Atom::FALSE
  end

  def ==(other)
    self.array == other.array
  end

  def inspect
    "(#{@array.map(&:inspect).join(' ')})"
  end

  attr_reader :array
end

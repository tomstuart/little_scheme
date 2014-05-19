require 'lambda'

class List
  def initialize(*array)
    @array = array
  end

  def evaluate(env)
    function, *arguments = array

    operation = function.symbol
    if env.key?(operation)
      env[operation].evaluate(env, arguments)
    else
      # Call some method on the actual Ruby representation of a value
      # e.g. evaluate (car a) by calling List#car on the object a
      first_argument, *other_arguments = arguments.map { |a| a.evaluate(env) }
      first_argument.send(operation, *other_arguments)
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
    other.is_a?(List) && self.array == other.array
  end

  def inspect
    "(#{@array.map(&:inspect).join(' ')})"
  end

  attr_reader :array
end

require 'lambda'

class List
  def initialize(*array)
    @array = array
  end

  def evaluate(env)
    operation, *arguments = array
    env.fetch(operation.symbol).apply(env, arguments)
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

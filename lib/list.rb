class List
  def initialize(*array)
    @array = array
  end

  def evaluate(env)
    function, *arguments = array
    operation = function.symbol
    first_argument, *other_arguments = arguments.map { |a| a.evaluate(env) }
    first_argument.send(operation, *other_arguments)
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
    List.new(*([sexp] + array))
  end

  def ==(other)
    self.array == other.array
  end

  def to_a
    array
  end

  def inspect
    "(#{@array.map(&:inspect).join(' ')})"
  end

  protected

  attr_reader :array
end

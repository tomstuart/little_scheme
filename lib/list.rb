class List
  def initialize(*array)
    @array = array
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

  def inspect
    "(#{@array.map(&:inspect).join(' ')})"
  end

  protected

  attr_reader :array
end

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
    List.new(*([self] + list.send(:array)))
  end

  def ==(other)
    self.array == other.array
  end

  protected

  attr_reader :array
end

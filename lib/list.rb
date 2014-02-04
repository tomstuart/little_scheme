class List
  def initialize(*array)
    @array = array
  end

  def car
    @array.first
  end

  def cdr
    self.class.new(*@array[1..-1])
  end

  def ==(other)
    self.array == other.array
  end

  protected

  attr_reader :array
end

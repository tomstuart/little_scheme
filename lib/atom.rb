class Atom
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def cons(list)
    List.new(*([self] + list.send(:array)))
  end

  def ==(other)
    self.symbol == other.symbol
  end
end

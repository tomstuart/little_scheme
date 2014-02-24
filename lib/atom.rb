class Atom
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def cons(list)
    list.prepend(self)
  end

  def ==(other)
    self.symbol == other.symbol
  end

  def inspect
    symbol.to_s
  end
end

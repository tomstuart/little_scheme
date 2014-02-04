class Atom
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def ==(other)
    self.symbol == other.symbol
  end
end

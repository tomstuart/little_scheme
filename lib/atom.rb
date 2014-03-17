class Atom
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  TRUE = new(:'#t').freeze
  FALSE = new(:'#f').freeze

  def evaluate(env)
    env[symbol]
  end

  def atom?
    TRUE
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

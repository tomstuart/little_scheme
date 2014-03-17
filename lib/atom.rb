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

  def eq?(other)
    raise if self.symbol =~ /^\d+$/
    raise if other.symbol =~ /^\d+$/

    self == other ? TRUE : FALSE
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

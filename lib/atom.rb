class Atom
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  TRUE = new(:'#t').freeze
  FALSE = new(:'#f').freeze

  def evaluate(env)
    if self == TRUE || self == FALSE
      self
    else
      env[symbol]
    end
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
    other.is_a?(Atom) && self.symbol == other.symbol
  end

  def inspect
    symbol.to_s
  end

  def add1
    Atom.new((symbol.to_s.to_i + 1).to_s.to_sym)
  end
end

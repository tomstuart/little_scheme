class Atom
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol.to_sym
  end

  TRUE = new(:'#t').freeze
  FALSE = new(:'#f').freeze

  def self.from_boolean(boolean)
    boolean ? TRUE : FALSE
  end

  def evaluate(env)
    if self == TRUE || self == FALSE
      self
    elsif number?
      self
    else
      env.fetch(symbol)
    end
  end

  def atom?
    true
  end

  def number?
    Atom.from_boolean(symbol =~ /^\d+$/)
  end

  def eq?(other)
    raise if [self, other].any? &:number?

    self == other
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
    Atom.new((integer + 1).to_s)
  end

  def sub1
    Atom.new((integer - 1).to_s).tap do |result|
      raise unless result.number?
    end
  end

  def zero?
    integer.zero?
  end

  private

  def integer
    symbol.to_s.to_i
  end
end

require 'minitest/autorun'

class Atom
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def ==(other)
    self.symbol == other.symbol
  end
end


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

class Evaluator
  def initialize(program)
    @program = program
  end

  def evaluate(env={})
    function, argument = @program.car, @program.cdr.car

    case function.symbol
    when :car
      case argument
      when Atom
        env[argument.symbol].car
      when List
        argument.car
      end
    when :cdr
      case argument
      when Atom
        env[argument.symbol].cdr
      when List
        argument.cdr
      end
    else
      raise
    end
  end
end

class EvaluatorTest < Minitest::Test
  def test_car
    assert_equal Atom.new(:a), evaluate(
      List.new(
        Atom.new(:car),
        List.new(Atom.new(:a), Atom.new(:b), Atom.new(:c))
      )
    )
  end

  def test_car_with_environment_lookup
    assert_equal Atom.new(:a), evaluate(
      List.new(Atom.new(:car), Atom.new(:l)),
      l: List.new(Atom.new(:a), Atom.new(:b), Atom.new(:c))
    )
  end

  def test_cdr
    assert_equal List.new(Atom.new(:b), Atom.new(:c)), evaluate(
      List.new(
        Atom.new(:cdr),
        List.new(Atom.new(:a), Atom.new(:b), Atom.new(:c))
      )
    )
  end

  def test_cdr_with_environment_lookup
    assert_equal List.new(Atom.new(:b), Atom.new(:c)), evaluate(
      List.new(Atom.new(:cdr), Atom.new(:l)),
      l: List.new(Atom.new(:a), Atom.new(:b), Atom.new(:c))
    )
  end

  private

  def evaluate(program, env={})
    Evaluator.new(program).evaluate(env)
  end
end

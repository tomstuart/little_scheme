require 'minitest/unit'
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
    @array.last
  end
end

class Evaluator
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def evaluate(env={})
    function, argument = program.car, program.cdr

    case function.symbol
    when :car
      case argument
      when Atom
        car(env[argument])
      when List
        argument.car
      end
    when :cdr
      case argument
      when Symbol
        cdr(env[argument])
      when Array
        cdr(argument)
      end
    else
      raise
    end
  end

  private
  def car(array)
    array.first
  end

  def cdr(array)
    array[1..-1]
  end
end

class EvaluatorTest < MiniTest::Unit::TestCase
  def test_car
    assert_equal Atom.new(:a), evaluate(
      List.new(
        Atom.new(:car),
        List.new(Atom.new(:a), Atom.new(:b), Atom.new(:c))
        )
      )

    assert_equal Atom.new(:a), evaluate(
      List.new(Atom.new(:car), Atom.new(:l)),
      l: List.new(Atom.new(:a), Atom.new(:b), Atom.new(:c)
    ))

    # assert_equal :a, evaluate(%i(car l), l: %i(a b c))
    # assert_equal :d, evaluate(%i(car l), l: %i(d e f))
  end

  # def test_cdr
  #   assert_equal [:b, :c], evaluate([:cdr, [:a, :b, :c]])
  #   assert_equal %i(b c), evaluate(%i(cdr l), l: %i(a b c))
  #   assert_equal %i(e f), evaluate(%i(cdr l), l: %i(d e f))
  # end

  private
  def evaluate(program, env={})
    Evaluator.new(program).evaluate(env)
  end
end

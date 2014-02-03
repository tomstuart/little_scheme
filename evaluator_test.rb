require 'minitest/autorun'

require_relative 'atom'
require_relative 'list'
require_relative 'evaluator'

class EvaluatorTest < Minitest::Test
  def test_car
    assert_equal Atom.new(:a), evaluate(
      List.new(Atom.new(:car), Atom.new(:l)),
      l: List.new(Atom.new(:a), Atom.new(:b), Atom.new(:c))
    )
  end

  def test_cdr
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

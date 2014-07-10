require 'atom'
require 'list'
require 'support/helpers/parse_helper'

module SyntaxMatchers
  include ParseHelper
  extend RSpec::Matchers::DSL

  matcher :be_an_atom do
    match do |string|
      s_expression = parse_s_expression(string)
      s_expression.is_a?(Atom)
    end
  end

  matcher :be_a_list do
    match do |string|
      s_expression = parse_s_expression(string)
      s_expression.is_a?(List)
    end
  end

  matcher :be_an_s_expression do
    match do |string|
      begin
        raise unless parse_s_expression(string)
        true
      rescue
        false
      end
    end
  end

  matcher :contain_the_s_expressions do |*expected|
    match do |string|
      parse_s_expression(string).array == expected.map(&method(:parse_s_expression))
    end
  end

  matcher :be_a_number do
    match do |string|
      s_expression = parse_s_expression(string)
      s_expression.number?
    end
  end

  matcher :be_a_tup do
    match do |string|
      s_expression = parse_s_expression(string)
      s_expression.array.all? { |s_expression| s_expression.is_a?(Atom) && s_expression.number? }
    end
  end

  matcher :be_an_arithmetic_expression do
    def arithmetic_expression?(s_expressions)
      if s_expressions.length == 1 && s_expressions.first.atom?
        true
      elsif s_expressions.length >= 3
        first, op, *rest = s_expressions
        arithmetic_expression?([first]) && arithmetic_expression?(rest) && op.atom? && %i(+ * expt).include?(op.symbol)
      end
    end

    match do |string|
      s_expressions = parse_program(string)
      arithmetic_expression?(s_expressions)
    end
  end

  matcher :be_a_set do
    match do |string|
      s_expressions = parse_program(string)
      s_expressions.length == 1 && s_expressions.first.list? &&
        s_expressions.first.array.length == s_expressions.first.array.uniq.length
    end
  end

  matcher :be_a_pair do
    match do |string|
      s_expressions = parse_program(string)
      s_expressions.length == 1 && s_expressions.first.list? &&
        s_expressions.first.array.length == 2
    end
  end
end

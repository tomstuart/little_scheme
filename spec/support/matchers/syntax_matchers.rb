require 'support/helpers/parse_helper'

module SyntaxMatchers
  include ParseHelper
  extend RSpec::Matchers::DSL

  matcher :be_an_atom do
    match do |string|
      s_expressions = parse_program(string).s_expressions
      s_expressions.length == 1 && s_expressions.first.atom?
    end
  end

  matcher :be_a_list do
    match do |string|
      s_expressions = parse_program(string).s_expressions
      s_expressions.length == 1 && s_expressions.first.list?
    end
  end

  matcher :be_an_s_expression do
    match do |string|
      s_expressions = parse_program(string).s_expressions
      s_expressions.length == 1 && s_expressions.first.s_expression?
    end
  end

  matcher :contain_the_s_expressions do |*expected|
    match do |string|
      parse_s_expression(string).s_expressions == expected.map(&method(:parse_s_expression))
    end
  end

  matcher :be_a_number do
    match do |string|
      s_expressions = parse_program(string).s_expressions
      s_expressions.length == 1 && s_expressions.first.number?
    end
  end

  matcher :be_a_tup do
    match do |string|
      s_expressions = parse_program(string).s_expressions
      s_expressions.length == 1 && s_expressions.first.list? &&
        s_expressions.first.s_expressions.all? { |s_expression| s_expression.atom? && s_expression.number? }
    end
  end
end

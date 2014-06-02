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
end

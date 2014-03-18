require 'support/helpers/parse_helper'

module SyntaxMatchers
  include ParseHelper
  extend RSpec::Matchers::DSL

  matcher :be_an_atom do
    match do |string|
      s_expression = parse_s_expression(string)
      s_expression.atom? == Atom::TRUE
    end
  end

  matcher :be_a_list do
    match do |string|
      s_expression = parse_s_expression(string)
      s_expression.list?
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
      parse_s_expression(string).s_expressions == expected.map(&method(:parse_s_expression))
    end
  end
end

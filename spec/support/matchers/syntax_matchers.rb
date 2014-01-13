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
end

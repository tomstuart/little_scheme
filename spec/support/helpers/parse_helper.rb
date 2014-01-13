require 'little_scheme/parser'

module ParseHelper
  # A Scheme program consists of one or more S-expressions.
  def parse_program(string)
    LittleScheme::Parser.new.parse(string)
  end

  # We should be able to parse a single S-expression by parsing it as a program
  # and then retrieving it from the resulting AST.
  def parse_s_expression(string)
    program = parse_program(string)
    raise unless program.s_expressions.length == 1
    program.s_expressions.first
  end
end

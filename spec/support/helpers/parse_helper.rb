require 'little_scheme/parser'

module ParseHelper
  def parse_s_expression(string)
    LittleScheme::Parser.new.parse(string).to_ast
  end

  def parse_program(string)
    LittleScheme::Parser.new.parse(string, :root => :program).to_asts
  end
end

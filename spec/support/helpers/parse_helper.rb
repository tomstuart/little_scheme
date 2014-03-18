require 'little_scheme/parser'

module ParseHelper
  def parse_s_expression(string)
    LittleScheme::Parser.new.parse(string).to_ast
  end
end

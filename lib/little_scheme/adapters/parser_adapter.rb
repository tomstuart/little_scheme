require 'atom'
require 'list'
require 'little_scheme/adapters/program_adapter'
require 'treetop'
Treetop.load(File.expand_path('../../../scheme.treetop', __FILE__))

module LittleScheme
  module Adapters
    class ParserAdapter
      def parse(string)
        s_expression = SchemeParser.new.parse(string).to_ast
        ProgramAdapter.new([s_expression])
      end
    end
  end
end

require 'atom'
require 'list'
require 'treetop'
Treetop.load(File.expand_path('../../../scheme.treetop', __FILE__))

module LittleScheme
  module Adapters
    class ParserAdapter
      def parse(string)
        SchemeParser.new.parse(string)
      end
    end
  end
end

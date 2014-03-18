require 'atom'
require 'list'
require 'treetop'
Treetop.load(File.expand_path('../../scheme.treetop', __FILE__))

module LittleScheme
  Parser = ::SchemeParser
end

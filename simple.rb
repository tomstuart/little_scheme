require 'treetop'
require 'atom'
require 'list'
require 'evaluator'



Treetop.load('lib/scheme.treetop')

parser = SchemeParser.new

program = parser.parse("(car (cdr l))").to_ast
l = parser.parse("(1 2 3)").to_ast

p Evaluator.new(program).evaluate({"l" => l})

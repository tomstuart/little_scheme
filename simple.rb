require 'treetop'
Treetop.load('scheme.treetop')

parser = SchemeParser.new

p parser.parse("(foo bar)")

require 'treetop'

class Sexp < Treetop::Runtime::SyntaxNode
end

class Atom < Sexp
  def to_a
    text_value
  end
end

class List < Sexp
  def to_a
    p elements
  end
end


Treetop.load('scheme.treetop')

parser = SchemeParser.new



tree = parser.parse("(foo)")


p tree

p tree.to_a

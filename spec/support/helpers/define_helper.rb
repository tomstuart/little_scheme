require 'support/helpers/evaluate_helper'
require 'support/helpers/parse_helper'

module DefineHelper
  include EvaluateHelper
  include ParseHelper

  def self.extended(base)
    base.class_eval do
      let(:definitions) { {} }
    end
  end

  def define(name, s_expression)
    before(:each) do
      definitions[name] = evaluate_s_expression(parse_s_expression(s_expression), definitions)
    end
  end
end

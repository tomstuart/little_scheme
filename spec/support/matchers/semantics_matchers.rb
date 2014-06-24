require 'support/helpers/evaluate_helper'
require 'support/helpers/parse_helper'

module SemanticsMatchers
  include EvaluateHelper
  include ParseHelper
  extend RSpec::Matchers::DSL

  module EvaluatingMatcher
    def self.included(base)
      base.chain :where do |environment|
        @environment = environment
      end
    end

    def environment
      @environment ||= {}
    end

    def evaluate(string)
      evaluation_environment = definitions.merge(Hash[environment.map { |name, string| [name, parse_s_expression(string)] }])

      evaluate_s_expression(parse_s_expression(string), evaluation_environment)
    end
  end

  matcher :evaluate_to do |expected|
    include EvaluatingMatcher

    match do |actual|
      evaluate(actual) == parse_s_expression(expected)
    end

    failure_message do |actual|
      "expected #{actual.inspect} to evaluate to #{expected.inspect}, but it evaluated to #{evaluate(actual).inspect}"
    end
  end

  matcher :evaluate_to_nothing do
    include EvaluatingMatcher

    match do |actual|
      begin
        evaluate(actual)
        false
      rescue
        true
      end
    end

    failure_message do |actual|
      "expected #{actual.inspect} to evaluate to nothing, but it evaluated to #{evaluate(actual).inspect}"
    end
  end

  matcher :have_the_car do |expected|
    include EvaluatingMatcher

    match do |actual|
      evaluate(actual).car == parse_s_expression(expected)
    end
  end

  matcher :have_no_car do
    include EvaluatingMatcher

    match do |actual|
      begin
        evaluate(actual).car
        false
      rescue
        true
      end
    end
  end

  matcher :have_the_cdr do |expected|
    include EvaluatingMatcher

    match do |actual|
      evaluate(actual).cdr == parse_s_expression(expected)
    end
  end

  matcher :cons_with do |cdr|
    include EvaluatingMatcher

    match do |car|
      evaluate(car).cons(evaluate(cdr)) == parse_s_expression(expected)
    end

    chain :to_make do |expected|
      @expected = expected
    end

    def expected
      @expected
    end

    description do
      "cons with #{cdr.inspect} to make #{expected.inspect}"
    end

    failure_message do |car|
      "expected #{car.inspect} to cons with #{cdr.inspect} to make #{expected.inspect}, but it made #{evaluate(car).cons(evaluate(cdr)).inspect}"
    end
  end

  matcher :be_the_null_list do
    include EvaluatingMatcher

    match do |actual|
      evaluate(actual).null?
    end
  end

  def evaluate_to_true
    evaluate_to '#t'
  end

  def evaluate_to_false
    evaluate_to '#f'
  end

  matcher :be_the_same_atom_as do |actual|
    include EvaluatingMatcher

    match do |expected|
      evaluate(actual) == evaluate(expected)
    end
  end

  matcher :be_a_member_of do |lat|
    include EvaluatingMatcher

    match do |atom|
      evaluate(lat).array.include?(evaluate(atom))
    end
  end

  matcher :evaluate_to_an_atom do |actual|
    include EvaluatingMatcher

    match do |actual|
      evaluate(actual).atom?
    end
  end
end

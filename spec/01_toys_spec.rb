require 'spec_helper'

describe 'a little Scheme' do
  context 'according to chapter one of The Little Schemer' do
    include SyntaxMatchers
    include SemanticsMatchers

    specify { expect('atom').to be_an_atom }
    specify { expect('turkey').to be_an_atom }
    specify { expect('1492').to be_an_atom }
    specify { expect('u').to be_an_atom }
    specify { expect('*abc$').to be_an_atom }

    specify { expect('(atom)').to be_a_list }
    specify { expect('(atom turkey or)').to be_a_list }
    specify { expect('(atom turkey) or').not_to be_a_list }
    specify { expect('((atom turkey) or)').to be_a_list }

    specify { expect('xyz').to be_an_s_expression }
    specify { expect('(x y z)').to be_an_s_expression }
    specify { expect('((x y) z)').to be_an_s_expression }

    describe '(how are you doing so far)' do
      it { is_expected.to be_a_list }
      it { is_expected.to contain_the_s_expressions 'how', 'are', 'you', 'doing', 'so', 'far' }
    end

    describe '(((how) are) ((you) (doing so)) far)' do
      it { is_expected.to be_a_list }
      it { is_expected.to contain_the_s_expressions '((how) are)', '((you) (doing so))', 'far' }
    end

    describe '()' do
      it { is_expected.to be_a_list }
      it { is_expected.not_to be_an_atom }
    end

    specify { expect('(() () () ())').to be_a_list }

    describe 'l' do
      it { is_expected.to have_the_car('a').where l: '(a b c)' }
      it { is_expected.to have_the_car('(a b c)').where l: '((a b c) x y z)' }
      it { is_expected.to have_no_car.where l: 'hotdog' }
      it { is_expected.to have_no_car.where l: '()' }
      it { is_expected.to have_the_car('((hotdogs))').where l: '(((hotdogs)) (and) (pickle) relish)' }
    end

    specify { expect('(car l)').to evaluate_to('((hotdogs))').where l: '(((hotdogs)) (and) (pickle) relish)' }
    specify { expect('(car (car l))').to evaluate_to('(hotdogs)').where l: '(((hotdogs)) (and))' }

    describe 'l' do
      it { is_expected.to have_the_cdr('(b c)').where l: '(a b c)' }
      it { is_expected.to have_the_cdr('(x y z)').where l: '((a b c) x y z)' }
      it { is_expected.to have_the_cdr('()').where l: '(hamburger)' }
    end

    specify { expect('(cdr l)').to evaluate_to('(t r)').where l: '((x) t r)' }
    specify { expect('(cdr a)').to evaluate_to_nothing.where a: 'hotdogs' }
    specify { expect('(cdr l)').to evaluate_to_nothing.where l: '()' }
    specify { expect('(car (cdr l))').to evaluate_to('(x y)').where l: '((b) (x y) ((c)))' }
    specify { expect('(cdr (cdr l))').to evaluate_to('(((c)))').where l: '((b) (x y) ((c)))' }
    specify { expect('(cdr (car l))').to evaluate_to_nothing.where l: '(a (b (c)) d)' }

    specify { expect('a').to cons_with('l').to_make('(peanut butter and jelly)').where a: 'peanut', l: '(butter and jelly)' }
    specify { expect('s').to cons_with('l').to_make('((banana and) peanut butter and jelly)').where s: '(banana and)', l: '(peanut butter and jelly)' }

    describe '(cons s l)' do
      it { is_expected.to evaluate_to('(((help) this) is very ((hard) to learn))').where s: '((help) this)', l: '(is very ((hard) to learn))' }
      it { is_expected.to evaluate_to('((a b (c)))').where s: '(a b (c))', l: '()' }
      it { is_expected.to evaluate_to('(a)').where s: 'a', l: '()' }
      it { is_expected.to evaluate_to_nothing.where s: '((a b c))', l: 'b' }
      it { is_expected.to evaluate_to_nothing.where s: 'a', l: 'b' }
    end

    specify { expect('(cons s (car l))').to evaluate_to('(a b)').where s: 'a', l: '((b) c d)' }
    specify { expect('(cons s (cdr l))').to evaluate_to('(a c d)').where s: 'a', l: '((b) c d)' }

    specify { expect('l').to be_the_null_list.where l: '()' }

    specify { expect('(null? (quote ()))').to be_true }
    specify { expect('(null? l)').to be_false.where l: '(a b c)' }
    specify { expect('(null? a)').to evaluate_to_nothing.where a: 'spaghetti' }

    specify { expect('Harry').to be_an_atom }

    describe '(atom? s)' do
      it { is_expected.to be_true.where s: 'Harry' }
      it { is_expected.to be_false.where s: '(Harry had a heap of apples)' }
    end

    specify { expect('(atom? (car l))').to be_true.where l: '(Harry had a heap of apples)' }

    describe '(atom? (cdr l))' do
      it { is_expected.to be_false.where l: '(Harry had a heap of apples)' }
      it { is_expected.to be_false.where l: '(Harry)' }
    end

    describe '(atom? (car (cdr l)))' do
      it { is_expected.to be_true.where l: '(swing low sweet cherry oat)' }
      it { is_expected.to be_false.where l: '(swing (low sweet) cherry oat)' }
    end

    specify { expect('a1').to be_the_same_atom_as('a2').where a1: 'Harry', a2: 'Harry' }

    describe '(eq? a1 a2)' do
      it { is_expected.to be_true.where a1: 'Harry', a2: 'Harry' }
      it { is_expected.to be_false.where a1: 'margarine', a2: 'butter' }
    end

    specify { expect('(eq? l1 l2)').to evaluate_to_nothing.where l1: '()', l2: '(strawberry)' }
    specify { expect('(eq? n1 n2)').to evaluate_to_nothing.where n1: '6', n2: '7' }
    specify { expect('(eq? (car l) a)').to be_true.where l: '(Mary had a little lamb)', a: 'Mary' }
    specify { expect('(eq? (cdr l) a)').to evaluate_to_nothing.where l: '(soured milk)', a: 'milk' }
    specify { expect('(eq? (car l) (car (cdr l)))').to be_true.where l: '(beans beans we need jelly beans)' }
  end
end

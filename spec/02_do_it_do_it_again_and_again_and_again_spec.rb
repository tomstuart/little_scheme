describe 'a little Scheme' do
  context 'according to chapter two of The Little Schemer' do
    include SemanticsMatchers

    # The book doesn't test lambda, but we will.
    specify { expect('((lambda (l) (car (cdr l))) letters)').to evaluate_to('b').where letters: '(a b c d)' }

    # The book doesn't test cond, but we will.
    describe '(cond ((null? l) a) ((atom? (car l)) b) (else c))' do
      let(:env) { { a: 'empty', b: 'an-atom', c: 'a-list' } }

      it { is_expected.to evaluate_to('empty').where env.merge l: '()' }
      it { is_expected.to evaluate_to('an-atom').where env.merge l: '(x y)' }
      it { is_expected.to evaluate_to('a-list').where env.merge l: '((x y) z)' }
    end

    describe '(foo bar)' do
      define :foo, '(lambda (x) x)'

      it { is_expected.to evaluate_to('a').where bar: 'a' }
    end

    describe '(lat? l)' do
      define :lat?, '(lambda (m) (cond ((null? m) #t) ((atom? (car m)) (lat? (cdr m))) (else #f)))'

      it { is_expected.to evaluate_to_true.where l: '(Jack sprat could eat no chicken fat)' }
      it { is_expected.to evaluate_to_false.where l: '((Jack) sprat could eat no chicken fat)' }
      it { is_expected.to evaluate_to_false.where l: '(Jack (sprat could) eat no chicken fat)' }
      it { is_expected.to evaluate_to_true.where l: '()' }
      it { is_expected.to evaluate_to('#t').where l: '(bacon and eggs)' }
      it { is_expected.to evaluate_to('#f').where l: '(bacon (and eggs))' }
    end

    specify { expect('(or (null? l1) (atom? l2))').to evaluate_to_true.where l1: '()', l2: '(d e f g)' }

    describe '(or (null? l1) (null? l2))' do
      it { is_expected.to evaluate_to_true.where l1: '(a b c)', l2: '()' }
      it { is_expected.to evaluate_to_false.where l1: '(a b c)', l2: '(atom)' }
    end

    specify { expect('a').to be_a_member_of('lat').where a: 'tea', lat: '(coffee tea or milk)' }

    describe '(member? a lat)' do
      define :member?, '(lambda (a lat) (cond ((null? lat) #f) (else (or (eq? (car lat) a) (member? a (cdr lat))))))'

      it { is_expected.to evaluate_to_false.where a: 'poached', lat: '(fried eggs and scrambled eggs)' }
      it { is_expected.to evaluate_to('#t').where a: 'meat', lat: '(mashed potatoes and meat gravy)' }
      it { is_expected.to evaluate_to('#f').where a: 'liver', lat: '(bagels and lox)' }
    end
  end
end

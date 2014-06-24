describe 'a little Scheme' do
  context 'according to chapter six of The Little Schemer' do
    include SyntaxMatchers
    include SemanticsMatchers

    specify { expect('1').to be_an_arithmetic_expression }
    specify { expect('3').to be_an_arithmetic_expression }
    specify { expect('1 + 3').to be_an_arithmetic_expression }
    specify { expect('1 + 3 * 4').to be_an_arithmetic_expression }
    specify { expect('cookie').to be_an_arithmetic_expression }
    specify { expect('3 expt y + 5').to be_an_arithmetic_expression }

    specify { expect('(quote a)').to evaluate_to 'a' }
    specify { expect('(quote +)').to evaluate_to '+' }
    specify { expect('(quote *)').to evaluate_to '*' }
    specify { expect('(eq? (quote a) y)').to evaluate_to_true.where y: 'a' }
    specify { expect('(eq? x y)').to evaluate_to_true.where x: 'a', y: 'a' }

    specify { expect('(n + 3)').not_to be_an_arithmetic_expression }

    describe 'numbered?' do
      define :numbered?, '(lambda (aexp) (cond ((atom? aexp) (number? aexp)) (else (and (numbered? (car aexp)) (numbered? (car (cdr (cdr aexp))))))))'

      specify { expect('(numbered? x)').to evaluate_to_true.where x: '1' }
      specify { expect('(numbered? y)').to evaluate_to_true.where y: '(3 + (4 expt 5))' }
      specify { expect('(numbered? z)').to evaluate_to_false.where z: '(2 * sausage)' }
    end

    describe 'value' do
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :*, '(lambda (n m) (cond ((zero? m) 0) (else (+ n (* n (sub1 m))))))'
      define :expt, '(lambda (n m) (cond ((zero? m) 1) (else (* n (expt n (sub1 m))))))'
      define :value, '(lambda (nexp) (cond ((atom? nexp) nexp) ((eq? (quote +) (car (cdr nexp))) (+ (value (car nexp)) (value (car (cdr (cdr nexp)))))) ((eq? (quote *) (car (cdr nexp))) (* (value (car nexp)) (value (car (cdr (cdr nexp)))))) (else (expt (value (car nexp)) (value (car (cdr (cdr nexp))))))))'

      specify { expect('(value u)').to evaluate_to('13').where u: '13' }
      specify { expect('(value x)').to evaluate_to('4').where x: '(1 + 3)' }
      specify { expect('(value y)').to evaluate_to('82').where y: '(1 + (3 expt 4))' }
    end

    # The book doesn't test this version of value, but we will.
    describe 'value (alternative syntax with helper functions)' do
      define :'1st-sub-exp', '(lambda (aexp) (car (cdr aexp)))'
      define :'2nd-sub-exp', '(lambda (aexp) (car (cdr (cdr aexp))))'
      define :operator, '(lambda (aexp) (car aexp))'
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :*, '(lambda (n m) (cond ((zero? m) 0) (else (+ n (* n (sub1 m))))))'
      define :expt, '(lambda (n m) (cond ((zero? m) 1) (else (* n (expt n (sub1 m))))))'
      define :value, '(lambda (nexp) (cond ((atom? nexp) nexp) ((eq? (operator nexp) (quote +)) (+ (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp)))) ((eq? (operator nexp) (quote *)) (* (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp)))) (else (expt (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))))'

      specify { expect('(value u)').to evaluate_to('13').where u: '13' }
      specify { expect('(value x)').to evaluate_to('4').where x: '(+ 1 3)' }
      specify { expect('(value y)').to evaluate_to('82').where y: '(+ 1 (expt 3 4))' }
    end

    # The book doesn't test this version of value, but we will.
    describe 'value (original syntax with helper functions)' do
      define :'1st-sub-exp', '(lambda (aexp) (car aexp))'
      define :'2nd-sub-exp', '(lambda (aexp) (car (cdr (cdr aexp))))'
      define :operator, '(lambda (aexp) (car (cdr aexp)))'
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :*, '(lambda (n m) (cond ((zero? m) 0) (else (+ n (* n (sub1 m))))))'
      define :expt, '(lambda (n m) (cond ((zero? m) 1) (else (* n (expt n (sub1 m))))))'
      define :value, '(lambda (nexp) (cond ((atom? nexp) nexp) ((eq? (operator nexp) (quote +)) (+ (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp)))) ((eq? (operator nexp) (quote *)) (* (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp)))) (else (expt (value (1st-sub-exp nexp)) (value (2nd-sub-exp nexp))))))'

      specify { expect('(value u)').to evaluate_to('13').where u: '13' }
      specify { expect('(value x)').to evaluate_to('4').where x: '(1 + 3)' }
      specify { expect('(value y)').to evaluate_to('82').where y: '(1 + (3 expt 4))' }
    end

    describe 'another representation for numbers' do
      define :sero?, '(lambda (n) (null? n))'
      define :edd1, '(lambda (n) (cons (quote ()) n))'
      define :zub1, '(lambda (n) (cdr n))'

      specify { expect('(zub1 n)').to evaluate_to_nothing.where n: '()' }

      # The book doesn't test this implementation of +, but we will.
      describe '(+ n m)' do
        define :+, '(lambda (n m) (cond ((sero? m) n) (else (edd1 (+ n (zub1 m))))))'

        let(:two) { '(() ())' }
        let(:three) { '(() () ())' }
        let(:five) { '(() () () () ())' }

        it { is_expected.to evaluate_to(five).where n: two, m: three }
      end
    end

    describe '(lat? ls)' do
      define :lat?, '(lambda (l) (cond ((null? l) #t) ((atom? (car l)) (lat? (cdr l))) (else #f)))'

      it { is_expected.to evaluate_to_true.where ls: '(1 2 3)' }
      it { is_expected.to evaluate_to_false.where ls: '((()) (() ()) (() () ()))' }
    end
  end
end

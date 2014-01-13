describe 'a little Scheme' do
  context 'according to chapter four of The Little Schemer' do
    include SyntaxMatchers
    include SemanticsMatchers

    specify { expect('14').to be_an_atom }
    specify { expect('(atom? n)').to evaluate_to_true.where n: '14' }

    specify { expect('-3').to be_a_number }
    specify { expect('3.14159').to be_a_number }

    specify { expect('(add1 n)').to evaluate_to('68').where n: '67' }
    specify { expect('(add1 67)').to evaluate_to '68' }

    specify { expect('(sub1 n)').to evaluate_to('4').where n: '5' }
    specify { expect('(sub1 0)').to evaluate_to_nothing }

    specify { expect('(zero? 0)').to evaluate_to_true }
    specify { expect('(zero? 1492)').to evaluate_to_false }

    describe '+' do
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'

      specify { expect('(+ 46 12)').to evaluate_to '58' }
    end

    describe '-' do
      define :-, '(lambda (n m) (cond ((zero? m) n) (else (sub1 (- n (sub1 m))))))'

      specify { expect('(- 14 3)').to evaluate_to '11' }
      specify { expect('(- 17 9)').to evaluate_to '8' }
      specify { expect('(- 18 25)').to evaluate_to_nothing }
    end

    specify { expect('(2 11 3 79 47 6)').to be_a_tup }
    specify { expect('(8 55 5 555)').to be_a_tup }
    specify { expect('(1 2 8 apple 4 3)').not_to be_a_tup }
    specify { expect('(3 (7 4) 13 9)').not_to be_a_tup }
    specify { expect('()').to be_a_tup }

    describe '(addtup tup)' do
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :addtup, '(lambda (tup) (cond ((null? tup) 0) (else (+ (car tup) (addtup (cdr tup))))))'

      it { is_expected.to evaluate_to('18').where tup: '(3 5 2 8)' }
      it { is_expected.to evaluate_to('43').where tup: '(15 6 7 12 3)' }
    end

    describe '*' do
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :*, '(lambda (n m) (cond ((zero? m) 0) (else (+ n (* n (sub1 m))))))'

      specify { expect('(* 5 3)').to evaluate_to '15' }
      specify { expect('(* 13 4)').to evaluate_to '52' }
      specify { expect('(* 12 3)').to evaluate_to '36' }
    end

    describe '(tup+ tup1 tup2)' do
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :'tup+', '(lambda (tup1 tup2) (cond ((null? tup1) tup2) ((null? tup2) tup1) (else (cons (+ (car tup1) (car tup2)) (tup+ (cdr tup1) (cdr tup2))))))'

      it { is_expected.to evaluate_to('(11 11 11 11 11)').where tup1: '(3 6 9 11 4)', tup2: '(8 5 2 0 7)' }
      it { is_expected.to evaluate_to('(7 13)').where tup1: '(3 7)', tup2: '(4 6)' }
      it { is_expected.to evaluate_to('(7 13 8 1)').where tup1: '(3 7)', tup2: '(4 6 8 1)' }
      it { is_expected.to evaluate_to('(7 13 8 1)').where tup1: '(3 7 8 1)', tup2: '(4 6)' }
    end

    describe '>' do
      define :>, '(lambda (n m) (cond ((zero? n) #f) ((zero? m) #t) (else (> (sub1 n) (sub1 m)))))'

      specify { expect('(> 12 133)').to evaluate_to '#f' }
      specify { expect('(> 120 11)').to evaluate_to '#t' }
      specify { expect('(> 3 3)').to evaluate_to '#f' }
    end

    describe '<' do
      define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'

      specify { expect('(< 4 6)').to evaluate_to '#t' }
      specify { expect('(< 8 3)').to evaluate_to '#f' }
      specify { expect('(< 6 6)').to evaluate_to '#f' }
    end

    # The book doesn't test =, but we will.
    describe '=' do
      define :>, '(lambda (n m) (cond ((zero? n) #f) ((zero? m) #t) (else (> (sub1 n) (sub1 m)))))'
      define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'
      define :'=', '(lambda (n m) (cond ((> n m) #f) ((< n m) #f) (else #t)))'

      specify { expect('(= 2 1)').to evaluate_to '#f' }
      specify { expect('(= 3 3)').to evaluate_to '#t' }
      specify { expect('(= 2 3)').to evaluate_to '#f' }
    end

    describe 'expt' do
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :*, '(lambda (n m) (cond ((zero? m) 0) (else (+ n (* n (sub1 m))))))'
      define :expt, '(lambda (n m) (cond ((zero? m) 1) (else (* n (expt n (sub1 m))))))'

      specify { expect('(expt 1 1)').to evaluate_to '1' }
      specify { expect('(expt 2 3)').to evaluate_to '8' }
      specify { expect('(expt 5 3)').to evaluate_to '125' }
    end

    describe 'quotient' do
      define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'
      define :-, '(lambda (n m) (cond ((zero? m) n) (else (sub1 (- n (sub1 m))))))'
      define :quotient, '(lambda (n m) (cond ((< n m) 0) (else (add1 (quotient (- n m) m)))))'

      specify { expect('(quotient 15 4)').to evaluate_to '3' }
    end

    describe '(length lat)' do
      define :length, '(lambda (lat) (cond ((null? lat) 0) (else (add1 (length (cdr lat))))))'

      it { is_expected.to evaluate_to('6').where lat: '(hotdogs with mustard sauerkraut and pickles)' }
      it { is_expected.to evaluate_to('5').where lat: '(ham and cheese on rye)' }
    end

    describe '(pick n lat)' do
      define :pick, '(lambda (n lat) (cond ((zero? (sub1 n)) (car lat)) (else (pick (sub1 n) (cdr lat)))))'

      it { is_expected.to evaluate_to('macaroni').where n: '4', lat: '(lasagna spaghetti ravioli macaroni meatball)' }
      it { is_expected.to evaluate_to_nothing.where n: '0', lat: '(a)' }
    end

    describe '(rempick n lat)' do
      define :rempick, '(lambda (n lat) (cond ((zero? (sub1 n)) (cdr lat)) (else (cons (car lat) (rempick (sub1 n) (cdr lat))))))'

      it { is_expected.to evaluate_to('(hotdogs with mustard)').where n: '3', lat: '(hotdogs with hot mustard)' }
    end

    specify { expect('(number? a)').to evaluate_to_false.where a: 'tomato' }
    specify { expect('(number? 76)').to evaluate_to_true }

    describe '(no-nums lat)' do
      define :'no-nums', '(lambda (lat) (cond ((null? lat) (quote ())) (else (cond ((number? (car lat)) (no-nums (cdr lat))) (else (cons (car lat) (no-nums (cdr lat))))))))'

      it { is_expected.to evaluate_to('(pears prunes dates)').where lat: '(5 pears 6 prunes 9 dates)' }
    end

    # The book doesn't test all-nums, but we will.
    describe '(all-nums lat)' do
      define :'all-nums', '(lambda (lat) (cond ((null? lat) (quote ())) (else (cond ((number? (car lat)) (cons (car lat) (all-nums (cdr lat)))) (else (all-nums (cdr lat)))))))'

      it { is_expected.to evaluate_to('(5 6 9)').where lat: '(5 pears 6 prunes 9 dates)' }
    end

    # The book doesn't test eqan?, but we will.
    describe '(eqan? x y)' do
      define :>, '(lambda (n m) (cond ((zero? n) #f) ((zero? m) #t) (else (> (sub1 n) (sub1 m)))))'
      define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'
      define :'=', '(lambda (n m) (cond ((> n m) #f) ((< n m) #f) (else #t)))'
      define :eqan?, '(lambda (a1 a2) (cond ((and (number? a1) (number? a2)) (= a1 a2)) ((or (number? a1) (number? a2)) #f) (else (eq? a1 a2))))'

      it { is_expected.to evaluate_to_true.where x: '5', y: '5' }
      it { is_expected.to evaluate_to_false.where x:'5', y: '6' }
      it { is_expected.to evaluate_to_false.where x: '5', y: 'six' }
      it { is_expected.to evaluate_to_false.where x: 'five', y: 'six' }
      it { is_expected.to evaluate_to_true.where x: 'six', y: 'six' }
    end

    # The book doesn't test occur, but we will.
    describe '(occur a lat)' do
      define :occur, '(lambda (a lat) (cond ((null? lat) 0) (else (cond ((eq? (car lat) a) (add1 (occur a (cdr lat)))) (else (occur a (cdr lat)))))))'

      it { is_expected.to evaluate_to('3').where a: 'beans', lat: '(beans beans we need jelly beans)' }
    end

    describe '(one? n)' do
      define :>, '(lambda (n m) (cond ((zero? n) #f) ((zero? m) #t) (else (> (sub1 n) (sub1 m)))))'
      define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'
      define :'=', '(lambda (n m) (cond ((> n m) #f) ((< n m) #f) (else #t)))'
      define :one?, '(lambda (n) (= n 1))'

      it { is_expected.to evaluate_to('#t').where n: '1' }
      it { is_expected.to evaluate_to('#f').where n: '0' }
      it { is_expected.to evaluate_to('#f').where n: '2' }
    end

    describe '(rempick n lat)' do
      define :>, '(lambda (n m) (cond ((zero? n) #f) ((zero? m) #t) (else (> (sub1 n) (sub1 m)))))'
      define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'
      define :'=', '(lambda (n m) (cond ((> n m) #f) ((< n m) #f) (else #t)))'
      define :one?, '(lambda (n) (= n 1))'
      define :rempick, '(lambda (n lat) (cond ((one? n) (cdr lat)) (else (cons (car lat) (rempick (sub1 n) (cdr lat))))))'

      it { is_expected.to evaluate_to('(lemon meringue pie)').where n: '3', lat: '(lemon meringue salty pie)' }
    end
  end
end

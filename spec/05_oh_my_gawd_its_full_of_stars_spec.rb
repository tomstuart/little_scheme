describe 'a little Scheme' do
  context 'according to chapter five of The Little Schemer' do
    include SemanticsMatchers

    describe '(rember* a l)' do
      define :'rember*', '(lambda (a l) (cond ((null? l) (quote ())) ((atom? (car l)) (cond ((eq? (car l) a) (rember* a (cdr l))) (else (cons (car l) (rember* a (cdr l)))))) (else (cons (rember* a (car l)) (rember* a (cdr l))))))'

      it { is_expected.to evaluate_to('((coffee) ((tea)) (and (hick)))').where a: 'cup', l: '((coffee) cup ((tea) cup) (and (hick)) cup)' }
      it { is_expected.to evaluate_to('(((tomato)) ((bean)) (and ((flying))))').where a: 'sauce', l: '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce))' }
    end

    describe '(lat? l)' do
      define :lat?, '(lambda (m) (cond ((null? m) #t) ((atom? (car m)) (lat? (cdr m))) (else #f)))'

      it { is_expected.to evaluate_to('#f').where l: '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce))' }
    end

    specify { expect('(car l)').not_to evaluate_to_an_atom.where l: '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce))' }

    describe '(insertR* new old l)' do
      define :'insertR*', '(lambda (new old l) (cond ((null? l) (quote ())) ((atom? (car l)) (cond ((eq? (car l) old) (cons old (cons new (insertR* new old (cdr l))))) (else (cons (car l) (insertR* new old (cdr l)))))) (else (cons (insertR* new old (car l)) (insertR* new old (cdr l))))))'

      it { is_expected.to evaluate_to('((how much (wood)) could ((a (wood) chuck roast)) (((chuck roast))) (if (a) ((wood chuck roast))) could chuck roast wood)').where new: 'roast', old: 'chuck', l: '((how much (wood)) could ((a (wood) chuck)) (((chuck))) (if (a) ((wood chuck))) could chuck wood)' }
    end

    describe '(occur* a l)' do
      define :+, '(lambda (n m) (cond ((zero? m) n) (else (add1 (+ n (sub1 m))))))'
      define :'occur*', '(lambda (a l) (cond ((null? l) 0) ((atom? (car l)) (cond ((eq? (car l) a) (add1 (occur* a (cdr l)))) (else (occur* a (cdr l))))) (else (+ (occur* a (car l)) (occur* a (cdr l))))))'

      it { is_expected.to evaluate_to('5').where a: 'banana', l: '((banana) (split ((((banana ice))) (cream (banana)) sherbet)) (banana) (bread) (banana brandy))' }
    end

    describe '(subst* new old l)' do
      define :'subst*', '(lambda (new old l) (cond ((null? l) (quote ())) ((atom? (car l)) (cond ((eq? (car l) old) (cons new (subst* new old (cdr l)))) (else (cons (car l) (subst* new old (cdr l)))))) (else (cons (subst* new old (car l)) (subst* new old (cdr l))))))'

      it { is_expected.to evaluate_to('((orange) (split ((((orange ice))) (cream (orange)) sherbet)) (orange) (bread) (orange brandy))').where new: 'orange', old: 'banana', l: '((banana) (split ((((banana ice))) (cream (banana)) sherbet)) (banana) (bread) (banana brandy))' }
    end

    describe '(insertL* new old l)' do
      define :'insertL*', '(lambda (new old l) (cond ((null? l) (quote ())) ((atom? (car l)) (cond ((eq? (car l) old ) (cons new (cons old (insertL* new old (cdr l))))) (else (cons (car l) (insertL* new old (cdr l)))))) (else (cons (insertL* new old (car l)) (insertL* new old (cdr l))))))'

      it { is_expected.to evaluate_to('((how much (wood)) could ((a (wood) pecker chuck)) (((pecker chuck))) (if (a) ((wood pecker chuck))) could pecker chuck wood)').where new: 'pecker', old: 'chuck', l: '((how much (wood)) could ((a (wood) chuck)) (((chuck))) (if (a) ((wood chuck))) could chuck wood)' }
    end

    describe '(member* a l)' do
      define :'member*', '(lambda (a l) (cond ((null? l) #f) ((atom? (car l)) (or (eq? (car l) a) (member* a (cdr l)))) (else (or (member* a (car l)) (member* a (cdr l))))))'

      it { is_expected.to evaluate_to('#t').where a: 'chips', l: '((potato) (chips ((with) fish) (chips)))' }
    end

    describe 'leftmost' do
      define :leftmost, '(lambda (l) (cond ((atom? (car l)) (car l)) (else (leftmost (car l)))))'

      describe '(leftmost l)' do
        it { is_expected.to evaluate_to('potato').where l: '((potato) (chips ((with) fish) (chips)))' }
        it { is_expected.to evaluate_to('hot').where l: '(((hot) (tuna (and))) cheese)' }
        it { is_expected.to evaluate_to_nothing.where l: '(((() four)) 17 (seventeen))' }
      end

      specify { expect('(leftmost (quote ()))').to evaluate_to_nothing }
    end

    describe '(and (atom? (car l)) (eq? (car l) x))' do
      it { is_expected.to evaluate_to('#f').where x: 'pizza', l: '(mozzarella pizza)' }
      it { is_expected.to evaluate_to('#f').where x: 'pizza', l: '((mozzarella mushroom) pizza)' }
      it { is_expected.to evaluate_to('#t').where x: 'pizza', l: '(pizza (tastes good))' }
    end

    describe '(eqlist? l1 l2)' do
      define :>, '(lambda (n m) (cond ((zero? n) #f) ((zero? m) #t) (else (> (sub1 n) (sub1 m)))))'
      define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'
      define :'=', '(lambda (n m) (cond ((> n m) #f) ((< n m) #f) (else #t)))'
      define :eqan?, '(lambda (a1 a2) (cond ((and (number? a1) (number? a2)) (= a1 a2)) ((or (number? a1) (number? a2)) #f) (else (eq? a1 a2))))'
      define :eqlist?, '(lambda (l1 l2) (cond ((and (null? l1) (null? l2)) #t) ((and (null? l1) (atom? (car l1))) #f) ((null? l1) #f) ((and (atom? (car l1)) (null? l2)) #f) ((and (atom? (car l1)) (atom? (car l2))) (and (eqan? (car l1) (car l2)) (eqlist? (cdr l1) (cdr l2)))) ((atom? (car l1)) #f) ((null? l2) #f) ((atom? (car l2)) #f) (else (and (eqlist? (car l1) (car l2)) (eqlist? (cdr l1) (cdr l2))))))'

      it { is_expected.to evaluate_to('#t').where l1: '(strawberry ice cream)', l2: '(strawberry ice cream)' }
      it { is_expected.to evaluate_to('#f').where l1: '(strawberry ice cream)', l2: '(strawberry cream ice)' }
      it { is_expected.to evaluate_to('#f').where l1: '(banana ((split)))', l2: '((banana) (split))' }
      it { is_expected.to evaluate_to('#f').where l1: '(beef ((sausage)) (and (soda)))', l2: '(beef ((salami)) (and (soda)))' }
      it { is_expected.to evaluate_to('#t').where l1: '(beef ((sausage)) (and (soda)))', l2: '(beef ((sausage)) (and (soda)))' }
    end
  end
end

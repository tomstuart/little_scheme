describe 'a little Scheme' do
  context 'according to chapter seven of The Little Schemer' do
    include SyntaxMatchers
    include SemanticsMatchers

    define :>, '(lambda (n m) (cond ((zero? n) #f) ((zero? m) #t) (else (> (sub1 n) (sub1 m)))))'
    define :<, '(lambda (n m) (cond ((zero? m) #f) ((zero? n) #t) (else (< (sub1 n) (sub1 m)))))'
    define :'=', '(lambda (n m) (cond ((> n m) #f) ((< n m) #f) (else #t)))'
    define :eqan?, '(lambda (a1 a2) (cond ((and (number? a1) (number? a2)) (= a1 a2)) ((or (number? a1) (number? a2)) #f) (else (eq? a1 a2))))'
    define :eqlist?, '(lambda (l1 l2) (cond ((and (null? l1) (null? l2)) #t) ((or (null? l1) (null? l2)) #f) ((and (atom? (car l1)) (atom? (car l2))) (and (eqan? (car l1) (car l2)) (eqlist? (cdr l1) (cdr l2)))) ((or (atom? (car l1)) (atom? (car l2))) #f) (else (and (eqlist? (car l1) (car l2)) (eqlist? (cdr l1) (cdr l2))))))'
    define :equal?, '(lambda (s1 s2) (cond ((and (atom? s1) (atom? s2)) (eqan? s1 s2)) ((or (atom? s1) (atom? s2)) #f) (else (eqlist? s1 s2))))'
    define :member?, '(lambda (a lat) (cond ((null? lat) #f) (else (or (equal? (car lat) a) (member? a (cdr lat))))))'

    specify { expect('(apple peaches apple plum)').not_to be_a_set }

    describe '(set? lat)' do
      define :set?, '(lambda (lat) (cond ((null? lat) #t) ((member? (car lat) (cdr lat)) #f) (else (set? (cdr lat)))))'

      it { is_expected.to evaluate_to('#t').where lat: '(apples peaches pears plums)' }
      it { is_expected.to evaluate_to('#t').where lat: '()' }
      it { is_expected.to evaluate_to_false.where lat: '(apple 3 pear 4 9 apple 3 4)' }
    end

    describe 'makeset, member? version' do
      define :makeset, '(lambda (lat) (cond ((null? lat) (quote ())) ((member? (car lat) (cdr lat)) (makeset (cdr lat))) (else (cons (car lat) (makeset (cdr lat))))))'

      specify { expect('(makeset lat)').to evaluate_to('(pear plum apple lemon peach)').where lat: '(apple peach pear peach plum apple lemon peach)' }
    end

    describe 'makeset, multirember version' do
      define :multirember, '(lambda (a lat) (cond ((null? lat) (quote ())) (else (cond ((equal? (car lat) a) (multirember a (cdr lat))) (else (cons (car lat) (multirember a (cdr lat))))))))'
      define :makeset, '(lambda (lat) (cond ((null? lat) (quote ())) (else (cons (car lat) (makeset (multirember (car lat) (cdr lat)))))))'

      specify { expect('(makeset lat)').to evaluate_to('(apple peach pear plum lemon)').where lat: '(apple peach pear peach plum apple lemon peach)' }
      specify { expect('(makeset lat)').to evaluate_to('(apple 3 pear 4 9)').where lat: '(apple 3 pear 4 9 apple 3 4)' }
    end

    describe '(subset? set1 set2)' do
      define :subset?, '(lambda (set1 set2) (cond ((null? set1) #t) (else (and (member? (car set1) set2) (subset? (cdr set1) set2)))))'

      it { is_expected.to evaluate_to('#t').where set1: '(5 chicken wings)', set2: '(5 hamburgers 2 pieces fried chicken and light duckling wings)' }
      it { is_expected.to evaluate_to('#f').where set1: '(4 pounds of horseradish)', set2: '(four pounds chicken and 5 ounces horseradish)' }
    end

    describe '(eqset? set1 set2)' do
      define :subset?, '(lambda (set1 set2) (cond ((null? set1) #t) (else (and (member? (car set1) set2) (subset? (cdr set1) set2)))))'
      define :eqset?, '(lambda (set1 set2) (and (subset? set1 set2) (subset? set2 set1)))'

      it { is_expected.to evaluate_to('#t').where set1: '(6 large chickens with wings)', set2: '(6 chickens with large wings)' }
    end

    describe '(intersect? set1 set2)' do
      define :intersect?, '(lambda (set1 set2) (cond ((null? set1) #f) (else (or (member? (car set1) set2) (intersect? (cdr set1) set2)))))'

      it { is_expected.to evaluate_to('#t').where set1: '(stewed tomatoes and macaroni)', set2: '(macaroni and cheese)' }
    end

    describe '(intersect set1 set2)' do
      define :intersect, '(lambda (set1 set2) (cond ((null? set1) (quote ())) ((member? (car set1) set2) (cons (car set1) (intersect (cdr set1) set2))) (else (intersect (cdr set1) set2))))'

      it { is_expected.to evaluate_to('(and macaroni)').where set1: '(stewed tomatoes and macaroni)', set2: '(macaroni and cheese)' }
    end

    describe '(union set1 set2)' do
      define :union, '(lambda (set1 set2) (cond ((null? set1) set2) ((member? (car set1) set2) (union (cdr set1) set2)) (else (cons (car set1) (union (cdr set1) set2)))))'

      it { is_expected.to evaluate_to('(stewed tomatoes casserole macaroni and cheese)').where set1: '(stewed tomatoes and macaroni casserole)', set2: '(macaroni and cheese)' }
    end

    # The book doesn't test difference, but we will.
    describe '(difference set1 set2)' do
      define :difference, '(lambda (set1 set2) (cond ((null? set1) (quote ())) ((member? (car set1) set2) (difference (cdr set1) set2)) (else (cons (car set1) (difference (cdr set1) set2)))))'

      it { is_expected.to evaluate_to('(tomatoes casserole)').where set1: '(stewed tomatoes and macaroni casserole)', set2: '(macaroni and stewed beef)'}
    end

    describe '(intersectall l-set)' do
      define :intersect, '(lambda (set1 set2) (cond ((null? set1) (quote ())) ((member? (car set1) set2) (cons (car set1) (intersect (cdr set1) set2))) (else (intersect (cdr set1) set2))))'
      define :intersectall, '(lambda (l-set) (cond ((null? (cdr l-set)) (car l-set)) (else (intersect (car l-set) (intersectall (cdr l-set))))))'

      it { is_expected.to evaluate_to('(a)').where :'l-set' => '((a b c) (c a d e) (e f g h a b))' }
    end

    specify { expect('(pear pear)').to be_a_pair }
    specify { expect('(3 7)').to be_a_pair }
    specify { expect('((2) (pair))').to be_a_pair }

    describe '(a-pair? l)' do
      define :'a-pair?', '(lambda (x) (cond ((atom? x) #f) ((null? x) #f) ((null? (cdr x)) #f) ((null? (cdr (cdr x))) #t) (else #f)))'

      it { is_expected.to evaluate_to('#t').where l: '(full (house))' }
    end

    # The book doesn't test these operations, but we will.
    describe 'pair operations' do
      define :first, '(lambda (p) (car p))'
      define :second, '(lambda (p) (car (cdr p)))'
      define :build, '(lambda (s1 s2) (cons s1 (cons s2 (quote ()))))'

      specify { expect('(first p)').to evaluate_to('full').where p: '(full (house))' }
      specify { expect('(second p)').to evaluate_to('(house)').where p: '(full (house))' }
      specify { expect('(build f s)').to evaluate_to('(full (house))').where f: 'full', s: '(house)' }
    end

    # The book doesn't test third, but we will.
    describe '(third l)' do
      define :third, '(lambda (l) (car (cdr (cdr l))))'

      it { is_expected.to evaluate_to('three').where l: '(one two three four)' }
    end

    specify { expect('l').not_to evaluate_to_a_rel.where l: '(apples peaches pumpkin pie)' }
    specify { expect('l').not_to evaluate_to_a_rel.where l: '((apples peaches) (pumpkin pie) (apples peaches))' }
    specify { expect('l').to evaluate_to_a_rel.where l: '((apples peaches) (pumpkin pie))' }
    specify { expect('l').to evaluate_to_a_rel.where l: '((4 3) (4 2) (7 6) (6 2) (3 4))' }

    specify { expect('rel').not_to evaluate_to_a_fun.where rel: '((4 3) (4 2) (7 6) (6 2) (3 4))' }

    describe '(fun? rel)' do
      define :set?, '(lambda (lat) (cond ((null? lat) #t) ((member? (car lat) (cdr lat)) #f) (else (set? (cdr lat)))))'
      define :firsts, '(lambda (l) (cond ((null? l) (quote ())) (else (cons (car (car l)) (firsts (cdr l))))))'
      define :fun?, '(lambda (rel) (set? (firsts rel)))'

      it { is_expected.to evaluate_to('#t').where rel: '((8 3) (4 2) (7 6) (6 2) (3 4))' }
      it { is_expected.to evaluate_to('#f').where rel: '((d 4) (b 0) (b 9) (e 5) (g 4))' }
    end

    describe '(revrel rel)' do
      define :first, '(lambda (p) (car p))'
      define :second, '(lambda (p) (car (cdr p)))'
      define :build, '(lambda (s1 s2) (cons s1 (cons s2 (quote ()))))'
      define :revpair, '(lambda (pair) (build (second pair) (first pair)))'
      define :revrel, '(lambda (rel) (cond ((null? rel) (quote ())) (else (cons (revpair (car rel)) (revrel (cdr rel))))))'

      it { is_expected.to evaluate_to('((a 8) (pie pumpkin) (sick got))').where rel: '((8 a) (pumpkin pie) (got sick))' }
    end

    specify { expect('fun').not_to evaluate_to_a_fullfun.where fun: '((8 3) (4 2) (7 6) (6 2) (3 4))' }

    describe '(fullfun? fun)' do
      define :set?, '(lambda (lat) (cond ((null? lat) #t) ((member? (car lat) (cdr lat)) #f) (else (set? (cdr lat)))))'
      define :seconds, '(lambda (l) (cond ((null? l) (quote ())) (else (cons (car (cdr (car l))) (seconds (cdr l))))))'
      define :fullfun?, '(lambda (fun) (set? (seconds fun)))'

      it { is_expected.to evaluate_to('#t').where fun: '((8 3) (4 8) (7 6) (6 2) (3 4))' }
      it { is_expected.to evaluate_to('#f').where fun: '((grape raisin) (plum prune) (stewed prune))' }
      it { is_expected.to evaluate_to('#t').where fun: '((grape raisin) (plum prune) (stewed grape))' }
    end

    describe '(one-to-one? fun)' do
      define :set?, '(lambda (lat) (cond ((null? lat) #t) ((member? (car lat) (cdr lat)) #f) (else (set? (cdr lat)))))'
      define :firsts, '(lambda (l) (cond ((null? l) (quote ())) (else (cons (car (car l)) (firsts (cdr l))))))'
      define :fun?, '(lambda (rel) (set? (firsts rel)))'
      define :first, '(lambda (p) (car p))'
      define :second, '(lambda (p) (car (cdr p)))'
      define :build, '(lambda (s1 s2) (cons s1 (cons s2 (quote ()))))'
      define :revpair, '(lambda (pair) (build (second pair) (first pair)))'
      define :revrel, '(lambda (rel) (cond ((null? rel) (quote ())) (else (cons (revpair (car rel)) (revrel (cdr rel))))))'
      define :'one-to-one?', '(lambda (fun) (fun? (revrel fun)))'

      it { is_expected.to evaluate_to('#t').where fun: '((8 3) (4 8) (7 6) (6 2) (3 4))' }
      it { is_expected.to evaluate_to('#f').where fun: '((grape raisin) (plum prune) (stewed prune))' }
      it { is_expected.to evaluate_to('#t').where fun: '((grape raisin) (plum prune) (stewed grape))' }
      it { is_expected.to evaluate_to_true.where fun: '((chocolate chip) (doughy cookie))' }
    end
  end
end

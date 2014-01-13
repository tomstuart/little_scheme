describe 'a little Scheme' do
  context 'according to chapter three of The Little Schemer' do
    include SemanticsMatchers

    describe '(rember a lat)' do
      define :rember, '(lambda (a lat) (cond ((null? lat) (quote ())) ((eq? (car lat) a) (cdr lat)) (else (cons (car lat) (rember a (cdr lat))))))'

      it { is_expected.to evaluate_to('(lamb chops and jelly)').where a: 'mint', lat: '(lamb chops and mint jelly)' }
      it { is_expected.to evaluate_to('(lamb chops and flavored mint jelly)').where a: 'mint', lat: '(lamb chops and mint flavored mint jelly)' }
      it { is_expected.to evaluate_to('(bacon lettuce and tomato)').where a: 'toast', lat: '(bacon lettuce and tomato)' }
      it { is_expected.to evaluate_to('(coffee tea cup and hick cup)').where a: 'cup', lat: '(coffee cup tea cup and hick cup)' }
      it { is_expected.to evaluate_to('(bacon lettuce tomato)').where a: 'and', lat: '(bacon lettuce and tomato)' }
      it { is_expected.to evaluate_to('(soy and tomato sauce)').where a: 'sauce', lat: '(soy sauce and tomato sauce)' }
    end

    describe '(firsts l)' do
      define :firsts, '(lambda (l) (cond ((null? l) (quote ())) (else (cons (car (car l)) (firsts (cdr l))))))'

      it { is_expected.to evaluate_to('(apple plum grape bean)').where l: '((apple peach pumpkin) (plum pear cherry) (grape raisin pea) (bean carrot eggplant))' }
      it { is_expected.to evaluate_to('(a c e)').where l: '((a b) (c d) (e f))' }
      it { is_expected.to evaluate_to('()').where l: '()' }
      it { is_expected.to evaluate_to('(five four eleven)').where l: '((five plums) (four) (eleven green oranges))' }
      it { is_expected.to evaluate_to('((five plums) eleven (no))').where l: '(((five plums) four) (eleven green oranges) ((no) more))' }
    end

    describe '(insertR new old lat)' do
      define :insertR, '(lambda (new old lat) (cond ((null? lat) (quote ())) (else (cond ((eq? (car lat) old) (cons old (cons new (cdr lat)))) (else (cons (car lat) (insertR new old (cdr lat))))))))'

      it { is_expected.to evaluate_to('(ice cream with fudge topping for dessert)').where new: 'topping', old: 'fudge', lat: '(ice cream with fudge for dessert)' }
      it { is_expected.to evaluate_to('(tacos tamales and jalapeño salsa)').where new: 'jalapeño', old: 'and', lat: '(tacos tamales and salsa)' }
      it { is_expected.to evaluate_to('(a b c d e f g d h)').where new: 'e', old: 'd', lat: '(a b c d f g d h)' }
    end

    # The book doesn't test insertL, but we will.
    describe '(insertL new old lat)' do
      define :insertL, '(lambda (new old lat) (cond ((null? lat) (quote ())) (else (cond ((eq? (car lat) old) (cons new lat)) (else (cons (car lat) (insertL new old (cdr lat))))))))'

      it { is_expected.to evaluate_to('(a b c d e f g d h)').where new: 'c', old: 'd', lat: '(a b d e f g d h)' }
    end

    describe '(subst new old lat)' do
      define :subst, '(lambda (new old lat) (cond ((null? lat) (quote ())) (else (cond ((eq? (car lat) old) (cons new (cdr lat))) (else (cons (car lat) (subst new old (cdr lat))))))))'

      it { is_expected.to evaluate_to('(ice cream with topping for dessert)').where new: 'topping', old: 'fudge', lat: '(ice cream with fudge for dessert)' }
    end

    describe '(subst2 new o1 o2 lat)' do
      define :subst2, '(lambda (new o1 o2 lat) (cond ((null? lat) (quote ())) (else (cond ((or (eq? (car lat) o1) (eq? (car lat) o2)) (cons new (cdr lat))) (else (cons (car lat) (subst2 new o1 o2 (cdr lat))))))))'

      it { is_expected.to evaluate_to('(vanilla ice cream with chocolate topping)').where new: 'vanilla', o1: 'chocolate', o2: 'banana', lat: '(banana ice cream with chocolate topping)' }
    end

    describe '(multirember a lat)' do
      define :multirember, '(lambda (a lat) (cond ((null? lat) (quote ())) (else (cond ((eq? (car lat) a) (multirember a (cdr lat))) (else (cons (car lat) (multirember a (cdr lat))))))))'

      it { is_expected.to evaluate_to('(coffee tea and hick)').where a: 'cup', lat: '(coffee cup tea cup and hick cup)' }
    end

    # The book doesn't test multiinsertR, but we will.
    describe '(multiinsertR new old lat)' do
      define :multiinsertR, '(lambda (new old lat) (cond ((null? lat) (quote ())) (else (cond ((eq? (car lat) old) (cons (car lat) (cons new (multiinsertR new old (cdr lat))))) (else (cons (car lat) (multiinsertR new old (cdr lat))))))))'

      it { is_expected.to evaluate_to('(a b c d e f g d e h)').where new: 'e', old: 'd', lat: '(a b c d f g d h)' }
    end

    describe '(multiinsertL new old lat)' do
      define :multiinsertL, '(lambda (new old lat) (cond ((null? lat) (quote ())) (else (cond ((eq? (car lat) old) (cons new (cons old (multiinsertL new old (cdr lat))))) (else (cons (car lat) (multiinsertL new old (cdr lat))))))))'

      it { is_expected.to evaluate_to('(chips and fried fish or fried fish and fried)').where new: 'fried', old: 'fish', lat: '(chips and fish or fish and fried)' }
    end

    # The book doesn't test multisubst, but we will.
    describe '(multisubst new old lat)' do
      define :multisubst, '(lambda (new old lat) (cond ((null? lat) (quote ())) (else (cond ((eq? (car lat) old) (cons new (multisubst new old (cdr lat)))) (else (cons (car lat) (multisubst new old (cdr lat))))))))'

      it { is_expected.to evaluate_to('(topping ice cream with topping for dessert)').where new: 'topping', old: 'fudge', lat: '(fudge ice cream with fudge for dessert)' }
    end
  end
end

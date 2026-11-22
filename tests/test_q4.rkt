#lang racket
(require rackunit racket/runtime-path)

(define-runtime-path SRC "../code/34_q4.rkt")

(define load-output
  (with-output-to-string
    (lambda ()
      (parameterize ([current-namespace (make-base-namespace)])
        (dynamic-require SRC #f)))))

(define mns
  (parameterize ([current-namespace (make-base-namespace)])
    (dynamic-require SRC #f)
    (module->namespace SRC)))

(define (run-input in)
  (with-output-to-string
    (lambda ()
      (with-input-from-string in
        (lambda () (eval '(print-insert-result) mns))))))

(define (call f . args) (eval `(,f ,@(map (lambda (a) `(quote ,a)) args)) mns))

(check-equal? load-output "")

(check-equal? (run-input "42 ((1 2) (3 4 5) (6) ()) 3") "((42 1 2) (3 4 5) (42 6) (42))\n")
(check-equal? (run-input "0 (((1) 2) (3) ((4 5 6) ())) 3") "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
(check-equal? (run-input "7 () 3") "(7)\n")
(check-equal? (run-input "7 () 0") "()\n")

(check-equal? (call 'my-length '()) 0)
(check-equal? (call 'my-length '(1 (2 3) ())) 3)
(check-equal? (call 'my-map car '()) '())
(check-equal? (eval '(my-map (lambda (x) (* x x)) '(1 2 3)) mns) '(1 4 9))

(check-equal? (eval '((make-inserter 'z (lambda (k) (= k 1))) '((1) (2 3) ((4)))) mns)
              '((z 1) (2 3) (z (z 4))))
(check-equal? (eval '((make-inserter 'z (lambda (k) #t)) '(() (1))) mns) '(z (z) (z 1)))
(check-equal? (eval '((make-inserter 'z (lambda (k) #f)) '(() (1))) mns) '(() (1)))
(check-equal? (eval '((make-inserter 'z (lambda (k) (>= k 2))) '((1 2) (3) ())) mns) '(z (z 1 2) (3) ()))

(define (nest d) (if (= d 0) '() (list (nest (- d 1)))))
(check-equal? (eval `(insert-if-short 7 ',(nest 100) 5) mns)
              (let loop ((d 100)) (if (= d 0) '(7) (list 7 (loop (- d 1))))))

(define big (build-list 10000 values))
(check-equal? (eval `(insert-if-short 'z ',big 10001) mns) (cons 'z big))
(check-equal? (eval `(insert-if-short 'z ',big 10000) mns) big)
(check-equal? (call 'my-length big) 10000)
(check-equal? (eval `(my-map (lambda (x) (+ x 1)) ',big) mns) (map add1 big))
(check-equal? (eval `(insert-if-short 'z ',(build-list 10000 (lambda (i) '())) 1) mns)
              (build-list 10000 (lambda (i) '(z))))

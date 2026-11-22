#lang racket
(require rackunit racket/runtime-path)

(define-runtime-path SRC "../code/34_q3.rkt")

(define load-output
  (with-output-to-string
    (lambda ()
      (parameterize ([current-namespace (make-base-namespace)])
        (dynamic-require SRC #f)))))

(define mns
  (parameterize ([current-namespace (make-base-namespace)])
    (dynamic-require SRC #f)
    (module->namespace SRC)))

(define (out expr) (with-output-to-string (lambda () (eval expr mns))))

(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define single '(5 () ()))
(define left-chain '(3 (2 (1 () ()) ()) ()))

(define (inorder t) (out `(print-inorder ',t)))
(define (all t) (out `(print-all-traversals ',t)))
(define (hl t) (out `(print-height-and-leaves ',t)))

(check-equal? load-output "")

(check-equal? (inorder t1) "(1 2 3 4 5 6 7)\n")
(check-equal? (all t1) "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check-equal? (hl t1) "(3 4)\n")

(check-equal? (inorder t2) "(1 2 3)\n")
(check-equal? (all t2) "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check-equal? (hl t2) "(3 1)\n")

(check-equal? (inorder t3) "(b a c)\n")
(check-equal? (all t3) "(b a c)\n(a b c)\n(b c a)\n")
(check-equal? (hl t3) "(2 2)\n")

(check-equal? (inorder '()) "()\n")
(check-equal? (all '()) "()\n()\n()\n")
(check-equal? (hl '()) "(0 0)\n")

(check-equal? (inorder single) "(5)\n")
(check-equal? (all single) "(5)\n(5)\n(5)\n")
(check-equal? (hl single) "(1 1)\n")

(check-equal? (inorder left-chain) "(1 2 3)\n")
(check-equal? (all left-chain) "(1 2 3)\n(3 2 1)\n(1 2 3)\n")
(check-equal? (hl left-chain) "(3 1)\n")

(check-equal? (eval '(inorder-acc '(2 (1 () ()) ()) '(9)) mns) '(1 2 9))
(check-equal? (eval '(preorder-acc '(2 (1 () ()) ()) '(9)) mns) '(2 1 9))
(check-equal? (eval '(postorder-acc '(2 (1 () ()) ()) '(9)) mns) '(1 2 9))

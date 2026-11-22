#lang racket/base

;; (my-length lst): number of top-level elements of lst.
;; Base: () has length 0. Step: walk the cdr, adding 1 to the counter each time.
(define (my-length lst)
  (let loop ((l lst) (n 0))
    (if (null? l)
        n
        (loop (cdr l) (+ n 1)))))

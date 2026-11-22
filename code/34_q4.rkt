#lang racket/base

;; (my-length lst): number of top-level elements of lst.
;; Base: () has length 0. Step: walk the cdr, adding 1 to the counter each time.
(define (my-length lst)
  (let loop ((l lst) (n 0))
    (if (null? l)
        n
        (loop (cdr l) (+ n 1)))))

;; (my-reverse lst): lst in reverse order.
;; Base: () is already reversed. Step: cons each element onto the accumulator as it is walked.
(define (my-reverse lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        acc
        (loop (cdr l) (cons (car l) acc)))))

;; (my-map f lst): list of (f e) for each element e of lst, in order.
;; Base: () maps to (). Step: cons (f e) onto the accumulator while walking, then reverse once.
(define (my-map f lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        (my-reverse acc)
        (loop (cdr l) (cons (f (car l)) acc)))))

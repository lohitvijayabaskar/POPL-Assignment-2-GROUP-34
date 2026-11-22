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

;; (list-value? v): true when v is a list, including (), false for an atom.
(define (list-value? v)
  (or (null? v) (pair? v)))

;; (insert-if-short x lst n): lst with x put at the front of every list, at every level,
;; whose original length is less than n.
;; Base: an atom element is kept as it is.
;; Step: recurse into each sublist with my-map, then cons x in front when (my-length lst) < n.
;; The length is taken from the original lst, before any insertion.
(define (insert-if-short x lst n)
  (let ((inner (my-map (lambda (e)
                         (if (list-value? e)
                             (insert-if-short x e n)
                             e))
                       lst)))
    (if (< (my-length lst) n)
        (cons x inner)
        inner)))

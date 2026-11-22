#lang racket/base

;; (tree-value tree), (tree-left tree), (tree-right tree): the three parts of a non-empty tree.
(define (tree-value tree) (car tree))
(define (tree-left tree) (cadr tree))
(define (tree-right tree) (caddr tree))

;; (inorder-acc tree acc): inorder values of tree consed in front of acc.
;; Base: () adds nothing, so the result is acc.
;; Step: inorder of the left subtree, then the node, then inorder of the right subtree,
;; built right to left so each value is consed onto the accumulator.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (tree-left tree)
                   (cons (tree-value tree)
                         (inorder-acc (tree-right tree) acc)))))

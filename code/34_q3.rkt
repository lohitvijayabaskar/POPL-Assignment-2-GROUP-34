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

;; (preorder-acc tree acc): preorder values of tree consed in front of acc.
;; Base: () adds nothing, so the result is acc.
;; Step: the node, then preorder of the left subtree, then preorder of the right subtree,
;; built right to left so each value is consed onto the accumulator.
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (tree-value tree)
            (preorder-acc (tree-left tree)
                          (preorder-acc (tree-right tree) acc)))))

;; (postorder-acc tree acc): postorder values of tree consed in front of acc.
;; Base: () adds nothing, so the result is acc.
;; Step: postorder of the left subtree, then the right subtree, then the node,
;; built right to left so each value is consed onto the accumulator.
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (tree-left tree)
                     (postorder-acc (tree-right tree)
                                    (cons (tree-value tree) acc)))))

;; (height tree): height of tree.
;; Base: () has height 0.
;; Step: 1 plus the larger of the heights of the left and right subtrees.
(define (height tree)
  (if (null? tree)
      0
      (+ 1 (max (height (tree-left tree))
                (height (tree-right tree))))))

;; (leaf-count tree): number of leaves in tree.
;; Base: () has no leaves; a node whose subtrees are both () is one leaf.
;; Step: otherwise the sum of the leaf counts of the left and right subtrees.
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (tree-left tree)) (null? (tree-right tree))) 1)
        (else (+ (leaf-count (tree-left tree))
                 (leaf-count (tree-right tree))))))

;; (print-inorder tree): display the inorder list of tree on one line.
;; Base: () prints "()", since its inorder list is empty.
;; Step: build the inorder list with inorder-acc and an empty accumulator, then end the line.
(define (print-inorder tree)
  (display (inorder-acc tree '()))
  (newline))

;; (print-all-traversals tree): display the inorder, preorder and postorder lists, one per line.
;; Base: () prints "()" three times, since every traversal of () is empty.
;; Step: build each list with its accumulator function and an empty accumulator.
(define (print-all-traversals tree)
  (display (inorder-acc tree '()))
  (newline)
  (display (preorder-acc tree '()))
  (newline)
  (display (postorder-acc tree '()))
  (newline))

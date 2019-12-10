#lang br/quicklang

(require "assembly-parser.rkt" "assembly-tokenizer.rkt")

(define (read-syntax path port)
    (define parse-tree (parse path (make-tokenizer port path)))
    (strip-bindings
        #`(module assembly-mod "assembly-expander.rkt"
        #,parse-tree)))

(provide read-syntax)
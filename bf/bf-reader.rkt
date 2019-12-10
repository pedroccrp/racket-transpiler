#lang br/quicklang

(require "bf-parser.rkt" "bf-tokenizer.rkt")

(define (read-syntax path port)
    (define parse-tree (parse path (make-tokenizer port path)))
    (strip-bindings
        #`(module bf-mod "bf-expander.rkt"
        #,parse-tree)))

(provide read-syntax)
#lang br

(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define bf-lexer
    (lexer-srcloc
        [(:or "\n" whitespace) (token lexeme #:skip? #t)]
        [(:or "inc" "dec" "fwd" "rwd" "read" "write" "begin" "end") (token lexeme lexeme)]
        [digits (token 'INTEGER (string->number lexeme))]
    )
)

(provide bf-lexer)
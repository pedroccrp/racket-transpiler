#lang br

(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define assembly-lexer
    (lexer-srcloc
        [(:or "\n" whitespace) (token lexeme #:skip? #t)]
        [(:or "move" "load" "store" "add" "sub" "inc" "dec" "jump" "jmpc" "print") (token lexeme lexeme)]
        [(:or "br" "cr" "dr") (token lexeme lexeme)]
        [digits (token 'INTEGER (string->number lexeme))]
    )
)

(provide assembly-lexer)
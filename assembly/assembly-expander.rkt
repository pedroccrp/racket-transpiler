#lang br/quicklang

(define-macro (assembly-module-begin HANDLE-EXPR ...)
    #'(#%module-begin 
        HANDLE-EXPR ...))

(provide (rename-out [assembly-module-begin #%module-begin]))

;; Start

(define (fold-funcs apl assembly-funcs)
  (for/fold ([current-apl apl])
            ([assembly-func (in-list assembly-funcs)])
    (apply assembly-func current-apl)))

(define-macro (assembly-program ARGS ...)
  #'(begin
      (define first-apl (list (make-vector 65536 0) (make-vector 7 0)))
      (void (fold-funcs first-apl (list ARGS ...)))))

(provide assembly-program)

(define-macro (assembly-reg REG)
  #'`REG)

(provide assembly-reg)

(define-macro (assembly-hidden-reg REG)
  #'`REG)

(provide assembly-hidden-reg)

;; Op Codes

(define-macro-cases assembly-op
    [(assembly-op "move" TO FROM) 
        #'(lambda (arr regs) 
            (mv arr regs TO FROM))]
    [(assembly-op "load" TO FROM) 
        #'(lambda (arr regs) 
            (load arr regs TO FROM))]
    [(assembly-op "store" TO FROM) 
        #'(lambda (arr regs) 
            (store arr regs TO FROM))]
    [(assembly-op "inc" REG) 
        #'(lambda (arr regs) 
            (inc arr regs REG))]
    [(assembly-op "dec" REG) 
        #'(lambda (arr regs) 
            (dec arr regs REG))]
    [(assembly-op "add" TO FROM) 
        #'(lambda (arr regs) 
            (add arr regs TO FROM))]
    [(assembly-op "sub" TO FROM) 
        #'(lambda (arr regs) 
            (sub arr regs TO FROM))]
    [(assembly-op "print" REG) 
        #'(lambda (arr regs) 
            (print arr regs REG))])

(provide assembly-op)

;; Access Defines

(define (current-byte arr ptr) (vector-ref arr ptr))

(define (set-byte arr ptr val)
  (define new-arr (vector-copy arr))
  (vector-set! new-arr ptr val)
  new-arr)

(define (get-byte arr ptr)
  (vector-ref arr ptr))

;; Op Codes Defines

(define (get-register-index reg)
    (cond
        [(equal? reg "pc") 0]
        [(equal? reg "stk") 1]
        [(equal? reg "frp") 2]
        [(equal? reg "acc") 3]
        [(equal? reg "br") 4]
        [(equal? reg "cr") 5]
        [(equal? reg "dr") 6]
        [else #f]))

(define (mv arr regs TO FROM)
    (define to-index (get-register-index TO))
    (define from-index (get-register-index FROM))
    (define new-regs (set-byte regs to-index (if from-index (get-byte regs from-index) FROM)))
    (list arr new-regs))

(define (load arr regs TO FROM)
    (define to-index (get-register-index TO))
    (define new-regs (set-byte regs to-index (get-byte arr FROM)))
    (list arr new-regs))

(define (store arr regs TO FROM)
    (define from-index (get-register-index FROM))
    (define new-arrs (set-byte arr TO (get-byte regs from-index)))
    (list new-arrs regs))
    
(define (inc arr regs REG)
    (define reg-index (get-register-index REG))
    (define new-regs (set-byte regs reg-index (add1 (get-byte regs reg-index))))
    (list arr new-regs))
    
(define (dec arr regs REG)
    (define reg-index (get-register-index REG))
    (define new-regs (set-byte regs reg-index (sub1 (get-byte regs reg-index))))
    (list arr new-regs))

(define (add arr regs TO FROM)
    (define to-index (get-register-index TO))
    (define from-index (get-register-index FROM))
    (define new-regs (set-byte regs to-index (+ (get-byte regs to-index) (get-byte regs from-index))))
    (list arr new-regs))

(define (sub arr regs TO FROM)
    (define to-index (get-register-index TO))
    (define from-index (get-register-index FROM))
    (define new-regs (set-byte regs to-index (- (get-byte regs to-index) (get-byte regs from-index))))
    (list arr new-regs))

(define (print arr regs REG)
    (display (get-byte regs (get-register-index REG)))
    (newline)
    (list arr regs))
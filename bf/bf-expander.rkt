#lang br/quicklang

(define-macro (bf-module-begin HANDLE-EXPR ...)
    #'(#%module-begin 
        HANDLE-EXPR ...))

(provide (rename-out [bf-module-begin #%module-begin]))

(define (fold-funcs apl bf-funcs)
  (for/fold ([current-apl apl])
            ([bf-func (in-list bf-funcs)])
    (apply bf-func current-apl)))

(define-macro (bf-program OP-OR-LOOP-ARG ...)
  #'(begin
      (define first-apl (list (make-vector 30000 0) 0))
      (void (fold-funcs first-apl (list OP-OR-LOOP-ARG ...)))))

(provide bf-program)

(define-macro (bf-loop "begin" OP-OR-LOOP-ARG ... "end")
  #'(lambda (arr ptr)
      (for/fold ([current-apl (list arr ptr)])
                ([i (in-naturals)]
                 #:break (zero? (apply current-byte
                                       current-apl)))
        (fold-funcs current-apl (list OP-OR-LOOP-ARG ...)))))

(provide bf-loop)

(define-macro-cases bf-op
    [(bf-op "fwd") #'gt]
    [(bf-op "fwd" NUM) 
        #'(lambda (arr ptr)
            (gtn arr ptr NUM))]
    [(bf-op "rwd") #'lt]
    [(bf-op "rwd" NUM) 
        #'(lambda (arr ptr)
            (ltn arr ptr NUM))]
    [(bf-op "inc") #'plus]
    [(bf-op "inc" NUM) 
        #'(lambda (arr ptr)
            (plusn arr ptr NUM))]
    [(bf-op "dec") #'minus]
    [(bf-op "dec" NUM) 
        #'(lambda (arr ptr)
            (minusn arr ptr NUM))]
    [(bf-op "write") #'period]
    [(bf-op "read") #'comma])

(provide bf-op)

(define (current-byte arr ptr) (vector-ref arr ptr))

(define (set-current-byte arr ptr val)
  (define new-arr (vector-copy arr))
  (vector-set! new-arr ptr val)
  new-arr)

(define (gt arr ptr) (list arr (add1 ptr)))

(define (gtn arr ptr num)
  (if (eq? num 1) 
    (gt arr ptr) 
    (let 
        ([ret (gtn arr ptr (- num 1))])
        (gt (car ret) (cadr ret)))))

(define (lt arr ptr) (list arr (sub1 ptr)))

(define (ltn arr ptr num)
  (if (eq? num 1) 
    (lt arr ptr) 
    (let 
        ([ret (ltn arr ptr (- num 1))])
        (lt (car ret) (cadr ret)))))

(define (plus arr ptr)
  (list
   (set-current-byte arr ptr (add1 (current-byte arr ptr)))
   ptr))

(define (plusn arr ptr num)
  (if (eq? num 1) 
    (plus arr ptr) 
    (let 
        ([ret (plusn arr ptr (- num 1))])
        (plus (car ret) (cadr ret)))))

(define (minus arr ptr)
  (list
   (set-current-byte arr ptr (sub1 (current-byte arr ptr)))
   ptr))

(define (minusn arr ptr num)
  (if (eq? num 1) 
    (minus arr ptr) 
    (let 
        ([ret (minusn arr ptr (- num 1))])
        (minus (car ret) (cadr ret)))))

(define (period arr ptr)
  (write-byte (current-byte arr ptr))
  (list arr ptr))

(define (comma arr ptr)
  (list (set-current-byte arr ptr (read-byte)) ptr))



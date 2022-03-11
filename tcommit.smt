(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;unbounded
(declare-sort RM 0)
;bounded
;(declare-datatypes ((RM 0)) (((rm0) (rm1) (rm2) (rm3))))

;state predicates
(declare-fun aborted (RM) Bool)
(declare-fun committed (RM) Bool)
(declare-fun prepared (RM) Bool)
(declare-fun working (RM) Bool)

(assert 
(xor
    ;CNF
    (and 
        (forall ((x RM)) (forall ((y RM))
            ;Note: this can be resolved and simplified with the a|c|p|w clause
            (or 
            (= x y)
            (aborted y)
            (committed x)
            (prepared x)
            (prepared y)
            (working y)
            ))
        )
        (forall ((x RM))
            (or
            (aborted x)
            (committed x)
            (prepared x)
            (working x)
            )
        )
        (forall ((x RM))
            (or
            (not (aborted x))
            (not (committed x))
            )
        )
        (forall ((x RM))
            (or
            (not (aborted x))
            (not (prepared x))
            )
        )
        (forall ((x RM))
            (or
            (not (aborted x))
            (not (working x))
            )
        )
        (forall ((x RM))
            (or
            (not (committed x))
            (not (prepared x))
            )
        )
        (forall ((x RM))
            (or
            (not (committed x))
            (not (working x))
            )
        )
        (forall ((x RM))
            (or
            (not (prepared x))
            (not (working x))
            )
        )
    )

    ;Configs
;    Also choose(x_1, x_2, ...., x_n) should return 1 if exactly one xi is equal to 1. Using | for OR, & for AND, ~ for NOT, choose can be expressed in CNF as (hopefully n is small, 2 or 3)
;choose(x_1, x_2, ..., x_n) = (x_1 | x_2 | ... | x_n)  (~x_1 | ~x_2)  ... (~x_1 | ~x_n)  (~x_2 | ~x_3) ... (~x_2 | ~x_n) ... (~x_{n-1} | ~x_n)
;
;Config A: \forall R: w(R)
;Config C: \forall R: c(R)
;Config P: \forall R: p(R)
;Config W: \forall R: w(R)
;
;Config AP:  \exists R1, R2: distinct(R1, R2) --> (a(R1) & p(R2) & (\forall R3: distinct(R1, R2, R3) --> choose(a(R3), p(R3))))
;Config AW:  \exists R1, R2: distinct(R1, R2) --> (a(R1) & w(R2) & (\forall R3: distinct(R1, R2, R3) --> choose(a(R3), w(R3))))
;Config CP:  \exists R1, R2: distinct(R1, R2) --> (c(R1) & p(R2) & (\forall R3: distinct(R1, R2, R3) --> choose(c(R3), p(R3))))
;Config PW:  \exists R1, R2: distinct(R1, R2) --> (p(R1) & w(R2) & (\forall R3: distinct(R1, R2, R3) --> choose(p(R3), w(R3))))
;
;Config APW: \exists R1, R2, R3: distinct(R1, R2, R3) --> (a(R1) & p(R2) & w(R3) & (\forall R4: distinct(R1, R2, R3, R4) --> choose(a(R4), p(R4), w(R4))))
    (or
        ;A
        (forall ((x RM))
            (aborted x)
        )
        ;C
        (forall ((x RM))
            (committed x)
        )
        ;P
        (forall ((x RM))
            (prepared x)
        )
        ;W
        (forall ((x RM))
            (working x)
        )
        ;AP
        (

        )

        ;AW

        ;CP

        ;PW

        ;APW

        
    )
)
)


(check-sat) 
(get-model)

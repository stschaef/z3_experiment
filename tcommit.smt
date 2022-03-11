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

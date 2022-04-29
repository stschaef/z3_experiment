(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;unbounded
;(declare-sort RM 0)
;bounded
(declare-datatypes ((RM 0)) (((rm0) (rm1) (rm2))))

;state predicates
(declare-fun aborted (RM) Bool)
(declare-fun committed (RM) Bool)
(declare-fun prepared (RM) Bool)
(declare-fun working (RM) Bool)

(assert
(and(forall ((x RM))
    (and
        (=>
            (aborted x)
            (and
                (not(working x))
                (not(committed x))
                (not(prepared x))
            )
        
        )
        (=>
            (working x)
            (and
                (not(aborted x))
                (not(committed x))
                (not(prepared x))
            )
        
        )
        (=>
            (committed x)
            (and
                (not(working x))
                (not(aborted x))
                (not(prepared x))
            )
        
        )
        (=>
            (prepared x)
            (and
                (not(working x))
                (not(committed x))
                (not(aborted x))
            )
        
        )
    )
)


(xor
    ;CNF
    (and 
        (forall ((x RM) (y RM))
            (=> 
                (not(= x y))
                (or
                    (aborted y)
                    (committed x)
                    (prepared x)
                    (prepared y)
                    (working y)
                )
            )
        )
        (forall ((x RM))
    (and
        (=>
            (aborted x)
            (and
                (not(working x))
                (not(committed x))
                (not(prepared x))
            )
        
        )
        (=>
            (working x)
            (and
                (not(aborted x))
                (not(committed x))
                (not(prepared x))
            )
        
        )
        (=>
            (committed x)
            (and
                (not(working x))
                (not(aborted x))
                (not(prepared x))
            )
        
        )
        (=>
            (prepared x)
            (and
                (not(working x))
                (not(committed x))
                (not(aborted x))
            )
        
        )
    )
)
    )

    ;Configs
    (or
        ;A
        (forall ((x RM))
            (and
                (aborted x)
            )
        )
        ;C
        (forall ((x RM))
            (and
                (committed x)
            )
        )
        ;P
        (forall ((x RM))
            (and
                (prepared x)
                (xor
                    (aborted x)
                    (committed x)
                    (prepared x)
                    (working x)
                )
            )
        )
        ;W
        (forall ((x RM))
            (and
                (working x)

            )
        )
        ;AP
        (and
            (exists ((x RM))
                (exists ((y RM))
                    (and 
                    (aborted x)
                    (prepared y)
                    (not (= x y))
                    )
                )
            )
            (forall ((x RM))
                (and 
                    (or
                        (aborted x)
                        (prepared x)
                    )
                )
            )
        )

        ;AW
        (and
            (exists ((x RM))
                (exists ((y RM))
                    (and 
                    (aborted x)
                    (working y)
                    (not (= x y))
                    )
                )
            )
            (forall ((x RM))
                (or
                    (aborted x)
                    (working x)
                )
            
            )
        )

        ;CP
        (and
            (exists ((x RM))
                (exists ((y RM))
                    (and 
                    (committed x)
                    (prepared y)
                    (not (= x y))
                    )
                )
            )
            (forall ((x RM))
                (and 
                    (or
                        (committed x)
                        (prepared x)
                    )

                )
            )
        )

        ;PW
        (and
            (exists ((x RM))
                (exists ((y RM))
                    (and 
                    (working x)
                    (prepared y)
                    (not (= x y))
                    )
                )
            )
            (forall ((x RM))
                (and 
                    (or
                        (working x)
                        (prepared x)
                    )

                )
            )
        )

        ;APW
        (and
            (exists ((x RM))
                (exists ((y RM))
                    (exists ((z RM))
                        (and 
                        (aborted x)
                        (prepared y)
                        (working z)
                        (and
                            (not (= x y))
                            (not (= z y))
                            (not (= x z))
                        )
                        )
                    )
                )
            )
            (forall ((x RM))
                (and 
                    (or
                        (aborted x)
                        (prepared x)
                        (working x)
                    )
                )
            )
        )

        
    )
)
))


(check-sat) 
(get-model)

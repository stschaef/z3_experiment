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
            ;this resolves to
            ;\forall x,y: (x != y) -> (~c(y) -> (c(x) | p(x))
            ;you can then infer (\exists x: c(x)) -> (\forall y: c(y) | p(y)) 
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
            (xor
                (aborted x)
                (committed x)
                (prepared x)
                (working x)
            )
        )
    )

    ;Configs
    (or
        ;A
        (forall ((x RM))
            (and
                (aborted x)
                (xor
                    (aborted x)
                    (committed x)
                    (prepared x)
                    (working x)
                )
            )
        )
        ;C
        (forall ((x RM))
            (and
                (committed x)
                (xor
                    (aborted x)
                    (committed x)
                    (prepared x)
                    (working x)
                )
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
                (xor
                    (aborted x)
                    (committed x)
                    (prepared x)
                    (working x)
                )
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
                    (forall ((x RM))
                        (xor
                            (aborted x)
                            (committed x)
                            (prepared x)
                            (working x)
                        )
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
                (and 
                    (or
                        (aborted x)
                        (working x)
                    )
                    (forall ((x RM))
                        (xor
                            (aborted x)
                            (committed x)
                            (prepared x)
                            (working x)
                        )
                    )
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
                    (forall ((x RM))
                        (xor
                            (aborted x)
                            (committed x)
                            (prepared x)
                            (working x)
                        )
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
                    (forall ((x RM))
                        (xor
                            (aborted x)
                            (committed x)
                            (prepared x)
                            (working x)
                        )
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
                    (forall ((x RM))
                        (xor
                            (aborted x)
                            (committed x)
                            (prepared x)
                            (working x)
                        )
                    )
                )
            )
        )

        
    )
)
)


(check-sat) 
(get-model)

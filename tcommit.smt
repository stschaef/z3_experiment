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
        (exists ((x RM))
            (exists ((y RM))
                (or
                (not(= x y))
                (and
                    (aborted x)
                    (prepared y)
                    (forall ((z RM))
                        (or
                            (or 
                                (= x y)
                                (= y z)
                                (= x z)
                            )
                            (xor
                                (aborted z)
                                (prepared z)
                            )
                        ) 
                    )
                )
                )
            )
        )

        ;AW
        (exists ((x RM))
            (exists ((y RM))
                (or
                (not(= x y))
                (and
                    (aborted x)
                    (working y)
                    (forall ((z RM))
                        (or
                            (or 
                                (= x y)
                                (= y z)
                                (= x z)
                            )
                            (xor
                                (aborted z)
                                (working z)
                            )
                        ) 
                    )
                )
                )
            )
        )

        ;CP
        (exists ((x RM))
            (exists ((y RM))
                (or
                (not(= x y))
                (and
                    (committed x)
                    (prepared y)
                    (forall ((z RM))
                        (or
                            (or 
                                (= x y)
                                (= y z)
                                (= x z)
                            )
                            (xor
                                (committed z)
                                (prepared z)
                            )
                        ) 
                    )
                )
                )
            )
        )

        ;PW
        (exists ((x RM))
            (exists ((y RM))
                (or
                (not(= x y))
                (and
                    (working x)
                    (prepared y)
                    (forall ((z RM))
                        (or
                            (or 
                                (= x y)
                                (= y z)
                                (= x z)
                            )
                            (xor
                                (working z)
                                (prepared z)
                            )
                        ) 
                    )
                )
                )
            )
        )

        ;APW
        (exists ((x RM))
            (exists ((y RM))
                (exists ((z RM))
                    (or
                        (or 
                            (= x y)
                            (= y z)
                            (= x z)
                        )
                        (and
                            (aborted x)
                            (prepared y)
                            (working z)
                            (forall ((w RM))
                                (or
                                    (or 
                                        (= x y)
                                        (= y w)
                                        (= x w)
                                        (= z w)
                                        (= y z)
                                        (= x z)
                                    )
                                    (xor
                                        (aborted w)
                                        (prepared w)
                                        (working w)
                                    )
                                ) 
                            )
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

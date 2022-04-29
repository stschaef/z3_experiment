(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;unbounded
;(declare-sort RM 0)
;bounded
;
(declare-datatypes ((RM 0)) (((rm1) (rm2) (rm3))))

;state predicates
(declare-fun aborted (RM) Bool)
(declare-fun committed (RM) Bool)
(declare-fun prepared (RM) Bool)
(declare-fun working (RM) Bool)

(assert

(and
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
(xor
    ;Constraints
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
        ;Config 1
        (forall ((r RM))
            (and
                (working r)
                (not (aborted r))
                (not (committed r))
                (not (prepared r))
            )
        )

        ;Config 2
        (and
            (exists ((r RM))
                (working r)
            )
            (exists ((r RM))
                (not(working r))
            )
            (forall ((r RM))
                (xor
                    (aborted r)
                    (working r)
                )
            )
            (forall ((r RM))
                (and
                    (not(committed r))
                    (not(prepared r))
                )
            )
        )

        ;Config 3
        (and
            (exists ((r RM))
                (working r)
            )
            (exists ((r RM))
                (not(working r))
            )
            (forall ((r RM))
                (xor
                    (prepared r)
                    (working r)
                )
            )
            (forall ((r RM))
                (and
                    (not(aborted r))
                    (not(committed r))
                )
            )
        )

        ;Config 4
        (and
            (exists ((r RM))
                (working r)
            )
            (exists ((r RM))
                (prepared r)
            )
            (exists ((r RM))
                (aborted r)
            )
            (forall ((r RM))
                (or
                    (aborted r)
                    (prepared r)
                    (working r)
                )
            )
            (forall ((r RM))
                (or
                    (not (aborted r))
                    (not (working r))
                )
            )
            (forall ((r RM))
                (or
                    (not (prepared r))
                    (not (working r))
                )
            )
            (forall ((r RM))
                (or
                    (not (aborted r))
                    (not (prepared r))
                )
            )
            (forall ((r RM))
                (not (committed r))
            )
        )

        ;Config 5
        (forall ((r RM))
            (and
                (aborted r)
                (not(committed r))
                (not(prepared r))
                (not(working r))
            )
        )

        ;Config 6
        (forall ((r RM))
            (and
                (prepared r)
                (not(committed r))
                (not(aborted r))
                (not(working r))
            )
        )

        ;Config 7
        (and
            (exists ((r RM))
                (prepared r)
            )
            (exists ((r RM))
                (not(prepared r))
            )
            (forall ((r RM))
                (xor
                    (aborted r)
                    (prepared r)
                )
            )
            (forall ((r RM))
                (and
                    (not (committed r))
                    (not (working r))
                )
            )
        )

        ;Config 8
        (and
            (exists ((r RM))
                (prepared r)
            )
            (exists ((r RM))
                (not(prepared r))
            )
            (forall ((r RM))
                (xor
                    (committed r)
                    (prepared r)
                )
            )
            (forall ((r RM))
                (and
                    (not (aborted r))
                    (not (working r))
                )
            )
        )

        ;Config 9
        (forall ((r RM))
            (and
                (committed r)
                (not (aborted r))
                (not (prepared r))
                (not (working r))
            )
        )
    )
)
)
)


(check-sat) 
(get-model)

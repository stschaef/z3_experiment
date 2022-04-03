(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

(declare-sort Node 0)
;(declare-datatypes ((Node 0)) (((node0) (node1))))


(declare-fun lock_msg (Node) Bool)
(declare-fun unlock_msg (Node) Bool)
(declare-fun grant_msg (Node) Bool)
(declare-fun holds_lock (Node) Bool)
(declare-const held Bool)

(assert
(xor
    ;conjunction of invariants
    (and
        (exists ((n1 Node) (n2 Node) (n3 Node))
            (or
                (grant_msg n1)
                (holds_lock n2)
                (unlock_msg n3)
                (not held)
            )
        )
        (forall ((n1 Node) (n2 Node))
            (or
                (= n1 n2)
                (not(grant_msg n1))
                (not(grant_msg n2))
            )
        )
        (forall ((n1 Node) (n2 Node))
            (or
                (= n1 n2)
                (not(grant_msg n1))
                (not(holds_lock n2))
            )
        )
        (forall ((n1 Node) (n2 Node))
            (or
                (= n1 n2)
                (not(grant_msg n1))
                (not(unlock_msg n2))
            )
        )
        (forall ((n1 Node) (n2 Node))
            (or
                (= n1 n2)
                (not(holds_lock n1))
                (not(holds_lock n2))
            )
        )
        (forall ((n1 Node) (n2 Node))
            (or
                (= n1 n2)
                (not(holds_lock n1))
                (not(unlock_msg n2))
            )
        )
        (forall ((n1 Node) (n2 Node))
            (or
                (= n1 n2)
                (not(unlock_msg n1))
                (not(unlock_msg n2))
            )
        )
        (forall ((n1 Node))
            (or
                held
                (not(grant_msg n1))
            )
        )
        (forall ((n1 Node))
            (or
                held
                (not(holds_lock n1))
            )
        )
        (forall ((n1 Node))
            (or
                held
                (not(unlock_msg n1))
            )
        )
        (forall ((n1 Node))
            (or
                (not(grant_msg n1))
                (not(holds_lock n1))
            )
        )
        (forall ((n1 Node))
            (or
                (not(grant_msg n1))
                (not(unlock_msg n1))
            )
        )
        (forall ((n1 Node))
            (or
                (not(holds_lock n1))
                (not(unlock_msg n1))
            )
        )
    )

    ;disjunction of configs
    (or
        (and
            (not held)
            (forall ((n Node))
                (not(grant_msg n))
            )
            (forall ((n Node))
                (not(holds_lock n))
            )
            (forall ((n Node))
                (not(unlock_msg n))
            )
        )
        (and
            held
            (exists ((n Node))
                (grant_msg n)
            )
            (forall ((n1 Node) (n2 Node))
                (or
                    (not
                        (and
                            (grant_msg n1)
                            (grant_msg n2)
                        )
                    )
                    (= n1 n2)
                )
            )
            (forall ((n Node))
                (not(holds_lock n))
            )
            (forall ((n Node))
                (not(unlock_msg n))
            )
        )
        (and
            held
            (exists ((n Node))
                (holds_lock n)
            )
            (forall ((n1 Node) (n2 Node))
                (or
                    (not
                        (and
                            (holds_lock n1)
                            (holds_lock n2)
                        )
                    )
                    (= n1 n2)
                )
            )
            (forall ((n Node))
                (not(grant_msg n))
            )
            (forall ((n Node))
                (not(unlock_msg n))
            )
        )
        (and
            held
            (exists ((n Node))
                (unlock_msg n)
            )
            (forall ((n1 Node) (n2 Node))
                (or
                    (not
                        (and
                            (unlock_msg n1)
                            (unlock_msg n2)
                        )
                    )
                    (= n1 n2)
                )
            )
            (forall ((n Node))
                (not(grant_msg n))
            )
            (forall ((n Node))
                (not(holds_lock n))
            )
        )
    )
)
)


(check-sat) 
(get-model)

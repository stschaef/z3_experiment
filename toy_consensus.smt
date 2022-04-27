(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;unbounded
(declare-sort node 0)
(declare-sort value 0)
(declare-sort quorum 0)

;bounded
;(declare-datatypes ((value 0)) (((value1) (value2) (value3))))

;(declare-datatypes ((node 0)) (( (node1) (node2) (node3) (node4) (node5) )))
;(declare-datatypes ((quorum 0)) (( (quorum1) (quorum2) (quorum3) (quorum4) (quorum5) (quorum6) (quorum7) (quorum8) (quorum9) (quorum10) )))

;state predicates
(declare-fun member (node quorum) Bool)
(declare-fun vote (node value) Bool)
(declare-fun didNotVote (node) Bool)
(declare-fun decision (value) Bool)
(declare-fun chosenAt (quorum value) Bool)

(assert
(forall ((q1 quorum) (q2 quorum))
    (exists ((n node))
        (and
            (member n q1)
            (member n q2)
        )
    )
)
)

(assert
(and
        (forall ((n node) (v value))
            (=>
                (didNotVote n)
                (not (vote n v))
            )
        )
        (forall ((n node) (v1 value) (v2 value))
            (=>
                (and
                    (vote n v1)
                    (vote n v2)
                )
                (= v1 v2)
            )
        )
        (forall ((n node))
            (exists ((v value))
                (or
                    (didNotVote n)
                    (vote n v)
                )
            )
        )
        (forall ((q quorum) (v value))
            (=>
                (chosenAt q v)
                (forall ((n node))
                    (=>
                        (member n q)
                        (vote n v)
                    )
                )
            )
        )
        (forall ((v value))
            (=>
                (decision v)
                (exists ((q quorum))
                    (chosenAt q v)
                )
            )
        )
    )
)

(assert
(xor
    ;constraints
    (and
        (forall ((q quorum) (v1 value))
            (=>
                (chosenAt q v1)
                (forall ((n node) (v2 value))
                    (=>
                        (and 
                            (member n q)
                            (not (= v1 v2))
                        )
                        (not (vote n v2))
                    )
                )
            )
        )
    )

    ;configs
    (or
        ;1 no votes, cannot be chosen, cannot be decided
        (and
            (forall ((n node))
                (didNotVote n)
            )
            (forall ((q quorum) (v value))
                (not (chosenAt q v))
            )
            (forall ((v value))
                (not (decision v))
            )
        )

        ;2 some votes, not chosen, and thus not decided
        (and
            (exists ((n node))
                (didNotVote n)
            )
            (exists ((n node))
                (not (didNotVote n))
            )
            (forall ((q quorum) (v value))
                (not (chosenAt q v))
            )
            (forall ((v value))
                (not (decision v))
            )
        )
        
        ;3 some votes, chosen, but not decided
        (and
            (exists ((n node))
                (didNotVote n)
            )
            (exists ((n node))
                (not (didNotVote n))
            )
            (exists ((q quorum) (v value))
                (chosenAt q v)
            )
            (forall ((v value))
                (not (decision v))
            )
        )

        ;4 some votes, chosen, and decided
        (and
            (exists ((n node))
                (didNotVote n)
            )
            (exists ((n node))
                (not (didNotVote n))
            )
            (exists ((q quorum) (v value))
                (chosenAt q v)
            )
            (exists ((v value))
                (decision v)
            )
        )

        ;5 all votes, not chosen, and thus not decided
        (and
            (forall ((n node))
                (not (didNotVote n))
            )
            (forall ((q quorum) (v value))
                (not (chosenAt q v))
            )
            (forall ((v value))
                (not (decision v))
            )
        )

        ;6 all votes, chosen, but not decided
        (and
            (forall ((n node))
                (not (didNotVote n))
            )
            (exists ((q quorum) (v value))
                (chosenAt q v)
            )
            (forall ((v value))
                (not (decision v))
            )
        )

        ;7 all votes, chosen, and decided
        (and
            (forall ((n node))
                (not (didNotVote n))
            )
            (exists ((q quorum) (v value))
                (chosenAt q v)
            )
            (exists ((v value))
                (decision v)
            )
        )
    )
)
)



(check-sat) 
(get-model)

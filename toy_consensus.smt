(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;unbounded
;(declare-sort node 0)
;(declare-sort value 0)
;(declare-sort quorum 0)

;bounded
(declare-datatypes ((node 0)) (((node1) (node2) (node3) (node4))))
(declare-datatypes ((value 0)) (((value1) (value2) (value3))))
(declare-datatypes ((quorum 0)) (((quorum1) (quorum2) (quorum3) (quorum4))))

;state predicates
(declare-fun member (node quorum) Bool)
(declare-fun vote (node value) Bool)
(declare-fun didNotVote (node) Bool)
(declare-fun decision (value) Bool)
(declare-fun chosenAt (quorum value) Bool)

;membership is not freely chosen
(assert
    (and
        ;quorum1 = 123
        (member node1 quorum1)
        (member node2 quorum1)
        (member node3 quorum1)
        (not (member node4 quorum1))
        ;quorum2 = 124
        (member node1 quorum2)
        (member node2 quorum2)
        (member node4 quorum2)
        (not (member node3 quorum2))
        ;quorum3 = 134
        (member node1 quorum3)
        (member node3 quorum3)
        (member node4 quorum3)
        (not (member node2 quorum3))
        ;quorum3 = 234
        (member node2 quorum4)
        (member node3 quorum4)
        (member node4 quorum4)
        (not (member node1 quorum4))
    )
)

(assert
    ;constraints
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
)
(assert
    ;configs
    (not(or
        ;no votes, cannot be chosen, cannot be decided
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

        ;some votes, not chosen, and thus not decided
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

        ;some votes, chosen, but not decided
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

        ;some votes, chosen, and decided
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

        ;all votes, not chosen, and thus not decided
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

        ;all votes, chosen, but not decided
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

        ;all votes, chosen, and decided
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
))

(check-sat) 
(get-model)

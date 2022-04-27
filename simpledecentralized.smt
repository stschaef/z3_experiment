(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)


;(declare-sort Node 0)
(declare-datatypes ((Node 0)) (((node0) (node1) (node2) (node3))))

(declare-fun has_lock (Node) Bool)
(declare-fun message (Node Node) Bool)
(declare-fun start_node (Node) Bool)

(declare-const locks_exclusive Bool)
(declare-const has_lock_implies_no_messages Bool)
(declare-const messages_exclusive Bool)
(declare-const start_exclusive Bool)
(declare-const exists_start Bool)
(declare-const lock_or_message Bool)

(assert
    (and
        (= 
            locks_exclusive
            (forall ((n1 Node) (n2 Node))
                (=>
                    (and (has_lock n1) (has_lock n2))
                    (= n1 n2)
                )
            )
        )   
        (=
            has_lock_implies_no_messages
            (forall ((n Node) (s Node) (d Node))
                (=>
                    (has_lock n)
                    (not(message s d))
                )
            )
        )
        (=
            messages_exclusive
            (forall ((s1 Node) (d1 Node) (s2 Node) (d2 Node))
                (=>
                    (and (message s1 d1) (message s2 d2))
                    (and (= s1 s2) (= d1 d2))
                )
            )
        )
        (=
            start_exclusive
            (forall ((n1 Node) (n2 Node))
                (=>
                    (and (start_node n1) (start_node n2))
                    (= n1 n2)
                )
            )        
        )
        (=
            exists_start
            (exists ((n Node))
                (start_node n)
            )
        )
        (=
            lock_or_message
            (exists ((n Node) (s Node) (d Node))
                (or (has_lock n) (message s d))
            )
        )
    )
)

(assert
    (xor
        ;constraints
        (and
            locks_exclusive
            has_lock_implies_no_messages
            messages_exclusive
            start_exclusive
            exists_start
            lock_or_message
        )

        ;configs
        (or
            ;A
            (and
                locks_exclusive
                exists_start
                (forall ((n Node))
                    (=>
                        (start_node n)
                        (has_lock n)
                    )
                )
                (forall ((s Node) (d Node))
                    (not (message s d))
                )
            )

            ;B
            (and
                exists_start
                ;exclusive self message
                (forall ((n1 Node) (n2 Node))
                    (=>
                        (and (message n1 n1) (message n2 n2))
                        (= n1 n2)
                    )
                )
                ;no non-self messages
                (forall ((s Node) (d Node))
                    (=>
                        (not (= s d))
                        (not (message s d))
                    )
                )
                ;start sent self message
                (forall ((n Node))
                    (=>
                        (start_node n)
                        (message n n)
                    )
                )
                ;no one has lock
                (forall ((n Node))
                    (not (has_lock n))
                )
            )

            ;C
            (and
                start_exclusive
                messages_exclusive
                ;a message from S to a different node implies S is start node
                (forall ((s Node) (d Node))
                    (=>
                        (not (= s d))
                        (=>
                            (message s d)
                            (start_node s)
                        )
                    )
                )
                ;no self messages
                (forall ((n Node))
                    (not (message n n))
                )
                ;exists a non-self message
                (exists ((s Node) (d Node))
                    (and
                        (not(= s d))
                        (message s d)
                    )
                )
                ;no one has lock
                (forall ((n Node))
                    (not (has_lock n))
                )
            )

            ;D
            (and
                exists_start
                locks_exclusive
                start_exclusive
                ;if start node, then another node has lock
                (forall ((n1 Node))
                    (=>
                        (start_node n1)
                        (exists ((n2 Node))
                            (and
                                (not (= n1 n2))
                                (has_lock n2)
                            )
                        )
                    )
                )
                ;no messages
                (forall ((s Node) (d Node))
                    (not (message s d))
                )
            )

            ;E
            (and
                start_exclusive
                messages_exclusive
                ;if message destination is D, then D is start node
                (forall ((s Node) (d Node))
                    (=>
                        (not (= s d))
                        (=>
                            (message s d)
                            (start_node d)
                        )
                    )
                )
                ;no self messages
                (forall ((n Node))
                    (not (message n n))
                )
                ;exists a non-self message
                (exists ((s Node) (d Node))
                    (and
                        (not(= s d))
                        (message s d)
                    )
                )
                ;no one has lock
                (forall ((n Node))
                    (not (has_lock n))
                )
            )

            ;F
            (and
                exists_start
                start_exclusive
                ;if first node, then exists self message at another node
                (forall ((n1 Node))
                    (=>
                        (start_node n1)
                        (exists ((n2 Node))
                            (and
                                (not (= n1 n2))
                                (message n2 n2)
                            )
                        )
                    )
                )
                ;self messages are exclusive
                (forall ((n1 Node) (n2 Node))
                    (=>
                        (and (message n1 n1) (message n2 n2))
                        (= n1 n2)
                    )
                )
                ;no one has lock
                (forall ((n Node))
                    (not (has_lock n))
                )
                ;no non-self messages
                (forall ((s Node) (d Node))
                    (=>
                        (not (= s d))
                        (not (message s d))
                    )
                )
            )

            ;G
            (and
                exists_start
                (forall ((n1 Node) (n2 Node) (n3 Node))
                    (=>
                        (distinct n1 n2 n3)
                        (=>
                            (message n2 n3)
                            (start_node n1)
                        )
                    )
                )
                ;start node is message source to a unique destination
                ;TODO
                (forall ((s Node) (d Node))
                    (=>
                        (not (= s d))
                        (=>
                            (start_node s)
                            (not (message s d))
                        )
                    )
                )
                ;start node a unique destination from other sources
                (forall ((s Node) (d Node))
                    (=>
                        (not (= s d))
                        (=>
                            (start_node d)
                            (not (message s d))
                        )
                    )
                )
                start_exclusive
                ;nonstart nodes are either sources or destinations for messages
                (forall ((n1 Node))
                    (=>
                        (not( start_node n1))
                        (exists ((n2 Node))
                            (and
                                (not (= n1 n2))
                                (or (message n1 n2) (message n2 n1))
                            )
                        )
                    )
                )
                ;exist messages between nonstart nodes
                ;TODO
                (forall ((n1 Node))
                    (=>
                        (start_node n1)
                        (exists ((n2 Node) (n3 Node))
                            (and
                                (distinct n1 n2 n3)
                                (or (message n2 n3) (message n3 n2))
                            )
                        )
                    )
                )
                messages_exclusive
                ;no self messages
                (forall ((n Node))
                    (not (message n n))
                )
                ;no one has lock
                (forall ((n Node))
                    (not (has_lock n))
                )

            )
        )
    )
)



(check-sat) 
(get-model)

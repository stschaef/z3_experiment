(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;should be unbounded sorts
;(declare-sort Client 0)
;(declare-sort Server 0)
(declare-datatypes ((Client 0)) (((client0) (client1) (client2) (client3) (client4) (client5))))
(declare-datatypes ((Server 0)) (((server0) (server1) (server2) (server3) (server4) (server5))))

;link relation and semaphore predicate
(declare-fun link (Client Server) Bool)
(declare-fun semaphore (Server) Bool)

;this SHOULD return unsat if RCNF and RDNF are equivalent
(assert 
(xor
    ;RCNF
    (and
        ;\phi_a
        (forall ((s Server)) (exists ((c Client))
            (or (semaphore s) (link c s))))
        (and
            ;\phi_b: a server cannot be connected to two distinct clients
            (forall ((c1 Client)) (forall ((c2 Client)) (forall ((s Server))
                (or (= c1 c2) (or (not(link c1 s)) (not(link c2 s)))))))
            ;\phi_c: server is not both linked and locked
            (forall ((c Client)) (forall ((s Server))
                (or (not(link c s)) (not(semaphore s)))))
        )
    )

    ;RDNF
    (or 
        ;all servers locked
        (forall ((s4 Server)) (forall ((c5 Client))
            (and (semaphore s4) (not(link c5 s4)))))

        ;exactly one linked
        (exists ((s1 Server))
            (and
                (not(semaphore s1))
                (forall ((s2 Server))
                    (or
                        (= s1 s2)
                        (semaphore s2)
                    )
                )
                (forall ((c Client)) (forall ((s Server))
                    (or (not (link c s)) (not(semaphore s)))))
                (forall ((s Server))
                    (or
                        (semaphore s)
                        (exists ((c Client))
                            (and 
                                (link c s)
                                (forall ((c1 Client))
                                    (or (not(link c1 s)) (= c1 c)))
                            )
                        )
                    )
                )
            )
        )
         
        ;between 2 and N-1 locked
        (and
            ;at least two one server locked
            (exists ((s5 Server)) 
                (exists ((s6 Server))
                    (and
                        (not (= s5 s6))
                        (semaphore s5)
                        (semaphore s6)
                    )
                )
            )
            (and
                ;at least one server linked
                (exists ((s7 Server)) 
                    (not(semaphore s7)))
                (and
                    ;locked servers must be unlinked
                    (forall ((c6 Client)) (forall ((s8 Server))
                        (or (not (link c6 s8)) (not(semaphore s8)))))
                    ;nonlocked servers must be linked to a unique client
                    (forall ((s9 Server))
                        (or
                            (semaphore s9)
                            (exists ((c8 Client))
                                (and 
                                    (link c8 s9)
                                    (forall ((c9 Client))
                                        (or (not(link c9 s9)) (= c8 c9)))
                                )
                            )
                        )
                    )
                )
            )
        )

        ;all servers are linked to a unique client
        (forall ((s6 Server)) (exists ((c7 Client))
            (and (not(semaphore s6)) 
                (and 
                    (link c7 s6) 
                    (forall ((c2 Client)) (forall ((c3 Client)) (forall ((s2 Server))
                        (or (= c2 c3) (or (not(link c2 s2)) (not(link c3 s2))))))
                    )
                )
            )
        ))
    ) 
)
)


(check-sat) 
(get-model)

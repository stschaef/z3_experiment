(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;should be unbounded sorts
(declare-sort Client 0)
(declare-sort Server 0)
;(declare-datatypes ((Client 0)) (((client0) (client1) (client2) (client3))))
;(declare-datatypes ((Server 0)) (((server0) (server1) (server2) (server3))))

;link relation and semaphore predicate
(declare-fun link (Client Server) Bool)
(declare-fun semaphore (Server) Bool)

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
        ;claim: the following config is a fragment of \phi_a, and that \phi_b, \phi_c are trivial here
        (forall ((s Server)) (forall ((c Client))
            (and (semaphore s) (not(link c s)))))

        ;at least one server linked 
        (and
            ;\phi_a fragment 
            (exists ((s Server)) (exists ((c Client))
                (and (not(semaphore s)) (link c s))))
            ;\phi_c
            (forall ((c Client)) (forall ((s Server))
                (or (not (link c s)) (not(semaphore s)))))
            ;\phi_b
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
)
)


(check-sat) 
(get-model)

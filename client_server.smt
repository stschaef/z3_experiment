(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;should be unbounded sorts
;(declare-sort Client 0)
;(declare-sort Server 0)
(declare-datatypes ((Client 0)) (((client0) (client1))))
(declare-datatypes ((Server 0)) (((server0) (server1))))

;link relation and semaphore predicate
(declare-fun link (Client Server) Bool)
(declare-fun semaphore (Server) Bool)

;this SHOULD return unsat if RCNF and RDNF are equivalent
(assert 
(xor
    ;RCNF
    (and
        ;unsure if I can reuse variable names, so I'm numbering them uniquely
        
        ;now this says, all servers are locked or connected to some client
        (forall ((s1 Server)) (exists ((c1 Client))
            (or (semaphore s1) (link c1 s1))))
        (and
            ;a server cannot be connected to two distinct clients
            ;does this need some reference to a semaphore?
            (forall ((c2 Client)) (forall ((c3 Client)) (forall ((s2 Server))
                (or (= c2 c3) (or (not(link c2 s2)) (not(link c3 s2)))))))
            ;a server is not both linked and locked
            (forall ((c4 Client)) (forall ((s3 Server))
                (or (not(link c4 s3)) (not(semaphore s3)))))
        )
    )

    ;RDNF
    (or 
        ;config A
        ;all servers locked
        (forall ((s4 Server)) (forall ((c5 Client))
            (and (semaphore s4) (not(link c5 s4)))))
        (or 
            ;config B
            ;some server is linked to some client, some server is locked
            (and
                ;at least one server locked
                (exists ((s5 Server)) 
                    (semaphore s5))
                (and
                    ;at least server linked
                    (exists ((s7 Server)) 
                        (not(semaphore s7)))
                    (and
                        ;if a client is linked, corresponding server must be unavailable
                        (forall ((c6 Client)) (forall ((s8 Server))
                            (or (not (link c6 s8)) (not(semaphore s8)))))
                        ;at least one client must be linked
                        (exists ((c8 Client)) (exists ((s8 Server)) 
                            (link c8 s8))
                        )
                    )
                )
            )

            ;config C
            ;all servers are linked to some client
            (forall ((s6 Server)) (exists ((c7 Client))
                (and (not(semaphore s6)) (link c7 s6)))
            )
        )
    ) 
)
)


(check-sat) 
(get-model)
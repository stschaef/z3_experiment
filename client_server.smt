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
        
        ;flipped quantifiers from original emails
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
        ;all servers locked
        (forall ((s4 Server)) (forall ((c5 Client))
            (and (semaphore s4) (not(link c5 s4)))))
        (or 
            ;some linked, some unlinked 
            ;changed this from the original proposal, as it allowed for a
            ;linked server to also be locked
            ;Note: this is probably wrong
            (exists ((s5 Server))
                (exists ((s7 Server))
                    (forall ((c6 Client))
                        (exists ((c8 Client))
                            (and
                                (semaphore s5)
                                (and 
                                    (not (semaphore s7))
                                    (and (not(link c6 s5))
                                        (link c8 s7)
                                    )
                                )
                            )
                        )
                    )
                )
            )

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
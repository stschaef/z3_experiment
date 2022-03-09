(set-option :print-success false)
(set-option :produce-models true)

(set-logic UF)

;should be unbounded sorts
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
        (exists ((c1 Client)) (forall ((s1 Server))
            (or (semaphore s1) (link c1 s1))))
        (and
            (forall ((c2 Client)) (forall ((c3 Client)) (forall ((s2 Server))
                (or (= c2 c3) (or (not(link c2 s2)) (not(link c3 s2)))))))
            (forall ((c4 Client)) (forall ((s3 Server))
                (or (not(link c4 s3)) (not(semaphore s3)))))
        )
    )

    ;RDNF
    (or 
        (forall ((s4 Server)) (forall ((c5 Client))
            (and (semaphore s4) (not(link c5 s4)))))
        (or 
            (exists ((s5 Server)) (exists ((c6 Client))
                (and (not(semaphore s5)) (link c6 s5))))
            (or 
                (exists ((s6 Server)) (exists ((c7 Client))
                    (and (semaphore s6) (not(link c7 s6)))))
                (forall ((s7 Server)) (exists ((c8 Client))
                    (and (not(semaphore s7)) (link c8 s7))))
            )
        ) 
    )
)
)

(check-sat) 
(get-model)
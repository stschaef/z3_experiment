(and
(exists  ((C1 Client))
    (or
        (link C1 s1)
        (semaphore s1)
    )
)
(forall  ((C1 Client))
    (forall  ((C2 Client))
        (or
            (=
                C1
                C2
            )
            (or
                (not (link C1 s1))
                (not (link C2 s1))
            )
        )
    )
)
(forall  ((C1 Client))
    (or
        (not (link C1 s1))
        (not (semaphore s1))
    )
)
)

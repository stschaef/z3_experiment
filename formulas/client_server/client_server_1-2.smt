(and
(exists  ((C1 Client))
    (or
        (link C1 s1)
        (semaphore s1)
    )
)
(exists  ((C1 Client))
    (not (link C1 s1))
)
(forall  ((C1 Client))
    (or
        (not (link C1 s1))
        (not (semaphore s1))
    )
)
)

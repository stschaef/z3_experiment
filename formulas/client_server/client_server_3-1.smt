(and
(forall  ((S1 Server))
    (or
        (link c1 S1)
        (semaphore S1)
    )
)
(forall  ((S1 Server))
    (or
        (not (link c1 S1))
        (not (semaphore S1))
    )
)
)

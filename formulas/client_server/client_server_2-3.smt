(and
(exists  ((C1 Client))
    (forall  ((S1 Server))
        (or
            (link C1 S1)
            (semaphore S1)
        )
    )
)
(forall  ((C1 Client))
    (forall  ((C2 Client))
        (forall  ((S1 Server))
            (or
                (=
                    C1
                    C2
                )
                (or
                    (not (link C1 S1))
                    (not (link C2 S1))
                )
            )
        )
    )
)
(forall  ((C1 Client))
    (forall  ((S1 Server))
        (or
            (not (link C1 S1))
            (not (semaphore S1))
        )
    )
)
)

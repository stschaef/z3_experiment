(and
(forall  ((R1 RM))
    (forall  ((R2 RM))
        (or
            (=
                R1
                R2
            )
            (or
                (aborted R1)
                (or
                    (committed R2)
                    (or
                        (prepared R1)
                        (or
                            (prepared R2)
                            (working R1)
                        )
                    )
                )
            )
        )
    )
)
(forall  ((R1 RM))
    (or
        (aborted R1)
        (or
            (committed R1)
            (or
                (prepared R1)
                (working R1)
            )
        )
    )
)
(forall  ((R1 RM))
    (or
        (not (aborted R1))
        (not (committed R1))
    )
)
(forall  ((R1 RM))
    (or
        (not (aborted R1))
        (not (prepared R1))
    )
)
(forall  ((R1 RM))
    (or
        (not (aborted R1))
        (not (working R1))
    )
)
(forall  ((R1 RM))
    (or
        (not (committed R1))
        (not (prepared R1))
    )
)
(forall  ((R1 RM))
    (or
        (not (committed R1))
        (not (working R1))
    )
)
(forall  ((R1 RM))
    (or
        (not (prepared R1))
        (not (working R1))
    )
)
)

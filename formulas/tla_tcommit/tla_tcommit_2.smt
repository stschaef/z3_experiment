(and
(exists  ((R1 RM))
    (forall  ((R2 RM))
        (forall  ((R3 RM))
            (or
                (=
                    R2
                    R3
                )
                (or
                    (aborted R2)
                    (or
                        (committed R3)
                        (or
                            (prepared R1)
                            (working R2)
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

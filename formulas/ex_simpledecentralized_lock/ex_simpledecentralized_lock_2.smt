(and
(exists  ((N1 Node))
    (exists  ((N2 Node))
        (exists  ((N3 Node))
            (or
                (has_lock N1)
                (message N2 N3)
            )
        )
    )
)
(exists  ((N1 Node))
    (exists  ((N2 Node))
        (not (message N1 N2))
    )
)
(exists  ((N1 Node))
    (forall  ((N2 Node))
        (not (message N1 N2))
    )
)
(exists  ((N1 Node))
    (forall  ((N2 Node))
        (not (message N2 N1))
    )
)
(exists  ((N1 Node))
    (start_node N1)
)
(exists  ((N1 Node))
    (not (has_lock N1))
)
(exists  ((N1 Node))
    (not (start_node N1))
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (or
            (=
                N1
                N2
            )
            (or
                (not (has_lock N2))
                (not (message N1 N1))
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (or
            (=
                N1
                N2
            )
            (or
                (not (has_lock N2))
                (not (message N1 N2))
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (or
            (=
                N1
                N2
            )
            (or
                (not (has_lock N2))
                (not (message N2 N1))
            )
        )
    )
)
(forall  ((N1 Node))
    (or
        (not (has_lock N1))
        (not (message N1 N1))
    )
)
)

(and
(exists  ((N1 Node))
    (exists  ((N2 Node))
        (exists  ((N3 Node))
            (or
                (grant_msg N1)
                (or
                    (holds_lock N2)
                    (or
                        (unlock_msg N3)
                        (not held)
                    )
                )
            )
        )
    )
)
(exists  ((N1 Node))
    (not (grant_msg N1))
)
(exists  ((N1 Node))
    (not (holds_lock N1))
)
(exists  ((N1 Node))
    (not (unlock_msg N1))
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (or
            (=
                N1
                N2
            )
            (or
                (not (grant_msg N1))
                (not (holds_lock N2))
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
                (not (grant_msg N1))
                (not (unlock_msg N2))
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
                (not (holds_lock N1))
                (not (unlock_msg N2))
            )
        )
    )
)
(forall  ((N1 Node))
    (or
        held
        (not (grant_msg N1))
    )
)
(forall  ((N1 Node))
    (or
        held
        (not (holds_lock N1))
    )
)
(forall  ((N1 Node))
    (or
        held
        (not (unlock_msg N1))
    )
)
(forall  ((N1 Node))
    (or
        (not (grant_msg N1))
        (not (holds_lock N1))
    )
)
(forall  ((N1 Node))
    (or
        (not (grant_msg N1))
        (not (unlock_msg N1))
    )
)
(forall  ((N1 Node))
    (or
        (not (holds_lock N1))
        (not (unlock_msg N1))
    )
)
)

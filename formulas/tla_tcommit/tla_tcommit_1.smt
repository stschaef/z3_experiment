(and
(or
    (aborted r1)
    (or
        (committed r1)
        (or
            (prepared r1)
            (working r1)
        )
    )
)
(or
    (not (aborted r1))
    (not (committed r1))
)
(or
    (not (aborted r1))
    (not (prepared r1))
)
(or
    (not (aborted r1))
    (not (working r1))
)
(or
    (not (committed r1))
    (not (prepared r1))
)
(or
    (not (committed r1))
    (not (working r1))
)
(or
    (not (prepared r1))
    (not (working r1))
)
)

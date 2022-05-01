(and
(or
    (grant_msg n1)
    (or
        (holds_lock n1)
        (or
            (unlock_msg n1)
            (not held)
        )
    )
)
(or
    held
    (not (grant_msg n1))
)
(or
    held
    (not (holds_lock n1))
)
(or
    held
    (not (unlock_msg n1))
)
(or
    (not (grant_msg n1))
    (not (holds_lock n1))
)
(or
    (not (grant_msg n1))
    (not (unlock_msg n1))
)
(or
    (not (holds_lock n1))
    (not (unlock_msg n1))
)
)

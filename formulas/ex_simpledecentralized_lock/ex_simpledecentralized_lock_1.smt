(and
(or
    (has_lock n1)
    (message n1 n1)
)
(start_node n1)
(or
    (not (has_lock n1))
    (not (message n1 n1))
)
)

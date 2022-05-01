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
    (start_node N1)
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (or
            (=
                N1
                N2
            )
            (or
                (not (has_lock N1))
                (not (has_lock N2))
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
    (forall  ((N2 Node))
        (or
            (=
                N1
                N2
            )
            (or
                (not (message N1 N1))
                (not (message N2 N2))
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
                (not (message N1 N2))
                (not (message N2 N1))
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
                (not (message N1 N2))
                (not (message N2 N2))
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
                (not (message N2 N1))
                (not (message N2 N2))
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
                (not (start_node N1))
                (not (start_node N2))
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (forall  ((N3 Node))
            (or
                (=
                    N1
                    N2
                )
                (or
                    (=
                        N1
                        N3
                    )
                    (or
                        (=
                            N2
                            N3
                        )
                        (or
                            (not (has_lock N3))
                            (not (message N2 N1))
                        )
                    )
                )
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (forall  ((N3 Node))
            (or
                (=
                    N1
                    N2
                )
                (or
                    (=
                        N1
                        N3
                    )
                    (or
                        (=
                            N2
                            N3
                        )
                        (or
                            (not (message N1 N2))
                            (not (message N3 N2))
                        )
                    )
                )
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (forall  ((N3 Node))
            (or
                (=
                    N1
                    N2
                )
                (or
                    (=
                        N1
                        N3
                    )
                    (or
                        (=
                            N2
                            N3
                        )
                        (or
                            (not (message N2 N1))
                            (not (message N3 N2))
                        )
                    )
                )
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (forall  ((N3 Node))
            (or
                (=
                    N1
                    N2
                )
                (or
                    (=
                        N1
                        N3
                    )
                    (or
                        (=
                            N2
                            N3
                        )
                        (or
                            (not (message N2 N1))
                            (not (message N3 N3))
                        )
                    )
                )
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (forall  ((N3 Node))
            (or
                (=
                    N1
                    N2
                )
                (or
                    (=
                        N1
                        N3
                    )
                    (or
                        (=
                            N2
                            N3
                        )
                        (or
                            (not (message N3 N1))
                            (not (message N3 N2))
                        )
                    )
                )
            )
        )
    )
)
(forall  ((N1 Node))
    (forall  ((N2 Node))
        (forall  ((N3 Node))
            (forall  ((N4 Node))
                (or
                    (=
                        N1
                        N2
                    )
                    (or
                        (=
                            N1
                            N3
                        )
                        (or
                            (=
                                N1
                                N4
                            )
                            (or
                                (=
                                    N2
                                    N3
                                )
                                (or
                                    (=
                                        N2
                                        N4
                                    )
                                    (or
                                        (=
                                            N3
                                            N4
                                        )
                                        (or
                                            (not (message N2 N1))
                                            (not (message N4 N3))
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
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

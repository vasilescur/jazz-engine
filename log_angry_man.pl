:- ensure_loaded(angry_man).

pretty_print_to(_, []).
pretty_print_to(Stream, [Note|Tail]) :-
    Note = note{name: Name, accidental: Accidental, octave: Octave},
    write(Stream, Name), write(Stream, '_'),
    write(Stream, Accidental), write(Stream, '_'),
    write(Stream, Octave),
    write(Stream, ' '),
    pretty_print_to(Stream, Tail).

log_rows(Stream, Limit) :-
    nb_setval(row_count, 0),
    length(Row, 12),
    angry_man_row(Row),
    nb_getval(row_count, N),
    N1 is N + 1,
    nb_setval(row_count, N1),
    pretty_print_to(Stream, Row),
    nl(Stream),
    flush_output(Stream),
    N1 >= Limit, !.
log_rows(_, _).

main :-
    File = 'angry_man_rows.log',
    Limit = 100,
    setup_call_cleanup(
        open(File, write, Stream),
        log_rows(Stream, Limit),
        close(Stream)
    ),
    nb_getval(row_count, Total),
    format("Wrote ~w rows to ~w~n", [Total, File]).

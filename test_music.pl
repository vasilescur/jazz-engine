:- ensure_loaded(music).

:- begin_tests(notes).

test(note_all_fields) :-
    mk_note(c, natural, 4, Note),
    assertion(Note = note{name: c, accidental: natural, octave: 4}).

test(note_name_accidental) :-
    mk_note(c, natural, Note),
    assertion(Note = note{name: c, accidental: natural, octave: 4}).

test(note_name) :-
    mk_note(c, Note),
    assertion(Note = note{name: c, accidental: natural, octave: 4}).

:- end_tests(notes).


:- begin_tests(enharmonics).

test(a_sharp) :-
    mk_note(a, sharp, A_sharp),
    mk_note(b, flat, B_flat),
    assertion(enharmonic(A_sharp, B_flat)).

test(b_flat) :-
    mk_note(b, flat, B_flat),
    mk_note(a, sharp, A_sharp),
    assertion(enharmonic(B_flat, A_sharp)).

test(e_sharp) :- 
    mk_note(e, sharp, E_sharp),
    mk_note(f, natural, F),
    assertion(enharmonic(E_sharp, F)).

test(g_sharp_octave_up) :- 
    mk_note(g, sharp, 4, G_sharp),
    mk_note(a, flat, 5, A_flat),
    assertion(enharmonic(G_sharp, A_flat)).

test(a_flat_octave_down) :-
    mk_note(a, flat, 5, A_flat),
    mk_note(g, sharp, 4, G_sharp),
    assertion(enharmonic(A_flat, G_sharp)).

:- end_tests(enharmonics).


:- begin_tests(flat_sharp_conversion).

test(sharpify_flats_c_natural) :-
    mk_note(c, natural, 4, C_natural),
    mk_note(c, natural, 4, C_natural2),
    assertion(sharpify_flats(C_natural, C_natural2)).

test(sharpify_flats_c_sharp) :-
    mk_note(c, sharp, 4, C_sharp),
    mk_note(c, sharp, 4, C_sharp2),
    assertion(sharpify_flats(C_sharp, C_sharp2)).

test(sharpify_flats_b_flat) :-
    mk_note(b, flat, 4, B_flat),
    mk_note(a, sharp, 4, A_sharp),
    assertion(sharpify_flats(B_flat, A_sharp)).

test(sharpify_flats_a_flat) :-
    mk_note(a, flat, 4, A_flat_4),
    mk_note(g, sharp, 3, G_sharp_3),
    assertion(sharpify_flats(A_flat_4, G_sharp_3)).

test(sharpify_flats_f_flat) :-
    mk_note(f, flat, 4, F_flat_4),
    mk_note(e, natural, 4, E_natural_4),
    assertion(sharpify_flats(F_flat_4, E_natural_4)).

:- end_tests(flat_sharp_conversion).


:- begin_tests(intervals).

test(unison) :-
    mk_note(c, natural, 4, C4),
    mk_note(c, natural, 4, C4),
    interval(C4, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 0),
    assertion(IntervalName = unison).

test(unison_enharmonic) :-
    mk_note(c, sharp, 4, C_sharp),
    mk_note(d, flat, 4, D_flat),
    interval(C_sharp, D_flat, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 0),
    assertion(IntervalName = unison).
test(unison_enharmonic_flipped) :-
    mk_note(c, sharp, 4, C_sharp),
    mk_note(d, flat, 4, D_flat),
    interval(D_flat, C_sharp, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 0),
    assertion(IntervalName = unison).

test(unison_enharmonic_across_octave) :-
    mk_note(g, sharp, 4, G_sharp),
    mk_note(a, flat, 5, A_flat),
    interval(G_sharp, A_flat, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 0),
    assertion(IntervalName = unison).
test(unison_enharmonic_across_octave_flipped) :-
    mk_note(g, sharp, 4, G_sharp),
    mk_note(a, flat, 5, A_flat),
    interval(A_flat, G_sharp, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 0),
    assertion(IntervalName = unison).

test(minor_second) :- % c natural, c sharp
    mk_note(c, natural, 4, C4),
    mk_note(c, sharp, 4, C_sharp),
    interval(C4, C_sharp, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 1),
    assertion(IntervalName = minor_second).
test(minor_second_flipped) :- 
    mk_note(c, natural, 4, C4),
    mk_note(c, sharp, 4, C_sharp),
    interval(C_sharp, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 1),
    assertion(IntervalName = minor_second).

test(major_second) :- % c natural, d natural
    mk_note(c, natural, 4, C4),
    mk_note(d, natural, 4, D4),
    interval(C4, D4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 2),
    assertion(IntervalName = major_second).
test(major_second_flipped) :- 
    mk_note(c, natural, 4, C4),
    mk_note(d, natural, 4, D4),
    interval(D4, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 2),
    assertion(IntervalName = major_second).

test(minor_third) :- % c natural, e flat
    mk_note(c, natural, 4, C4),
    mk_note(e, flat, 4, E_flat),
    interval(C4, E_flat, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 3),
    assertion(IntervalName = minor_third).
test(minor_third_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(e, flat, 4, E_flat),
    interval(E_flat, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 3),
    assertion(IntervalName = minor_third).

test(major_third) :- % c natural, e natural
    mk_note(c, natural, 4, C4),
    mk_note(e, natural, 4, E4),
    interval(C4, E4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 4),
    assertion(IntervalName = major_third).
test(major_third_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(e, natural, 4, E4),
    interval(E4, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 4),
    assertion(IntervalName = major_third).

test(perfect_fourth) :- % c natural, f natural
    mk_note(c, natural, 4, C4),
    mk_note(f, natural, 4, F4),
    interval(C4, F4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 5),
    assertion(IntervalName = perfect_fourth).
test(perfect_fourth_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(f, natural, 4, F4),
    interval(F4, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 5),
    assertion(IntervalName = perfect_fourth).

test(tritone, all(IntervalName == [tritone, augmented_fourth, diminished_fifth])) :-
    mk_note(c, natural, 4, C4),
    mk_note(f, sharp, 4, F_sharp),
    interval(C4, F_sharp, Semitones),
    assertion(Semitones = 6),
    interval_name(Semitones, IntervalName).
test(tritone_flipped, all(IntervalName == [tritone, augmented_fourth, diminished_fifth])) :-
    mk_note(c, natural, 4, C4),
    mk_note(f, sharp, 4, F_sharp),
    interval(F_sharp, C4, Semitones),
    assertion(Semitones = 6),
    interval_name(Semitones, IntervalName).

test(perfect_fifth) :- % c natural, g natural
    mk_note(c, natural, 4, C4),
    mk_note(g, natural, 4, G4),
    interval(C4, G4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 7),
    assertion(IntervalName = perfect_fifth).
test(perfect_fifth_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(g, natural, 4, G4),
    interval(G4, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 7),
    assertion(IntervalName = perfect_fifth).

test(minor_sixth) :- % c natural, a flat
    mk_note(c, natural, 4, C4),
    mk_note(a, flat, 5, A_flat_5),
    interval(C4, A_flat_5, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 8),
    assertion(IntervalName = minor_sixth).
test(minor_sixth_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(a, flat, 5, A_flat_5),
    interval(A_flat_5, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 8),
    assertion(IntervalName = minor_sixth).

test(major_sixth) :- % c natural, a natural
    mk_note(c, natural, 4, C4),
    mk_note(a, natural, 5, A5),
    interval(C4, A5, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 9),
    assertion(IntervalName = major_sixth).
test(major_sixth_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(a, natural, 5, A5),
    interval(A5, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 9),
    assertion(IntervalName = major_sixth).

test(minor_seventh) :- % c natural, b flat
    mk_note(c, natural, 4, C4),
    mk_note(b, flat, 5, B_flat_5),
    interval(C4, B_flat_5, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 10),
    assertion(IntervalName = minor_seventh).
test(minor_seventh_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(b, flat, 5, B_flat_5),
    interval(B_flat_5, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 10),
    assertion(IntervalName = minor_seventh).

test(major_seventh) :- % c natural, b natural
    mk_note(c, natural, 4, C4),
    mk_note(b, natural, 5, B5),
    interval(C4, B5, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 11),
    assertion(IntervalName = major_seventh).
test(major_seventh_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(b, natural, 5, B5),
    interval(B5, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 11),
    assertion(IntervalName = major_seventh).

test(octave) :- % c natural, c natural
    mk_note(c, natural, 4, C4),
    mk_note(c, natural, 5, C5),
    interval(C4, C5, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 12),
    assertion(IntervalName = octave).
test(octave_flipped) :-
    mk_note(c, natural, 4, C4),
    mk_note(c, natural, 5, C5),
    interval(C5, C4, Semitones),
    interval_name(Semitones, IntervalName),
    assertion(Semitones = 12),
    assertion(IntervalName = octave).

:- end_tests(intervals).


:- begin_tests(scale_degrees).

test(major_scale_degree_c_1) :-
    mk_note(c, natural, 4, C4),
    mk_note(c, natural, 4, C4_2),
    major_scale_degree(C4, 1, C4_2).

test(major_scale_degree_c_2) :-
    mk_note(c, natural, 4, C4),
    mk_note(d, natural, 4, D4),
    major_scale_degree(C4, 2, D4).

test(major_scale_degree_c_3) :-
    mk_note(c, natural, 4, C4),
    mk_note(e, natural, 4, E4),
    major_scale_degree(C4, 3, E4).

test(major_scale_degree_c_4) :-
    mk_note(c, natural, 4, C4),
    mk_note(f, natural, 4, F4),
    major_scale_degree(C4, 4, F4).

test(major_scale_degree_c_5) :-
    mk_note(c, natural, 4, C4),
    mk_note(g, natural, 4, G4),
    major_scale_degree(C4, 5, G4).

test(major_scale_degree_c_6) :-
    mk_note(c, natural, 4, C4),
    mk_note(a, natural, 5, A5),
    major_scale_degree(C4, 6, A5).

test(major_scale_degree_c_7) :-
    mk_note(c, natural, 4, C4),
    mk_note(b, natural, 5, B5),
    major_scale_degree(C4, 7, B5).

test(major_scale_degree_d_1) :-
    mk_note(d, natural, 4, D4),
    mk_note(d, natural, 4, D4_2),
    major_scale_degree(D4, 1, D4_2).

test(major_scale_degree_d_2) :-
    mk_note(d, natural, 4, D4),
    mk_note(e, natural, 4, E4),
    major_scale_degree(D4, 2, E4).

test(major_scale_degree_d_3) :-
    mk_note(d, natural, 4, D4),
    mk_note(f, sharp, 4, F_sharp),
    major_scale_degree(D4, 3, F_sharp).

test(major_scale_degree_d_flat_1) :-
    mk_note(d, flat, 4, D_flat),
    mk_note(d, flat, 4, D_flat_2),
    major_scale_degree(D_flat, 1, D_flat_2).

test(major_scale_degree_d_flat_2) :-
    mk_note(d, flat, 4, D_flat),
    mk_note(e, flat, 4, E_flat),
    major_scale_degree(D_flat, 2, E_flat).

test(major_scale_degree_d_flat_3) :- 
    mk_note(d, flat, 4, D_flat),
    mk_note(f, natural, 4, F4),
    major_scale_degree(D_flat, 3, F4).

test(major_scale_degree_d_flat_4) :-
    mk_note(d, flat, 4, D_flat),
    mk_note(g, flat, 4, G_flat),
    major_scale_degree(D_flat, 4, G_flat).

test(major_scale_degree_c_sharp_1) :-
    mk_note(c, sharp, 4, C_sharp),
    mk_note(c, sharp, 4, C_sharp_2),
    major_scale_degree(C_sharp, 1, C_sharp_2).

test(major_scale_degree_c_sharp_2) :-
    mk_note(c, sharp, 4, C_sharp),
    mk_note(d, sharp, 4, D_sharp),
    major_scale_degree(C_sharp, 2, D_sharp).

test(major_scale_degree_c_sharp_3) :-
    mk_note(c, sharp, 4, C_sharp),
    mk_note(e, sharp, 4, E_sharp),
    major_scale_degree(C_sharp, 3, E_sharp).

test(betweenToList) :-
    betweenToList(1,7,[1, 2, 3, 4, 5, 6, 7]).

:- end_tests(scale_degrees).


:- begin_tests(major_scales).

test(c_major_scale) :-
    mk_note(c, natural, 4, C4),
    mk_note(d, natural, 4, D4),
    mk_note(e, natural, 4, E4),
    mk_note(f, natural, 4, F4),
    mk_note(g, natural, 4, G4),
    mk_note(a, natural, 5, A5),
    mk_note(b, natural, 5, B5),
    major_scale(C4, [C4, D4, E4, F4, G4, A5, B5]).

test(g_major_scale) :-
    mk_note(g, natural, 4, G4),
    mk_note(a, natural, 5, A5),
    mk_note(b, natural, 5, B5),
    mk_note(c, natural, 5, C5),
    mk_note(d, natural, 5, D5),
    mk_note(e, natural, 5, E5),
    mk_note(f, sharp, 5, F_sharp_5),
    major_scale(G4, [G4, A5, B5, C5, D5, E5, F_sharp_5]).

test(d_major_scale) :-
    mk_note(d, natural, 4, D4),
    mk_note(e, natural, 4, E4),
    mk_note(f, sharp, 4, F_sharp),
    mk_note(g, natural, 4, G4),
    mk_note(a, natural, 5, A5),
    mk_note(b, natural, 5, B5),
    mk_note(c, sharp, 5, C_sharp_5),
    major_scale(D4, [D4, E4, F_sharp, G4, A5, B5, C_sharp_5]).

test(a_major_scale) :-
    mk_note(a, natural, 4, A4),
    mk_note(b, natural, 4, B4),
    mk_note(c, sharp, 4, C_sharp_4),
    mk_note(d, natural, 4, D4),
    mk_note(e, natural, 4, E4),
    mk_note(f, sharp, 4, F_sharp_4),
    mk_note(g, sharp, 4, G_sharp_4),
    major_scale(A4, [A4, B4, C_sharp_4, D4, E4, F_sharp_4, G_sharp_4]).

test(e_major_scale) :-
    mk_note(e, natural, 4, E4),
    mk_note(f, sharp, 4, F_sharp_4),
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(a, natural, 5, A5),
    mk_note(b, natural, 5, B5),
    mk_note(c, sharp, 5, C_sharp_5),
    mk_note(d, sharp, 5, D_sharp_5),
    major_scale(E4, [E4, F_sharp_4, G_sharp_4, A5, B5, C_sharp_5, D_sharp_5]).

test(b_major_scale) :-
    mk_note(b, natural, 4, B4),
    mk_note(c, sharp, 4, C_sharp_4),
    mk_note(d, sharp, 4, D_sharp_4),
    mk_note(e, natural, 4, E4),
    mk_note(f, sharp, 4, F_sharp_4),
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(a, sharp, 5, A_sharp_5),
    major_scale(B4, [B4, C_sharp_4, D_sharp_4, E4, F_sharp_4, G_sharp_4, A_sharp_5]).

test(f_sharp_major_scale) :-
    mk_note(f, sharp, 4, F_sharp_4),
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(a, sharp, 5, A_sharp_5),
    mk_note(b, natural, 5, B5),
    mk_note(c, sharp, 5, C_sharp_5),
    mk_note(d, sharp, 5, D_sharp_5),
    mk_note(e, sharp, 5, E_sharp_5),
    major_scale(F_sharp_4, [F_sharp_4, G_sharp_4, A_sharp_5, B5, C_sharp_5, D_sharp_5, E_sharp_5]).

test(c_sharp_major_scale) :-
    mk_note(c, sharp, 4, C_sharp_4),
    mk_note(d, sharp, 4, D_sharp_4),
    mk_note(e, sharp, 4, E_sharp_4),
    mk_note(f, sharp, 4, F_sharp_4),
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(a, sharp, 5, A_sharp_5),
    mk_note(b, sharp, 5, B_sharp_5),
    major_scale(C_sharp_4, [C_sharp_4, D_sharp_4, E_sharp_4, F_sharp_4, G_sharp_4, A_sharp_5, B_sharp_5]).

test(g_sharp_major_scale) :-
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(a, sharp, 5, A_sharp_5),
    mk_note(c, natural, 5, C_natural_5),
    mk_note(c, sharp, 5, C_sharp_5),
    mk_note(d, sharp, 5, D_sharp_5),
    mk_note(f, natural, 5, F_natural_5),
    mk_note(g, natural, 5, G_natural_5),
    major_scale(G_sharp_4, [G_sharp_4, A_sharp_5, C_natural_5, C_sharp_5, D_sharp_5, F_natural_5, G_natural_5]).

test(d_sharp_major_scale) :-
    mk_note(d, sharp, 4, D_sharp_4),
    mk_note(f, natural, 4, F_natural_4),
    mk_note(g, natural, 4, G_natural_4),
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(a, sharp, 5, A_sharp_5),
    mk_note(c, natural, 5, C_natural_5),
    mk_note(d, natural, 5, D_natural_5),
    major_scale(D_sharp_4, [D_sharp_4, F_natural_4, G_natural_4, G_sharp_4, A_sharp_5, C_natural_5, D_natural_5]).

test(a_sharp_major_scale) :-
    mk_note(a, sharp, 4, A_sharp_4),
    mk_note(c, natural, 4, C_natural_4),
    mk_note(d, natural, 4, D_natural_4),
    mk_note(d, sharp, 4, D_sharp_4),
    mk_note(f, natural, 4, F_natural_4),
    mk_note(g, natural, 4, G_natural_4),
    mk_note(a, natural, 5, A_natural_5),
    major_scale(A_sharp_4, [A_sharp_4, C_natural_4, D_natural_4, D_sharp_4, F_natural_4, G_natural_4, A_natural_5]).

test(f_major_scale) :-
    mk_note(f, natural, 4, F4),
    mk_note(g, natural, 4, G4),
    mk_note(a, natural, 5, A5),
    mk_note(a, sharp, 5, A_sharp_5),
    mk_note(c, natural, 5, C5),
    mk_note(d, natural, 5, D5),
    mk_note(e, natural, 5, E5),
    major_scale(F4, [F4, G4, A5, A_sharp_5, C5, D5, E5]).

:- end_tests(major_scales).


:- begin_tests(minor_scales).
 
test(c_minor_scale) :- 
    mk_note(c, natural, 4, C4),
    mk_note(d, natural, 4, D4),
    mk_note(d, sharp, 4, D_sharp_4),
    mk_note(f, natural, 4, F4),
    mk_note(g, natural, 4, G4),
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(a, sharp, 5, A_sharp_5),
    minor_scale(C4, [C4, D4, D_sharp_4, F4, G4, G_sharp_4, A_sharp_5]).

test(g_minor_scale) :-
    mk_note(g, natural, 4, G4),
    mk_note(a, natural, 5, A5),
    mk_note(a, sharp, 5, A_sharp_5),
    mk_note(c, natural, 5, C5),
    mk_note(d, natural, 5, D5),
    mk_note(d, sharp, 5, D_sharp_5),
    mk_note(f, natural, 5, F5),
    minor_scale(G4, [G4, A5, A_sharp_5, C5, D5, D_sharp_5, F5]).

test(d_minor_scale) :-
    mk_note(d, natural, 4, D4),
    mk_note(e, natural, 4, E4),
    mk_note(f, natural, 4, F4),
    mk_note(g, natural, 4, G4),
    mk_note(a, natural, 5, A5),
    mk_note(a, sharp, 5, A_sharp_5),
    mk_note(c, natural, 5, C5),
    minor_scale(D4, [D4, E4, F4, G4, A5, A_sharp_5, C5]).

:- end_tests(minor_scales).


:- begin_tests(major_chords).

test(c_major_chord, [nondet]) :-
    mk_note(c, natural, 4, C4),
    mk_note(e, natural, 4, E4),
    mk_note(g, natural, 4, G4),
    major_chord(C4, Chord),
    
    assertion(Chord = chord{adjustments: [natural, natural, natural], 
                            degrees: [1, 3, 5], 
                            pattern: [0, 2, 4, 5, 7, 9, 11], 
                            root: note{
                                    accidental: natural, 
                                    name: c, 
                                    octave: 4
                                }
                            }
    ),
    chord_notes(Chord, Notes),
    assertion(Notes = [C4, E4, G4]).

test(d_major_chord, [nondet]) :-
    mk_note(d, natural, 4, D4),
    mk_note(f, sharp, 4, F_sharp_4),
    mk_note(a, natural, 5, A5),
    major_chord(D4, Chord),

    assertion(Chord = chord{adjustments: [natural, natural, natural], 
                            degrees: [1, 3, 5], 
                            pattern: [0, 2, 4, 5, 7, 9, 11], 
                            root: note{
                                    accidental: natural, 
                                    name: d, 
                                    octave: 4
                                }
                            }
    ),
    chord_notes(Chord, Notes),
    assertion(Notes = [D4, F_sharp_4, A5]).

test(e_major_chord, [nondet]) :-
    mk_note(e, natural, 4, E4),
    mk_note(g, sharp, 4, G_sharp_4),
    mk_note(b, natural, 5, B5),
    major_chord(E4, Chord),

    assertion(Chord = chord{adjustments: [natural, natural, natural], 
                            degrees: [1, 3, 5], 
                            pattern: [0, 2, 4, 5, 7, 9, 11], 
                            root: note{
                                    accidental: natural, 
                                    name: e, 
                                    octave: 4
                                }
                            }
    ),
    chord_notes(Chord, Notes),
    assertion(Notes = [E4, G_sharp_4, B5]).

:- end_tests(major_chords).


:- begin_tests(minor_chords).

test(c_minor_chord, [nondet]) :-
    mk_note(c, natural, 4, C4),
    mk_note(d, sharp, 4, D_sharp_4),
    mk_note(g, natural, 4, G4),
    minor_chord(C4, Chord),

    assertion(Chord = chord{adjustments: [natural, natural, natural], 
                            degrees: [1, 3, 5], 
                            pattern: [0, 2, 3, 5, 7, 8, 10], 
                            root: note{
                                    accidental: natural, 
                                    name: c, 
                                    octave: 4
                                }
                            }
    ),
    chord_notes(Chord, Notes),
    assertion(Notes = [C4, D_sharp_4, G4]).

:- end_tests(minor_chords).


:- begin_tests(chord_progressions).

test(c_1_4_6_5) :-
    mk_note(c, natural, 4, C4),
    major_scale_pattern(Pattern),
    chord_progression(C4, Pattern, [1, 4, 6, 5], Chords),
    assertion(Chords = [
        chord{adjustments: [natural, natural, natural], 
                            degrees: [1, 3, 5], 
                            pattern: [0, 2, 4, 5, 7, 9, 11], 
                            root: note{
                                    accidental: natural, 
                                    name: c, 
                                    octave: 4
                                }
                            },
        chord{adjustments: [natural, natural, natural],
                            degrees: [1, 3, 5],
                            pattern: [0, 2, 4, 5, 7, 9, 11],
                            root: note{
                                    accidental: natural,
                                    name: f,
                                    octave: 4
                                }
                            },
        chord{adjustments: [natural, natural, natural],
                            degrees: [1, 3, 5],
                            pattern: [0, 2, 4, 5, 7, 9, 11],
                            root: note{
                                    accidental: natural,
                                    name: a,
                                    octave: 5
                                }
                            },
        chord{adjustments: [natural, natural, natural],
                            degrees: [1, 3, 5],
                            pattern: [0, 2, 4, 5, 7, 9, 11],
                            root: note{
                                    accidental: natural,
                                    name: g,
                                    octave: 4
                                }
                            }
    ]).

:- end_tests(chord_progressions).


:- begin_tests(the_angry_man).

test(top_left_low_e1) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2}%,
        % note{name: f, accidental: natural, octave: 4},
        % note{name: f, accidental: sharp, octave: 4},
        % note{name: g, accidental: natural, octave: 4},
        % note{name: g, accidental: sharp, octave: 4},
        % note{name: d, accidental: natural, octave: 4},
        % note{name: d, accidental: sharp, octave: 4},
        % note{name: c, accidental: sharp, octave: 4},
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e2) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3}%,
        % note{name: f, accidental: sharp, octave: 4},
        % note{name: g, accidental: natural, octave: 4},
        % note{name: g, accidental: sharp, octave: 4},
        % note{name: d, accidental: natural, octave: 4},
        % note{name: d, accidental: sharp, octave: 4},
        % note{name: c, accidental: sharp, octave: 4},
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e3) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3},
        note{name: f, accidental: sharp, octave: 4}%,
        % note{name: g, accidental: natural, octave: 4},
        % note{name: g, accidental: sharp, octave: 4},
        % note{name: d, accidental: natural, octave: 4},
        % note{name: d, accidental: sharp, octave: 4},
        % note{name: c, accidental: sharp, octave: 4},
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e4) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 3}%,
        % note{name: g, accidental: sharp, octave: 4},
        % note{name: d, accidental: natural, octave: 4},
        % note{name: d, accidental: sharp, octave: 4},
        % note{name: c, accidental: sharp, octave: 4},
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e5) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 3},
        note{name: g, accidental: sharp, octave: 4}%,
        % note{name: d, accidental: natural, octave: 4},
        % note{name: d, accidental: sharp, octave: 4},
        % note{name: c, accidental: sharp, octave: 4},
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e6) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 3},
        note{name: g, accidental: sharp, octave: 4},
        note{name: d, accidental: natural, octave: 4}%,
        % note{name: d, accidental: sharp, octave: 4},
        % note{name: c, accidental: sharp, octave: 4},
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e7) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 3},
        note{name: g, accidental: sharp, octave: 4},
        note{name: d, accidental: natural, octave: 4},
        note{name: d, accidental: sharp, octave: 3}%,
        % note{name: c, accidental: sharp, octave: 4},
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e8) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 3},
        note{name: g, accidental: sharp, octave: 4},
        note{name: d, accidental: natural, octave: 4},
        note{name: d, accidental: sharp, octave: 3},
        note{name: c, accidental: sharp, octave: 4}%,
        % note{name: c, accidental: natural, octave: 4},
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e9) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 2},
        note{name: f, accidental: natural, octave: 3},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 3},
        note{name: g, accidental: sharp, octave: 4},
        note{name: d, accidental: natural, octave: 4},
        note{name: d, accidental: sharp, octave: 3},
        note{name: c, accidental: sharp, octave: 4},
        note{name: c, accidental: natural, octave: 5}%,
        % note{name: b, accidental: natural, octave: 4},
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e10) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 4},
        note{name: f, accidental: natural, octave: 4},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 4},
        note{name: g, accidental: sharp, octave: 4},
        note{name: d, accidental: natural, octave: 4},
        note{name: d, accidental: sharp, octave: 4},
        note{name: c, accidental: sharp, octave: 4},
        note{name: c, accidental: natural, octave: 4},
        note{name: b, accidental: natural, octave: 4}%,
        % note{name: a, accidental: sharp, octave: 4},
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e11) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 4},
        note{name: f, accidental: natural, octave: 4},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 4},
        note{name: g, accidental: sharp, octave: 4},
        note{name: d, accidental: natural, octave: 4},
        note{name: d, accidental: sharp, octave: 4},
        note{name: c, accidental: sharp, octave: 4},
        note{name: c, accidental: natural, octave: 4},
        note{name: b, accidental: natural, octave: 4},
        note{name: a, accidental: sharp, octave: 4}%,
        % note{name: a, accidental: natural, octave: 4}
    ]).
test(top_left_low_e12) :- 
    angry_man_row([
        note{name: e, accidental: natural, octave: 4},
        note{name: f, accidental: natural, octave: 4},
        note{name: f, accidental: sharp, octave: 4},
        note{name: g, accidental: natural, octave: 4},
        note{name: g, accidental: sharp, octave: 4},
        note{name: d, accidental: natural, octave: 4},
        note{name: d, accidental: sharp, octave: 4},
        note{name: c, accidental: sharp, octave: 4},
        note{name: c, accidental: natural, octave: 4},
        note{name: b, accidental: natural, octave: 4},
        note{name: a, accidental: sharp, octave: 4},
        note{name: a, accidental: natural, octave: 4}
    ]).

:- end_tests(the_angry_man).



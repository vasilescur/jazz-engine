:- use_module(library(lambda)).
:- use_module(library(record)).

% Basics

:- record note(name:atom, accidental:atom=natural, octave:integer=4).
mk_note(Name, Note) :-
    Note = note{name: Name, accidental: natural, octave: 4}.
mk_note(Name, Accidental, Note) :-
    Note = note{name: Name, accidental: Accidental, octave: 4}.
mk_note(Name, Accidental, Octave, Note) :-
    Note = note{name: Name, accidental: Accidental, octave: Octave}.

pretty_print([]).
pretty_print([Note|Tail]) :-
    Note = note{name: Name, accidental: Accidental, octave: Octave},
    write(Name), write('_'),
    write(Accidental), write('_'),
    write(Octave),
    write(' '),
    pretty_print(Tail),
    true.

sharp(note{name: a, accidental: flat, octave: OctaveDown}, note{name: a, accidental: natural, octave: Octave}) :-
    OctaveDown is Octave-1.
sharp(note{name: a, accidental: natural, octave: Octave}, note{name: a, accidental: sharp, octave: Octave}).
sharp(note{name: a, accidental: sharp, octave: Octave}, note{name: b, accidental: natural, octave: Octave}).
sharp(note{name: b, accidental: flat, octave: Octave}, note{name: b, accidental: natural, octave: Octave}).
sharp(note{name: b, accidental: natural, octave: Octave}, note{name: c, accidental: natural, octave: Octave}).
sharp(note{name: c, accidental: natural, octave: Octave}, note{name: c, accidental: sharp, octave: Octave}).
sharp(note{name: c, accidental: sharp, octave: Octave}, note{name: d, accidental: natural, octave: Octave}).
sharp(note{name: d, accidental: flat, octave: Octave}, note{name: d, accidental: natural, octave: Octave}).
sharp(note{name: d, accidental: natural, octave: Octave}, note{name: d, accidental: sharp, octave: Octave}).
sharp(note{name: d, accidental: sharp, octave: Octave}, note{name: e, accidental: natural, octave: Octave}).
sharp(note{name: e, accidental: flat, octave: Octave}, note{name: e, accidental: natural, octave: Octave}).
sharp(note{name: e, accidental: natural, octave: Octave}, note{name: f, accidental: natural, octave: Octave}).
sharp(note{name: f, accidental: natural, octave: Octave}, note{name: f, accidental: sharp, octave: Octave}).
sharp(note{name: f, accidental: sharp, octave: Octave}, note{name: g, accidental: natural, octave: Octave}).
sharp(note{name: g, accidental: flat, octave: Octave}, note{name: g, accidental: natural, octave: Octave}).
sharp(note{name: g, accidental: natural, octave: Octave}, note{name: g, accidental: sharp, octave: Octave}).
sharp(note{name: g, accidental: sharp, octave: Octave}, note{name: a, accidental: flat, octave: OctaveUp}) :-
    OctaveUp is Octave+1.

flat(X, Y) :- sharp(Y, X).

enharmonic(X, Y) :-
    X = note{name: Name, accidental: Accidental, octave: Octave},
    Y = note{name: Name, accidental: Accidental, octave: Octave}.

% Octave rollover (down)
enharmonic(X, Y) :-
    X = note{name: a, accidental: flat, octave: Octave},
    OctaveMinusOne is Octave-1,
    Y = note{name: g, accidental: sharp, octave: OctaveMinusOne}.

% Same octave
enharmonic(X, Y) :- 
    X = note{name: a, accidental: sharp, octave: Octave},
    Y = note{name: b, accidental: flat, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: b, accidental: flat, octave: Octave},
    Y = note{name: a, accidental: sharp, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: b, accidental: sharp, octave: Octave},
    Y = note{name: c, accidental: natural, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: c, accidental: flat, octave: Octave},
    Y = note{name: b, accidental: natural, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: c, accidental: sharp, octave: Octave},
    Y = note{name: d, accidental: flat, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: d, accidental: flat, octave: Octave},
    Y = note{name: c, accidental: sharp, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: d, accidental: sharp, octave: Octave},
    Y = note{name: e, accidental: flat, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: e, accidental: flat, octave: Octave},
    Y = note{name: d, accidental: sharp, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: e, accidental: sharp, octave: Octave},
    Y = note{name: f, accidental: natural, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: f, accidental: flat, octave: Octave},
    Y = note{name: e, accidental: natural, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: f, accidental: sharp, octave: Octave},
    Y = note{name: g, accidental: flat, octave: Octave}.
enharmonic(X, Y) :-
    X = note{name: g, accidental: flat, octave: Octave},
    Y = note{name: f, accidental: sharp, octave: Octave}.

% Octave rollover (up)
enharmonic(X, Y) :-
    X = note{name: g, accidental: sharp, octave: Octave},
    OctavePlusOne is Octave+1,
    Y = note{name: a, accidental: flat, octave: OctavePlusOne}.

% Intervals

% Turn any flats into the enharmonic sharp (or natural).
sharpify_flats(OrigNote, NormNote) :-
    OrigNote = note{name: _, accidental: _, octave: _},
    NormNote = note{name: _, accidental: NormAccidental, octave: _},
    enharmonic(OrigNote, NormNote),
    member(NormAccidental, [natural, sharp]).


% Compute a list of all notes in all octaves and find the distance between the given notes in that list.
% We hard-code one octave becuase we don't want to deal with enharmonics.
mk_note_list_octave(OctaveNumber, OctaveNotes) :-
    OctaveNotes = [
        note{name: a, accidental: natural, octave: OctaveNumber},
        note{name: a, accidental: sharp, octave: OctaveNumber},
        note{name: b, accidental: natural, octave: OctaveNumber},
        note{name: c, accidental: natural, octave: OctaveNumber},
        note{name: c, accidental: sharp, octave: OctaveNumber},
        note{name: d, accidental: natural, octave: OctaveNumber},
        note{name: d, accidental: sharp, octave: OctaveNumber},
        note{name: e, accidental: natural, octave: OctaveNumber},
        note{name: f, accidental: natural, octave: OctaveNumber},
        note{name: f, accidental: sharp, octave: OctaveNumber},
        note{name: g, accidental: natural, octave: OctaveNumber},
        note{name: g, accidental: sharp, octave: OctaveNumber}
    ].

% Append the helper result above for octaves 0-7
mk_note_list(Notes) :-
    mk_note_list_octave(0, Octave0),
    mk_note_list_octave(1, Octave1),
    mk_note_list_octave(2, Octave2),
    mk_note_list_octave(3, Octave3),
    mk_note_list_octave(4, Octave4),
    mk_note_list_octave(5, Octave5),
    mk_note_list_octave(6, Octave6),
    mk_note_list_octave(7, Octave7),
    append([Octave0, Octave1, Octave2, Octave3, Octave4, Octave5, Octave6, Octave7], Notes).

interval(First, Second, Semitones) :-
    mk_note_list(Notes),

    sharpify_flats(First, FirstNorm),
    sharpify_flats(Second, SecondNorm),

    nth0(IndexFirst, Notes, FirstNorm),
    nth0(IndexSecond, Notes, SecondNorm),
    Semitones is IndexSecond - IndexFirst,
    Semitones >= 0,

    !; % Cut because: if already found an interval, eliminate choice point. 
       % If not, check the backwards interval.
    interval(Second, First, Semitones).

interval_name(0, unison).
interval_name(1, minor_second).
interval_name(2, major_second).
interval_name(3, minor_third).
interval_name(4, major_third).
interval_name(5, perfect_fourth).
interval_name(6, tritone).
interval_name(6, augmented_fourth).
interval_name(6, diminished_fifth).
interval_name(7, perfect_fifth).
interval_name(8, minor_sixth).
interval_name(9, major_sixth).
interval_name(10, minor_seventh).
interval_name(11, major_seventh).
interval_name(12, octave).

% Patterns and Scales

% read as: How many semitones above the tonic is each scale degree? (Indexed by 1)
    % scale degrees: 1  2  3  4  5  6   7
major_scale_pattern([0, 2, 4, 5, 7, 9, 11]).
minor_scale_pattern([0, 2, 3, 5, 7, 8, 10]).

scale_degree(Tonic, Pattern, Degree, Note) :-
    nth1(Degree, Pattern, Interval),
    interval(Tonic, Note, Interval).

major_scale_degree(Tonic, Degree, Note) :-
    major_scale_pattern(Pattern),
    scale_degree(Tonic, Pattern, Degree, Note).

betweenToList(X,X,[X]) :- !.
betweenToList(X,Y,[X|Xs]) :-
    X =< Y,
    Z is X+1,
    betweenToList(Z,Y,Xs).

scale(Tonic, Pattern, Notes) :-
    betweenToList(1,7,Degrees),   % generates list of intervals above tonic, by scale degree
    maplist(\Degree^Note^(
        scale_degree(Tonic, Pattern, Degree, Note)
    ), Degrees, Notes).

major_scale(Tonic, Notes) :- 
    major_scale_pattern(Pattern),
    scale(Tonic, Pattern, Notes).

minor_scale(Tonic, Notes) :-
    minor_scale_pattern(Pattern),
    scale(Tonic, Pattern, Notes).


% Chords

% Adjustments are based on the given scale pattern, not the major scale pattern.
% Ex a major pattern with a degree of 3 will be a major third.
% To get a minor chord, either change to a minor pattern (with natural adjustments),
% or change the adjustment of the third to flat (keeping the major pattern).
:- record chord(root:note, pattern:list, degrees:list, adjustments:list).

major_chord(Root, Pattern, Chord) :-
    major_scale_pattern(Pattern),
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 3, 5], adjustments: [natural, natural, natural]}.

minor_chord(Root, Pattern, Chord) :-
    minor_scale_pattern(Pattern),
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 3, 5], adjustments: [natural, natural, natural]}.

% Equivalent to:                                                                              
% minor_chord(Root, Pattern, Chord) :-                         |-------- flat 3 = minor ------|
%     major_scale_pattern(Pattern),     <--- major             v                              v
%     Chord = chord{root: Root, pattern: Pattern, degrees: [1, 3, 5], adjustments: [natural, flat, natural]}.

% The adjustment pattern here is natural, natural, flat-- even though diminished chords have a flat 3.
% This is because the pattern is minor and the 3rd is already flat, so the adjustment is natural. 
diminished_chord(Root, Pattern, Chord) :-
    minor_scale_pattern(Pattern),
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 3, 5], adjustments: [natural, natural, flat]}.

augmented_chord(Root, Pattern, Chord) :-
    major_scale_pattern(Pattern),
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 3, 5], adjustments: [natural, natural, sharp]}.

major_minor_major_7_chord(Root, Pattern, Chord) :-
    major_scale_pattern(Pattern),
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 3, 5, 7], adjustments: [natural, natural, natural, natural]}.

sus2_chord(Root, Pattern, Chord) :-
    major_scale_pattern(Pattern),
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 2, 5], adjustments: [natural, natural, natural]}.

sus4_chord(Root, Pattern, Chord) :-
    major_scale_pattern(Pattern),
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 4, 5], adjustments: [natural, natural, natural]}.

nine_sus4_chord(Root, Pattern, Chord) :-
    major_scale_pattern(Pattern),                               % Have to use 2 because 9 is out of range-- only 7 scale degrees.
    Chord = chord{root: Root, pattern: Pattern, degrees: [1, 4, 5, 2], adjustments: [natural, natural, natural, natural]}.


adjusted_note(Note, natural, AdjustedNote) :- AdjustedNote = Note.
adjusted_note(Note, sharp, AdjustedNote) :- sharp(Note, AdjustedNote).
adjusted_note(Note, flat, AdjustedNote) :- flat(Note, AdjustedNote).

chord_notes(Chord, Notes) :-
    Chord = chord{root: Root, pattern: Pattern, degrees: Degrees, adjustments: Adjustments},
    length(Degrees, DegreesLength),
    
    betweenToList(1,DegreesLength,Indices),
    maplist(\Index^Degree^Adjustment^AdjustedNote^(
        nth1(Degree, Pattern, Interval),
        interval(Root, Note, Interval),

        nth1(Index, Adjustments, Adjustment),
        adjusted_note(Note, Adjustment, AdjustedNote)
    ), Indices, Degrees, Adjustments, Notes).


% Chord Progressions
chord_progression(Tonic, Pattern, Degrees, Chords) :-
    maplist(\Degree^Chord^(
        nth1(Degree, Pattern, Interval),
        interval(Tonic, Note, Interval),
        major_chord(Note, Pattern, Chord)
    ), Degrees, Chords).


% % Guitar

% voicing([], _, [], []).
% voicing([_|Tuning], Frets, Quality, Voicing) :-
%     voicing(Tuning, Frets, Quality, Voicing).
% voicing([[String,Open]|Tuning], Frets, Quality, [[String,Fret]|Voicing]) :-
%     between(0,Frets,Fret),
%     Pitch is (Open + Fret) mod 12,
%     member(Pitch, Quality),
%     subtract(Quality, [Pitch], RemainingQuality),
%     voicing(Tuning, Frets, RemainingQuality, Voicing).

% voicing(Quality, Voicing) :-
%   voicing([[0,40], [1,45], [2,50], [3,55], [4,59], [5,64]],
%           8,
%           Quality,
%           Voicing). 


% test :-
%     interval(
%         note{name: c, accidental: natural, octave: 4}, 
%         note{name: d, accidental: flat, octave: 4}, 
%         Interval
%     ),
%     interval_name(Interval, IntervalName).

:- ensure_loaded(music).

% 12-Tone Rows

% A 12-tone row is a list of 12 notes where each tone only appears once.

tone_row_mk_12_unbound_notes(Notes) :-
    Notes = [
        note{name: a, accidental: natural, octave: _},
        note{name: a, accidental: sharp, octave: _},
        note{name: b, accidental: natural, octave: _},
        note{name: c, accidental: natural, octave: _},
        note{name: c, accidental: sharp, octave: _},
        note{name: d, accidental: natural, octave: _},
        note{name: d, accidental: sharp, octave: _},
        note{name: e, accidental: natural, octave: _},
        note{name: f, accidental: natural, octave: _},
        note{name: f, accidental: sharp, octave: _},
        note{name: g, accidental: natural, octave: _},
        note{name: g, accidental: sharp, octave: _}
    ].


tone_row(Notes) :-
    tone_row_mk_12_unbound_notes(TwelveUnboundNotes),
    permutation(TwelveUnboundNotes, PermutedNotes),
    Notes = PermutedNotes.


intervals_of_row([], []).
intervals_of_row([SingleNote], []).
intervals_of_row([FirstNote, SecondNote|Tail], [Interval|Intervals]) :-
    interval(FirstNote, SecondNote, Interval),
    intervals_of_row([SecondNote|Tail], Intervals).


unique_tones(Notes) :- 
    % unique_tones is true if no (name, accidental) collisions appear
    maplist(\Note^NameAccidental^(
        Note = note{name: Name, accidental: Accidental, octave: _},
        NameAccidental = [Name, Accidental]
    ), Notes, NameAccidentals),
    sort(NameAccidentals, SortedNameAccidentals),
    length(NameAccidentals, Length),
    length(SortedNameAccidentals, Length).


angry_man_interval_names([
    minor_second,
    major_second,
    tritone,
    minor_seventh,
    major_seventh
]).

angry_man_intervals(Intervals) :- 
    angry_man_interval_names(AngryManIntervalNames),
    maplist(\IntervalName^Interval^(
        interval_name(Interval, IntervalName)
    ), AngryManIntervalNames, Intervals).

% Old implementation -- deprecated.
% angry_man_row(Notes) :-
%     tone_row(Notes),
%     unique_tones(Notes),

%     intervals_of_row(Notes, RowIntervals),
%     % Every RowIntervals entry is in angry_man_intervals
%     angry_man_intervals(AngryManIntervals),
%     maplist(\RowInterval^(
%         member(RowInterval, AngryManIntervals)
%     ), RowIntervals).


angry_man_next_note([], Note) :-
    % Any note can be a starting point
    is_guitar_playable(Note).

angry_man_next_note([FirstNote], SecondNote) :- 
    % Match any note that is an Angry Man interval away
    angry_man_intervals(AngryManIntervals),
    member(Interval, AngryManIntervals),
    interval(FirstNote, SecondNote, Interval).

angry_man_next_note([FirstNote | Tail], NextNote) :-
    is_guitar_playable(NextNote),

    PrevNotes = [FirstNote | Tail],
    flatten([PrevNotes | NextNote], AllNotes),

    % Each tone is used only once
    unique_tones(AllNotes),

    % The previous note is one of the right distances away from this one
    last(PrevNotes, LastPrevNote),
    interval_octave_agnostic(LastPrevNote, NextNote, Interval),
    angry_man_intervals(AngryManIntervals),
    member(Interval, AngryManIntervals).


angry_man_row([]).

% General case
% angry_man_row/1 takes a list of notes and checks if it is an Angry Man row
angry_man_row(Row) :-
    reverse(Row, ReversedRow),
    angry_man_row_helper(ReversedRow).

% angry_man_row_helper/1 is a helper predicate for angry_man_row/1
% It takes a reversed list of notes and checks if it is an Angry Man row
angry_man_row_helper([Note]) :-
    % Base case: a single note is always an Angry Man row
    is_guitar_playable(Note).
angry_man_row_helper([LastNote, PenultimateNote | Tail]) :-
    % Recursive case: check if the last note fits the prefix
    is_guitar_playable(LastNote),
    angry_man_next_note([PenultimateNote], LastNote),
    angry_man_row_helper([PenultimateNote | Tail]).

% Finding all valid angry man rows
the_angry_man_helper(Row, Length) :-
    length(Row, Length),
    angry_man_row(Row).
the_angry_man(ToneRows, Length) :-
    findall(ToneRow, the_angry_man_helper(ToneRow, Length), ToneRows).


% Much faster (but incomplete?) experimental version.
%
% Regular Verify (len=4):      inferences=43211
% Experimental Verify (len=4): inferences=2218

exp_helper(Elem, Acc, Result) :-
    print(Acc), print("\n"),
    angry_man_next_note(Acc, Elem),
    append(Acc, [Elem], Result).

exp_angry_man_row(Row) :-
    foldl(exp_helper, Row, [], _).


% Old versions / implementation scraps: 

% the_angry_man_topleft(ToneRows, Length) :-
%     the_angry_man(ToneRows, Length),
%     maplist(\ToneRow^(
%         nth0(0, ToneRow, FirstNote),
%         FirstNote = note{name: e, accidental: natural, octave: 2}
%     ), ToneRows).


% the_angry_man(ToneRows) :-
    % findall(ToneRow, angry_man_row(ToneRow), ToneRows).
    % maplist(\ToneRow^(
    %     length(ToneRow, 3)
    % ), ToneRows).


% intervals_of_row([FirstNote, SecondNote|Tail], NextNote) :-
%         interval(FirstNote, SecondNote, Interval),
%         intervals_of_row([SecondNote|Tail], Intervals).
    

    % intervals_of_row(RowHead, RowHeadIntervals),

    % % Have not used this tone (note name + accidental) yet
    % % use unique_tones between the row head, prev note, and this note 
    % flatten([RowHead, PrevNote, NextNote], AllNotes),
    % unique_tones(AllNotes).

    % % Have not used this interval yet
    % \+ member(ThisInterval, RowHeadIntervals),

    % % It is an angry man interval
    % angry_man_intervals(AngryManIntervals),
    % member(ThisInterval, AngryManIntervals),

    % interval(PrevNote, NextNote, ThisInterval).
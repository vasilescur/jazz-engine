:- ensure_loaded(angry_man).

%% ==========================================================================
%% Exact verification of the Angry Man tone row count estimate.
%%
%% Uses the structure already encoded in the codebase:
%%   - angry_successor_pc/2  (the pitch-class successor graph)
%%   - guitar_note_by_pc/2   (maps pitch classes to guitar notes)
%%
%% Key insight: since interval checks are octave-agnostic and uniqueness
%% is pitch-class only, the octave choice for each note is independent:
%%
%%     Total rows = H * O
%%
%% where H = Hamiltonian paths in the 12-node pitch-class successor graph
%%   and O = product of (guitar notes per pitch class) over all 12 PCs
%% ==========================================================================

%% --- Helpers ---------------------------------------------------------------

pc_note_count(PC, Count) :-
    findall(_, guitar_note_by_pc(PC, _), Notes),
    length(Notes, Count).

octave_multiplier(O) :-
    findall(C, (between(0, 11, PC), pc_note_count(PC, C)), Counts),
    foldl([X, Acc, R]>>(R is Acc * X), Counts, 1, O).

%% --- DP for Hamiltonian paths in the pitch-class graph ---------------------

:- dynamic memo_h/3.

h(_, Mask, 1) :- Mask =:= 4095, !.
h(LastPC, Mask, Ways) :- memo_h(LastPC, Mask, Ways), !.
h(LastPC, Mask, Ways) :-
    findall(SubWays,
        (   angry_successor_pc(LastPC, NextPC),
            Bit is 1 << NextPC,
            Mask /\ Bit =:= 0,
            NewMask is Mask \/ Bit,
            h(NextPC, NewMask, SubWays)
        ), SubList),
    sum_list(SubList, Ways),
    assertz(memo_h(LastPC, Mask, Ways)).

hamiltonian_paths(H) :-
    retractall(memo_h(_, _, _)),
    findall(W,
        (   between(0, 11, StartPC),
            StartMask is 1 << StartPC,
            h(StartPC, StartMask, W)
        ), Ws),
    sum_list(Ws, H).

%% --- Full DP (with octave multiplicities) as cross-check -------------------

:- dynamic memo_full/3.

full(_, Mask, 1) :- Mask =:= 4095, !.
full(LastPC, Mask, Ways) :- memo_full(LastPC, Mask, Ways), !.
full(LastPC, Mask, Ways) :-
    findall(Contribution,
        (   angry_successor_pc(LastPC, NextPC),
            Bit is 1 << NextPC,
            Mask /\ Bit =:= 0,
            NewMask is Mask \/ Bit,
            pc_note_count(NextPC, NCount),
            full(NextPC, NewMask, SubWays),
            Contribution is NCount * SubWays
        ), Contribs),
    sum_list(Contribs, Ways),
    assertz(memo_full(LastPC, Mask, Ways)).

full_count(Total) :-
    retractall(memo_full(_, _, _)),
    findall(C,
        (   between(0, 11, StartPC),
            StartMask is 1 << StartPC,
            pc_note_count(StartPC, NCount),
            full(StartPC, StartMask, W),
            C is NCount * W
        ), Cs),
    sum_list(Cs, Total).

%% --- Estimates -------------------------------------------------------------

% README formula: Factor(i) = (45 - i*45/12) * (10 * 3.75) / 45
readme_estimate(Estimate) :-
    numlist(0, 11, Steps),
    foldl([I, Acc, R]>>(
        Factor is (45 - I * 45 / 12) * (10 * 3.75 / 45),
        R is Acc * Factor
    ), Steps, 1.0, Estimate).

% Corrected formula: uses 5 successor PCs instead of 10
corrected_estimate(Estimate) :-
    numlist(0, 11, Steps),
    foldl([I, Acc, R]>>(
        Factor is (45 - I * 45 / 12) * (5 * 3.75 / 45),
        R is Acc * Factor
    ), Steps, 1.0, Estimate).

% Corrected formula with step 0 treated specially (no interval constraint)
corrected_estimate_v2(Estimate) :-
    numlist(1, 11, Steps),
    foldl([I, Acc, R]>>(
        Factor is (45 - I * 45 / 12) * (5 * 3.75 / 45),
        R is Acc * Factor
    ), Steps, 45.0, Estimate).

%% --- Main ------------------------------------------------------------------

main :-
    format('~n~`=t~60|~n'),
    format('  Angry Man Tone Row -- Exact Count vs. Estimate~n'),
    format('~`=t~60|~n~n'),

    % --- 1. Guitar note distribution ---
    format('1. GUITAR NOTE DISTRIBUTION~n'),
    format('   (from guitar_note_by_pc/2, precomputed at load time)~n~n'),
    pc_names(PCNames),
    forall(between(0, 11, PC), (
        pc_note_count(PC, C),
        nth0(PC, PCNames, Name),
        format('   PC ~w (~w): ~w guitar notes~n', [PC, Name, C])
    )),
    nl,
    octave_multiplier(O),
    format('   Octave multiplier O = product of all = ~w~n', [O]),
    format('   Average notes/PC = 45/12 = ~4f~n~n', [3.75]),

    % --- 2. Successor graph ---
    format('2. PITCH-CLASS SUCCESSOR GRAPH~n'),
    format('   (from angry_successor_pc/2, offsets [+1,-1,+2,-2,+6])~n~n'),
    forall(between(0, 11, PC), (
        findall(S, angry_successor_pc(PC, S), Succs),
        nth0(PC, PCNames, Name),
        length(Succs, NS),
        maplist([S1,N1]>>(nth0(S1, PCNames, N1)), Succs, SuccNames),
        format('   ~w -> ~w successors: ~w~n', [Name, NS, SuccNames])
    )),
    nl,

    % --- 3. Exact count ---
    format('3. EXACT COUNT (via Hamiltonian path DP)~n~n'),
    hamiltonian_paths(H),
    format('   Hamiltonian paths in PC graph:  H = ~w~n', [H]),
    format('   Octave multiplier:              O = ~w~n', [O]),
    ExactTotal is H * O,
    format('   Exact total (H * O):                ~w~n', [ExactTotal]),

    % Cross-check
    full_count(FullTotal),
    (ExactTotal =:= FullTotal
        -> format('   Cross-check (full DP):              PASSED~n')
        ;  format('   Cross-check (full DP):              FAILED (~w)~n', [FullTotal])
    ),
    nl,

    % --- 4. Comparison with estimates ---
    format('4. COMPARISON WITH ESTIMATES~n~n'),

    readme_estimate(ReadmeEst),
    corrected_estimate(CorrEst),
    corrected_estimate_v2(CorrEstV2),
    ExactFloat is float(ExactTotal),

    ReadmeRatio is ReadmeEst / ExactFloat,
    CorrRatio is CorrEst / ExactFloat,
    CorrRatioV2 is CorrEstV2 / ExactFloat,

    format('   README estimate (10 succ PCs):   ~e  (~1fx)~n', [ReadmeEst, ReadmeRatio]),
    format('   Corrected (5 succ PCs):          ~e  (~1fx)~n', [CorrEst, CorrRatio]),
    format('   Corrected + step-0 fix:          ~e  (~1fx)~n', [CorrEstV2, CorrRatioV2]),
    format('   EXACT:                           ~e~n', [ExactFloat]),
    nl,

    % --- 5. Diagnosis ---
    format('5. DIAGNOSIS~n~n'),
    format('   The README says: "5 options up and 5 options down"~n'),
    format('   giving (5+5) * 3.75 = 37.5 valid next notes.~n~n'),
    format('   But the 5 intervals (m2, M2, tritone, m7, M7) have~n'),
    format('   semitone values {1, 2, 6, 10, 11}. Going "down" by~n'),
    format('   these intervals gives {-1, -2, -6, -10, -11} mod 12~n'),
    format('   = {11, 10, 6, 2, 1} -- the SAME set!~n~n'),
    format('   This is because:~n'),
    format('     m2 down (-1)  = M7 up (+11)~n'),
    format('     M2 down (-2)  = m7 up (+10)~n'),
    format('     tritone (-6)  = tritone (+6)~n'),
    format('     m7 down (-10) = M2 up (+2)~n'),
    format('     M7 down (-11) = m2 up (+1)~n~n'),
    format('   So each PC has 5 (not 10) unique successors.~n'),
    format('   This is confirmed by angry_successor_pc/2 above.~n~n'),
    format('   The README overestimates by a factor of ~1f.~n', [ReadmeRatio]),
    nl,

    format('~`=t~60|~n'),
    format('  RESULT: ~w exact Angry Man tone rows~n', [ExactTotal]),
    format('  (~e)~n', [ExactFloat]),
    format('~`=t~60|~n'),
    nl.

pc_names(['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']).

:- main, halt.

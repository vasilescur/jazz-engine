# jazz-engine

Prolog implementation of music theory &amp; jazz guitar.


## Usage

### Notes

The `note` record is defined as:

```prolog
record note(name:atom, accidental:atom=natural, octave:integer=4).
```

Use the `mk_note(Name, Note)`, `mk_note(Name, Accidental, Note)`, or `mk_note(Name, Accidental, Octave, Note)`
to create a new note variable. Alternatively, you can use the literal syntax:

```prolog
note{name: c, accidental: natural, octave: 4}
```

Pretty print a list of notes using `pretty_print/1`.

#### Sharps and Flats

The `sharp/2` predicate raises a note by a semitone. The `flat/2` predicate behaves in a similar way.

To normalize a note from potential flat to sharp/natural only, use `sharpify_flats/2`.

#### Enharmonics

Two notes are enharmonic if they share the same pitch. The predicate `enharmonic/2` captures this.

### Intervals

The `interval/3` predicate is defined as:

```prolog
interval(First, Second, Semitones) :- ...
```

It uses a lookup table of all notes (in sharpified form) to compute the distance between the indices of the given notes. 

Interval names are available using the `interval_name/2` predicate. 

**Example: Using `interval/3` to find the distance between notes**

Query:
```
?- mk_note(c, natural, 4, C4), 
   mk_note(e, flat, 4, E_flat), 
   interval(C4, E_flat, Semitones), 
   interval_name(Semitones, IntervalName).
```
Output:
```
C4 = note{accidental:natural, name:c, octave:4},
E_flat = note{accidental:flat, name:e, octave:4},
Semitones = 3,
IntervalName = minor_third.
```

**Example: Using `interval/3` to find the note a given distance away**

Query:
```
?- mk_note(c, Root), interval_name(Semitones, minor_third), interval(Root, SecondNote, Semitones).
```
Output:
```
Root = note{accidental:natural, name:c, octave:4},
Semitones = 3,
SecondNote = note{accidental:sharp, name:d, octave:4}.
```

### Scales

There are two important concepts in scales. 

A *pattern* is the set of intervals that makes up the scale.
For example, a major scale has the pattern "whole, whole, half, whole, whole, whole, half",
or-- expressed as semitones above the tonic, `[0, 2, 4, 5, 7, 9, 11]`.
This pattern is available as `major_scale_pattern/1`. There is also `minor_scale_pattern/1`.

A *scale degree* is an array index into a scale. The Nth scale degree in a given key is the Nth note of that scale. 
The `scale_degree/4` predicate works like this:

```prolog
scale_degree(Tonic, Pattern, Degree, Note) :-
    nth1(Degree, Pattern, Interval),
    interval(Tonic, Note, Interval).
```

The shortcut `major_scale_degree/3` is also provided, eliminating the `Pattern` argument.

The `scale/3` primitive generates degrees 1 through 7 in a given pattern, starting with a given tonic:

```prolog
scale(Tonic, Pattern, Notes) :-  % generates list of intervals above tonic, by scale degree
    betweenToList(1,7,Degrees),
    maplist(\Degree^Note^(
        scale_degree(Tonic, Pattern, Degree, Note)
    ), Degrees, Notes).
```

The shortcuts `major_scale/2` and `minor_scale/2` are also provided, eliminating the `Pattern` argument.

**Example: Generating a D major scale:**

Query:
```
?- mk_note(d, Tonic), major_scale(Tonic, Notes), pretty_print(Notes).
```

Output (manually formatted for readability; `pretty_print` result is the first line):
```
d_natural_4 e_natural_4 f_sharp_4 g_natural_4 a_natural_5 b_natural_5 c_sharp_5 
Tonic = note{accidental:natural, name:d, octave:4},
Notes = [
   note{accidental:natural, name:d, octave:4}, 
   note{accidental:natural, name:e, octave:4}, 
   note{accidental:sharp, name:f, octave:4}, 
   note{accidental:natural, name:g, octave:4}, 
   note{accidental:natural, name:a, octave:5}, 
   note{accidental:natural, name:b, octave:5}, 
   note{accidental:sharp, name:c, octave:5}
].
```

### Chords

The `chord` record type is defined as:

```prolog
:- record chord(root:note, pattern:list, degrees:list, adjustments:list).
```

`degrees` represents a list of scale degrees making up the chord, *starting from the givn `root` note of the chord as `1`*.

The `pattern` and `adjustments` arguments can be combined in flexible ways to produce different chords. 
The scale `degrees` making up the chord will be mapped onto the provided `pattern`,
so using a minor pattern with no `adjustments` will yield a minor chord. 
The `adjustments` are applied after this, and can be used to reference tones outside the key. 
For example, to represent a diminished chord, we would request scale degrees `[1, 3, 5]`, a minor pattern,
and the adjustments `[natural, natural, flat]`. This will yield a tonic (1), a minor third (m3) from the pattern, 
and a diminished fifth (b5) from the `flat` adjustment applied on the top note.

This is a very flexible system, for example it is possible to create a minor chord at least two ways:

```
chord{root: _, pattern: <minor pattern>, degrees: [1, 3, 5], adjustments: [natural, natural, natural]}
chord{root: _, pattern: <major pattern>, degrees: [1, 3, 5], adjustments: [natural, flat, natural]}
```

#### Available Chord Shortcuts:

- `major_chord/3`
- `minor_chord/3`
- `diminished_chord/3`
- `augmented_chord/3`
- `major_minor_major_7_chord/3`
- `sus2_chord/3`
- `sus4_chord/3`
- `nine_sus4_chord/3`

### Chord Notes

The `chord_notes/2` primitive converts between a chord and a set of notes.

**Example: Building a chord with `major_chord/2` and getting the notes with `chord_notes/2`:**

Query:
```
?- mk_note(c, Root), major_chord(C, Chord), chord_notes(Chord, Notes), pretty_print(Notes).
```

Output (manually formatted for readability) -- the `pretty_print` is the first line:
```
c_natural_4 e_natural_4 g_natural_4 
Root = note{accidental:natural, name:c, octave:4},
Chord = chord{adjustments:[natural, natural, natural], 
              degrees:[1, 3, 5], 
              pattern:[0, 2, 4, 5, 7, 9, 11], 
              root:note{accidental:natural, name:c, octave:4}},
Notes = [note{accidental:natural, name:c, octave:4}, 
         note{accidental:natural, name:e, octave:4}, 
         note{accidental:natural, name:g, octave:4}] .
```


### Chord Progressions

The `chord_progression/4` predicate has the signature:

```prolog
chord_progression(Tonic, Pattern, Degrees, Chords)
```

**Example: Creating a I-vi-ii-V chord progression in G:**

Query:
```
?- mk_note(g, Tonic), major_scale_pattern(Pattern), chord_progression(Tonic, Pattern, [1, 6, 2, 5], Chords).
```

Output (manually formatted for readability):
```
Tonic = note{accidental:natural, name:g, octave:4},
Pattern = [0, 2, 4, 5, 7, 9, 11],
Chords = [
   chord{adjustments:[natural, natural, natural], 
         degrees:[1, 3, 5], 
         pattern:[0, 2, 4, 5, 7, 9, 11], 
         root:note{accidental:natural, name:g, 
         octave:4}}, 
   chord{adjustments:[natural, natural, natural], 
         degrees:[1, 3, 5], 
         pattern:[0, 2, 4, 5, 7, 9|...], 
         root:note{accidental:natural, name:e, 
         octave:5}}, 
   chord{adjustments:[natural, natural, natural], 
         degrees:[1, 3, 5], 
         pattern:[0, 2, 4, 5, 7|...], 
         root:note{accidental:natural, 
         name:a, 
         octave:5}}, 
   chord{adjustments:[natural, natural, natural], 
         degrees:[1, 3, 5], 
         pattern:[0, 2, 4, 5|...], 
         root:note{accidental:natural, 
         name:d, 
         octave:5}}
].
```

## Future Scope / Roadmap

- [x] Notes
- [x] Enharmonics
- [ ] Intervals-- Needs debugging (ex. cannot find the SecondNote going down)
- [x] Scales
- [x] Basic chords
- [x] Basic chord notes
- [ ] Chord inversions
- [x] Basic chord progressions
- [ ] Chord progression voicing
- [ ] 4-part harmony rules
- [ ] (WIP, commented in source) Guitar fretboard note mapping
- [ ] Guitar finger schedule rules
- [ ] Piano finger schedule rules


## Testing

Run unit test suite:

```bash
swipl -g run_tests -t halt test_music.pl
```

## License

GPL v3.0

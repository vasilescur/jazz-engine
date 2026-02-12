\version "2.24.0"

\header {
  tagline = ##f
}

\paper {
  #(set-paper-size "a5landscape")
  indent = 0
  top-margin = 10
  bottom-margin = 10
  left-margin = 20
  right-margin = 20
}

\score {
  \new Staff {
    \clef treble
    \key g \major
    \time 4/4
    <g' b' d''>1^\markup { \column { \bold "G" \small "I" } }
    <e' g' b'>1^\markup { \column { \bold "Em" \small "vi" } }
    <a' c'' e''>1^\markup { \column { \bold "Am" \small "ii" } }
    <d' fis' a'>1^\markup { \column { \bold "D" \small "V" } }
    \bar "|."
  }
  \layout { }
  \midi {
    \tempo 4 = 280
  }
}

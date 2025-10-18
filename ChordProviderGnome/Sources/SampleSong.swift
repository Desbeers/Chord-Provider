//
//  SampleSong.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The empty song
let emptySong = """
{title New Song}
{artist New Artist}

"""

/// The sample song
let sampleSong = """
# Example of a simple ChordPro song.

{title New Song}
{artist New Artist}
{tag Help Document}

{start_of_textblock}
Welcome to the <i>sneak preview</i> of <b>Chord Provider</b> for <b>Gnome</b>!
{comment All bugs are for free!}
{end_of_textblock}

# STRUM PATTERNS:
# "u": .up,
# "up": .up,
# "ua": .accentedUp,
# "um": .mutedUp,
# "us": .slowUp,
# "d": .down,
# "dn": .down,
# "da": .accentedDown,
# "dm": .mutedDown,
# "ds": .slowDown,
# "x": .palmMute,
# ".": .none
{start_of_strum label="Strum Me!" tuplet="2"}
da . ua d x d u d um dm d u d us ds u
{comment Basic strumming pattern is supported as well, see the source for the pattern}
{end_of_strum}

{start_of_chorus}
Swing [D]low, sweet [G]chari[D]ot,
Comin’ for to carry me [A7]home.
Swing [D7]low, sweet [G]chari[D]ot,
Comin’ for to [A7]carry me [D]home.
{end_of_chorus}

# Verse.
I [D]looked over Jordan, and [G]what did I [D]see,
Comin’ for to carry me [A7]home.
A [D]band of angels [G]comin’ after [D]me,
Comin’ for to [A7]carry me [D]home.

# One more chorus.
{chorus}

{start_of_tab Tab Tab Tab!}
e|-------------|
B|-------0-1-1-|
G|-2-2---1-2-2-|
D|-------------|
A|-------------|
E|-------------|
{end_of_tab}

{start_of_grid label="Griddy Grid!"}
| G7 G7 . C | Am . . Am |
| G7 G7 . C |
| Asus4 G7 . C | Am . . Am |
| G7 G7 . C | Asus4 . . Am |
{end_of_grid}

{start_of_textblock Thanks!}
Thanks to <b>adwaita-swift</b>
<span color='blue'>https://git.aparoksha.dev/aparoksha/adwaita-swift</span>
{comment Adwaita and Swift is a great combination!}
{end_of_textblock}
"""

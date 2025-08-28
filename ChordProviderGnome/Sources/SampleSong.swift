//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation

let sampleSong = """
# Example of a simple ChordPro song.

{title Swing Low Sweet Chariot}
{subtitle Traditional}

{start_of_textblock Welcome!}
Welcome to the 'sneak preview' of Chord Provider for Gnome!
Thanks to 'adwaita-swift'
https://git.aparoksha.dev/aparoksha/adwaita-swift
{comment All bugs are for free!}
{end_of_textblock}

{start_of_chorus}
Swing [D]low, sweet [G]chari[D]ot,
Comin’ for to carry me [A7]home.
Swing [D7]low, sweet [G]chari[D]ot,
Comin’ for to [A7]carry me [D]home.
{comment An inline comment}
{end_of_chorus}

{start_of_tab Tab Tab Tab!}
e|-------------|
B|-------0-1-1-|
G|-2-2---1-2-2-|
D|-------------|
A|-------------|
E|-------------|
{end_of_tab}

# Verse.
I [D]looked over Jordan, and [G]what did I [D]see,
Comin’ for to carry me [A7]home.
A [D]band of angels [G]comin’ after [D]me,
Comin’ for to [A7]carry me [D]home.

# One more chorus.
{chorus}

{comment A comment in a section}
"""

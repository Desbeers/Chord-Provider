//
//  Discussions.swift
//  chordprovider
//
//  Created by Nick Berendsen on 03/09/2025.
//

import Foundation

/// The discussion, shown in help
let configurationDiscussion: String = """
ChordPro is a simple text format for the notation of lyrics with chords.
See https://www.chordpro.org

The source code for Chord Provider is available on GitHub:
https://github.com/Desbeers/Chord-Provider

The project contains more than just this CLI version:
- GUI version for macOS written in SwiftUI
- GUI version for Linux written in Adwaita
"""

/// The discussion shown for output
let outputDiscussion: String = """
If no output file is provided:
- The output will be next to the song if a file path is given as source.
- If the source is just a string the result will be printed to stdout.
"""

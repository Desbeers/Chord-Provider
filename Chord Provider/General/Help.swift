//
//  Help.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

// swiftlint:disable all

/// Static help strings
enum Help {

    /// Static help message for the folder selector
    static let musicPath =
"""
If you add a **'musicpath'**  *directive* to your ChordPro file, **Chord Provider** can play the song if it knows where to look for it. The song has to be in the same folder as your ChordPro file and within the selected folder.
"""
    /// Static help message for the file browser
    static let fileBrowser =
"""
If you select a folder, **Your Songs** will show your all the songs found in that folder and it subfolders and is searchable.
"""
}

// swiftlint:enable all

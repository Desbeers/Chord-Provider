//
//  Help.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

// swiftlint:disable all

enum Help {

    /// Static help message for the folder selector
    static let folderSelector =
"""
If you add a **'musicpath'**  *directive* to your ChordPro file, Chord Provider can play the song if it knows where to look for it. The song has to be in the same folder as your ChordPro file.

For that reason, **Chord Provider** would like to know where to find your songs. Due to Apple's safety restrictions, you have to give permission to look for it.
"""
    /// Static help message for the file browser
    static let fileBrowser =
"""
If you have selected a folder, this welcome message will be replaced with a list of your songs and is searchable.
"""

    /// Static help message for the file browser in the setting for macOS
    static let macOSbrowser =
"""
If you have selected a folder, the *Song List* will show your songs and is selectable and searchable.
"""
}

// swiftlint:enable all

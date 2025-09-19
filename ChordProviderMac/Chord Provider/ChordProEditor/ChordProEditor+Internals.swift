//
//  ChordProEditor+Internals.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension ChordProEditor {

    /// Share internal editor stuff with the SwiftUI `View`
    struct Internals: Sendable {
        /// The current line of the cursor
        var currentLine = Song.Section.Line()
        /// The range of the current paragraph
        var currentLineRange: NSRange?
        /// Bool if the directive is double-clicked
        var clickedDirective: Bool = false
        /// The currently selected range
        var selectedRange = NSRange()
        /// The ``textView``
        weak var textView: TextView?
    }
}

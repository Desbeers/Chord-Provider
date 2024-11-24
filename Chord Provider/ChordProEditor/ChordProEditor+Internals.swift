//
//  ChordProEditor+Internals.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProEditor {

    /// Share internal editor stuff with the SwiftUI `View`
    struct Internals: Sendable {
        /// The current line of the cursor
        var currentLine = Song.Section.Line()
        /// The optional directive argument in the current paragraph
        var directiveArgument: String = ""
        /// The range of the current paragraph
        var currentLineRange: NSRange?
        /// Bool if the directive is double-clicked
        var clickedDirective: Bool = false
        /// The currently selected range
        var selectedRange = NSRange()
        /// The ``textView``
        var textView: TextView?
    }
}

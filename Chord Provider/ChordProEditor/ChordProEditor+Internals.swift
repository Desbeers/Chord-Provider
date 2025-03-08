//
//  ChordProEditor+Internals.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProEditor {

    /// Share internal editor stuff with the SwiftUI `View`
    struct Internals: Sendable {
        /// The current line of the cursor
        var currentLine = Song.Section.Line()
        /// The optional directive arguments in the current paragraph
        var directiveArguments = ChordProParser.Arguments()
        /// All arguments as a single string
        var directiveArgument: String = ""
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

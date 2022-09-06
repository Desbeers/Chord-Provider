//
//  EditorController.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//
// Many thanks for https://github.com/dbarsamian/conscriptor

import Foundation
import AppKit

struct EditorController {
    /// Iterates over all selected ranges in a `textView`, applying  a `style`
    /// - Parameters:
    ///     - document: The `ConscriptorDocument` to update
    ///     - style: The `MarkdownFormatter.Formatting` style to apply or remove
    ///     - textView: The `NSTextView` to update
    public static func format(
        _ document: inout ChordProDocument,
        with style: ChordProFormatter.Formatting,
        in textView: NSTextView?
    ) {
        guard let textView = textView else {
            return
        }
        let ranges = textView.selectedRanges.map { $0.rangeValue }
        for range in ranges {
            let selection = document.text[Range(range)!]
            let replacement = ChordProFormatter.format(selection, style: style)
            textView.insertText(replacement, replacementRange: range)
        }
        document.text = textView.string
    }
}

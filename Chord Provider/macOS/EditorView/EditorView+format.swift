//
//  EditorView+format.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import AppKit

extension EditorView {

    /// Apply  a `directive` to the (optional) selected range in the `NSTextView`
    /// - Parameters:
    ///     - document: The `ChordProDocument` to update
    ///     - directive: The ``Directive`` to apply
    ///     - textView: The `NSTextView` to update
    static func format(
        _ document: inout ChordProDocument,
        directive: Directive,
        selection: NSRange,
        in textView: NSTextView?
    ) {
        /// Make sure we have a NSTextView and the selection can be converted to a Swift Range
        guard let textView = textView, let range = Range(selection, in: document.text) else {
            return
        }
        let selectedText = document.text[range]
        let replacementText = format(String(selectedText), directive: directive)
        document.text.replaceSubrange(range, with: replacementText)
        /// Move the cursor
        if selectedText.isEmpty {
            textView.setSelectedRange(NSRange(location: selection.location + directive.format.start.count, length: 0))
        } else {
            switch directive.kind {
            case .block:
                textView.setSelectedRange(NSRange(location: selection.location + replacementText.count, length: 0))
            case .inline:
                textView.setSelectedRange(NSRange(location: selection.location + replacementText.count + 1, length: 0))
            }
        }
    }

    /// Returns a string that has been reformatted based on the given ChordPro format.
    /// - Parameter string: The string to format.
    /// - Parameter directive: The ``Directive`` to apply
    private static func format(_ string: String, directive: Directive) -> String {
        var formattedString = string
        formattedString.insert(contentsOf: directive.format.start, at: formattedString.startIndex)
        formattedString.append(directive.format.end)
        return formattedString
    }
}

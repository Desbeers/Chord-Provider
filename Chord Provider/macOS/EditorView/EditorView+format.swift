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
    ///     - directive: The `Directive` to apply
    ///     - textView: The `NSTextView` to update
    @MainActor static func format(
        _ document: inout ChordProDocument,
        directive: ChordPro.Directive,
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
        var location = selection.location
        switch directive.kind {
        case .block:
            location += selectedText.isEmpty ? directive.format.start.count : replacementText.count
        case .inline:
            location += selectedText.isEmpty ? directive.format.start.count : replacementText.count
        case .optionalLabel:
            location = selection.location + replacementText.count
        }
        textView.setSelectedRange(NSRange(location: location, length: 0))
    }

    /// Returns a string that has been reformatted based on the given ChordPro format.
    /// - Parameter string: The string to format.
    /// - Parameter directive: The ``Directive`` to apply
    private static func format(_ string: String, directive: ChordPro.Directive) -> String {

        var formattedString = string

        var startOfFormat = directive.format.start

        if directive.kind == .optionalLabel && !string.isEmpty {
            startOfFormat += ": "
        }

        formattedString.insert(contentsOf: startOfFormat, at: formattedString.startIndex)
        formattedString.append(directive.format.end)
        return formattedString
    }
}

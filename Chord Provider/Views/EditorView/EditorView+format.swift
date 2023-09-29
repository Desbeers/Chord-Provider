//
//  EditorView+format.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

extension EditorView {

    /// Apply  a `directive` to the (optional) selected range in the `NSTextView`
    /// - Parameters:
    ///     - document: The `ChordProDocument` to update
    ///     - directive: The `Directive` to apply
    ///     - textView: The `NSTextView` to update
    @MainActor
    static func format(
        document: inout ChordProDocument,
        directive: ChordPro.Directive,
        selection: NSRange,
        definition: String?,
        in textView: SWIFTTextView?
    ) {
        /// Make sure we have a NSTextView and the selection can be converted to a Swift Range
        guard let textView = textView, let range = Range(selection, in: document.text) else {
            return
        }
        let selectedText = document.text[range]

        var replacementText = format(directive: directive, argument: String(selectedText))

        /// Override the selection when the definition is not empty
        if let definition {
            replacementText = format(directive: directive, argument: definition)
        }

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
#if os(macOS)
        textView.setSelectedRange(NSRange(location: location, length: 0))
#else
        textView.selectedRange = NSRange(location: location, length: 0)
#endif
    }

    /// Format a ``ChordPro/Directive`` with its argument
    /// - Parameters:
    ///   - directive: The ``ChordPro/Directive`` to apply
    ///   - argument: The argument of the `directive`
    /// - Returns: A formatted `Directive`  as `String`
    private static func format(directive: ChordPro.Directive, argument: String) -> String {

        var formattedDirective = argument

        var startOfFormat = directive.format.start

        if directive.kind == .optionalLabel && !argument.isEmpty {
            startOfFormat += ": "
        }

        formattedDirective.insert(contentsOf: startOfFormat, at: formattedDirective.startIndex)
        formattedDirective.append(directive.format.end)
        return formattedDirective
    }
}

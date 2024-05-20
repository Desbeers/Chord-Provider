//
//  EditorView+format.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension EditorView {

    /// Apply  a `directive` in the ``ChordProEditor``
    /// - Parameters:
    ///   - settings: The settings for the directive
    ///   - editor: The connector class for the editor
    static func format(
        settings: DirectiveSettings,
        in editor: ChordProEditor.Connector
    ) {
        Task { @MainActor in
            /// Update a definition if we have a selected fragment
            /// - Note: macOS only
            if let fragment = settings.clickedFragment {
                guard
                    let paragraph = fragment.textElement as? NSTextParagraph,
                    let range = paragraph.elementRange,
                    let contentManager = paragraph.textContentManager,
                    let nsRange = NSRange(textRange: range, in: contentManager)

                else {
                    return
                }
                let updatedDirective = "{\(settings.directive.rawValue): \(settings.definition)}\n"
                editor.insertText(text: updatedDirective, range: nsRange)
            } else {
                let selectedText = editor.textView.selectedText
                var replacementText = format(directive: settings.directive, argument: String(selectedText))
                /// Replace the optional selection with the optional definition
                if !settings.definition.isEmpty {
                    replacementText = format(directive: settings.directive, argument: settings.definition)
                }
                switch editor.selection {
                case .noSelection, .singleSelection:
                    editor.insertText(text: replacementText)
                case .multipleSelections:
                    /// - Note: I don't know how to get multiple selections with TextKit 2, so this is never used for now...
                    editor.wrapTextSelections(leading: settings.directive.format.start, trailing: settings.directive.format.end)
                }
            }
        }
    }

    /// Format a ``ChordPro/Directive`` with its argument
    /// - Parameters:
    ///   - directive: The ``ChordPro/Directive`` to apply
    ///   - argument: The argument of the `directive`
    /// - Returns: A formatted `Directive`  as `String`
    static func format(directive: ChordPro.Directive, argument: String) -> String {

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

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

    /// Apply  a `directive` to the (optional) selected range in the ``ChordProEditor``
    /// - Parameters:
    ///   - directive: The `Directive` to apply
    ///   - definition: The optional definition of the directive
    ///   - editor: The editor
    static func format(
        directive: ChordPro.Directive,
        definition: String?,
        in editor: ChordProEditor.Connector
    ) {
        Task {

            let selectedText = await editor.textView.selectedText
            var replacementText = format(directive: directive, argument: String(selectedText))
            /// Override the selection when the definition is not empty
            if let definition {
                replacementText = format(directive: directive, argument: definition)
            }

            switch editor.selection {
            case .none, .single:
                await editor.insertText(text: replacementText)
            case .multiple:
                await editor.wrapTextSelections(leading: directive.format.start, trailing: directive.format.end)
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

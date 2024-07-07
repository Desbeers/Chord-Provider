//
//  Editor.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 27/06/2024.
//

import Foundation
import ChordProShared

enum Editor {
    static func format(
        directive: ChordPro.Directive,
        editorInternals: ChordProEditor.Internals
    ) {
        Task { @MainActor in
            if let textView = editorInternals.textView {
                var text = ""
                switch editorInternals.clickedDirective {
                case true:
                    text = "{\(directive.rawValue): \(editorInternals.directiveArgument)}"
                case false:
                    let selectedText = editorInternals.directiveArgument.isEmpty ? textView.selectedText : editorInternals.directiveArgument
                    text = format(directive: directive, argument: selectedText)
                }
                textView.insertText(text, replacementRange: editorInternals.directiveRange ?? textView.selectedRange())
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

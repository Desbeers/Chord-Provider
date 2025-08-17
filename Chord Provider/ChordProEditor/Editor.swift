//
//  Editor.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import ChordProviderCore

/// Static settings and functions for the editor
enum Editor {

    /// The line height multiplier for the editor text
    static let lineHeightMultiple: Double = 1.6

    /// The style of a number in the ruler
    static var rulerNumberStyle: [NSAttributedString.Key: Any] {
        let lineNumberStyle = NSMutableParagraphStyle()
        lineNumberStyle.alignment = .right
        lineNumberStyle.lineHeightMultiple = Editor.lineHeightMultiple
        var fontAttributes: [NSAttributedString.Key: Any] = [:]
        fontAttributes[NSAttributedString.Key.paragraphStyle] = lineNumberStyle
        return fontAttributes
    }

    /// The foreground of the highlighted line in the editor
    /// - Note: A `var` to keep it up-to-date when the accent color is changed
    static var highlightedForegroundColor: NSColor {
        return .controlAccentColor.withAlphaComponent(0.06)
    }

    /// The background of the highlighted line in the editor
    static let highlightedBackgroundColor: NSColor = .gray.withAlphaComponent(0.1)

    /// Edit a ``ChordPro/Directive`` with its argument in the ``ChordProEditor``
    /// - Parameters:
    ///   - directive: The ``ChordPro/Directive`` to apply
    ///   - editorInternals: The internals of the ``ChordProEditor``
    static func format(
        directive: ChordPro.Directive,
        editorInternals: ChordProEditor.Internals
    ) {
        Task { @MainActor in
            if let textView = editorInternals.textView {
                var text = ""
                let directiveArgument = ChordProParser.argumentsToString(editorInternals.currentLine) ?? ""
                switch editorInternals.clickedDirective {
                case true:
                    /// Make space for optional arguments
                    let spacer = directiveArgument.isEmpty ? "" : " "
                    text = "{\(directive.rawValue.long)\(spacer)\(directiveArgument)}"
                case false:
                    let selectedText = directiveArgument.isEmpty ?
                    textView.selectedText : directiveArgument
                    text = format(directive: directive, argument: selectedText)
                }
                textView.insertText("\(text)\n", replacementRange: editorInternals.currentLineRange ?? textView.selectedRange())
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
            startOfFormat += " "
        }

        formattedDirective.insert(contentsOf: startOfFormat, at: formattedDirective.startIndex)
        formattedDirective.append(directive.format.end)
        return formattedDirective
    }

    /// Insert text into the editor
    /// - Parameters:
    ///   - text: The text to add
    ///   - editorInternals: The internals of the editor
    static func insert(
        text: String,
        editorInternals: ChordProEditor.Internals
    ) {
        Task { @MainActor in
            if let textView = editorInternals.textView {
                textView.insertText("\(text)\n", replacementRange: editorInternals.currentLineRange ?? textView.selectedRange())
            }
        }
    }
}

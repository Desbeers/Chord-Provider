//
//  JSONUtils+highlight.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

extension JSONUtils {

    /// Highlight a JSON string
    /// - Parameters:
    ///   - code: The JSON code
    ///   - editorSettings: The settings of the editor
    /// - Returns: An attributed string
    static func highlight(code: String, editorSettings: Editor.Settings) -> AttributedString {
        var attributedString = AttributedString(code)
        let keywordsRegex = Regex {
            "\""
            Capture {
                OneOrMore(.word)
            }
            "\" :"
        }
        let matches = code.matches(of: keywordsRegex)
        for match in matches {
            let range = Range(uncheckedBounds: (match.output.1.startIndex, match.output.1.endIndex))
            let nsRange = NSRange(range, in: code)
            if let attributedRange = Range(nsRange, in: attributedString) {
                attributedString[attributedRange].foregroundColor = editorSettings.markupColor
            }
        }
        let directiveRegex = Regex {
            "{"
            Capture {
                OneOrMore(.word)
            }
            Optionally {
                ":"
            }
            Optionally {
                Capture {
                    OneOrMore(CharacterClass.anyOf("}").inverted)
                }
            }
            "}"
        }
        let directiveMatches = code.matches(of: directiveRegex)
        for match in directiveMatches {
            let (_, directive, argument) = match.output
            let range = Range(uncheckedBounds: (directive.startIndex, directive.endIndex))
            let nsRange = NSRange(range, in: code)
            if let attributedRange = Range(nsRange, in: attributedString) {
                attributedString[attributedRange].foregroundColor = editorSettings.directiveColor
            }
            if let argument {
                let range = Range(uncheckedBounds: (argument.startIndex, argument.endIndex))
                let nsRange = NSRange(range, in: code)
                if let attributedRange = Range(nsRange, in: attributedString) {
                    attributedString[attributedRange].foregroundColor = editorSettings.argumentColor
                }
            }
        }
        return attributedString
    }
}

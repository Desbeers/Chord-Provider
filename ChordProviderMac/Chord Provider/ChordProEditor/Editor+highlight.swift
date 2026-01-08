//
//  Editor+highlight.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import ChordProviderCore

extension Editor {

    /// The type of regex
    enum RegexType {
        /// Normal; only apply a color to the match
        case normal
        /// The regex for a directive that can have an argument
        case directive
    }

    // swiftlint:disable force_try

    /// The regex for chords
    static let chordRegex = try! NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]", options: .caseInsensitive)
    /// The regex for grid
    static let gridRegex = try! NSRegularExpression(pattern: "(?<=^|\\n)(\\|[^\\n]*)")
    /// The regex for directives
    static let directiveRegex = try! NSRegularExpression(
        pattern: "\\{([\\w-]+):?([^\\}\\n]+)?(?:\\}|\\n)"
    )
    /// The regex for comments
    static let commentsRegex = try! NSRegularExpression(pattern: "(?<=^|\\n)(#[^\\n]*)")
    /// The regex for markup
    static let markupRegex = try! NSRegularExpression(pattern: "<\\/?([^>]*)>")
    /// The regex for `key=value`
    static let keyValueRegex = try! NSRegularExpression(pattern: "\"\\/?([^\"]*)\"")
    /// The regex for brackets
    static let bracketsRegex = try! NSRegularExpression(pattern: "\\/?([\\[\\]\\{\\}\"\\<\\>\\|/])")
    /// The regex for new lines
    static let newLineRegex = try! NSRegularExpression(pattern: "\n", options: [])

    // swiftlint:enable force_try

    /// The highlight regex dictionary for the text editor
    /// - Parameter settings: The ``Editor/Settings`` of the ``ChordProEditor``
    /// - Returns: The highlight regex dictionary
    static func regexes(settings: Editor.Settings) -> [(regex: NSRegularExpression, color: NSColor, regexType: RegexType)] {
        return [
            (commentsRegex, settings.commentColor.nsColor, .normal),
            (directiveRegex, settings.directiveColor.nsColor, .directive),
            (markupRegex, settings.markupColor.nsColor, .normal),
            (keyValueRegex, settings.markupColor.nsColor, .normal),
            (chordRegex, settings.chordColor.nsColor, .normal),
            (gridRegex, settings.chordColor.nsColor, .normal),
            (bracketsRegex, settings.bracketColor.nsColor, .normal)
        ]
    }

    /// Highlight the text in the editor
    /// - Parameters:
    ///   - view: The `NSTextView`
    ///   - settings: The ``Editor/Settings`` of the editor
    ///   - range: The range in the text that needs highlighting
    @MainActor static func highlight(
        view: NSTextView,
        settings: Editor.Settings,
        range: NSRange
    ) {

        /// Some extra love for known directives
        guard
            let boldFont = NSFont(
                descriptor: settings.font.fontDescriptor.addingAttributes().withSymbolicTraits(.bold),
                size: settings.font.pointSize
            )
        else {
            return
        }

        let text = view.textStorage?.string ?? ""
        let regexes = Editor.regexes(settings: settings)
        /// Make all text in the default style
        view.textStorage?.setAttributes(
            [
                .foregroundColor: NSColor.textColor,
                .font: settings.font
            ],
            range: range
        )
        /// Go to all the regex definitions
        regexes.forEach { regex in
            let matches = regex.regex.matches(in: text, options: [], range: range)
            matches.forEach { match in
                if match.numberOfRanges > 1 {
                    view.textStorage?.addAttribute(
                        .foregroundColor,
                        value: regex.color,
                        range: match.range(at: 1)
                    )
                    if regex.regexType == .directive, directiveIsKnown(range: match.range(at: 1)) {
                        view.textStorage?.addAttribute(
                            .font,
                            value: boldFont,
                            range: match.range(at: 1)
                        )
                    }
                }
                if match.numberOfRanges > 2 {
                    /// There is an argument
                    view.textStorage?.addAttribute(
                        .foregroundColor,
                        value: settings.argumentColor.nsColor,
                        range: match.range(at: 2)
                    )
                }
            }
        }
        /// The attributes for the next typing
        view.typingAttributes = [
            .foregroundColor: NSColor.textColor,
            .font: settings.font
        ]
        /// Check if a found directive is known
        /// - Parameter range: The range of the directive
        /// - Returns: True or False
        func directiveIsKnown(range: NSRange) -> Bool {
            guard let swiftRange = Range(range, in: text) else {
                return false
            }
            return ChordPro.knownDirectives.contains(String(text[swiftRange]))
        }
    }
}

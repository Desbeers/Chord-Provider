//
//  ChordProEditor+highlight.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension ChordProEditor {

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
    /// The regex for directives
    static let directiveRegex = try! NSRegularExpression(pattern: "\\{(\\w+):?([^\\}\\n]+)?(?:\\}|\\n)")
    /// The regex for comments
    static let commentsRegex = try! NSRegularExpression(pattern: "(?<=^|\\n)(#[^\\n]*)")
    /// The regex for markup
    static let markupRegex = try! NSRegularExpression(pattern: "<\\/?([^>]*)>")
    /// The regex for brackets
    static let bracketsRegex = try! NSRegularExpression(pattern: "\\/?([\\[\\]\\{\\}\"\\<\\>/])")
    /// The regex for new lines
    static let newLineRegex = try! NSRegularExpression(pattern: "\n", options: [])

    // swiftlint:enable force_try

    static func regexes(settings: Settings) -> [(regex: NSRegularExpression, color: NSColor, regexType: RegexType)] {
        return [
            (commentsRegex, NSColor(settings.commentColor), .normal),
            (directiveRegex, NSColor(settings.directiveColor), .directive),
            (markupRegex, NSColor(settings.markupColor), .normal),
            (chordRegex, NSColor(settings.chordColor), .normal),
            (bracketsRegex, NSColor(settings.bracketColor), .normal)
        ]
    }

    /// Highlight the text in the editor
    /// - Parameters:
    ///   - view: The `NSTextView`
    ///   - font: The current `NSFont`
    ///   - range: The `NSRange` to highlight
    ///   - directives: The known directives
    /// - Returns: A highlighted text
    @MainActor static func highlight(
        view: NSTextView,
        settings: Settings,
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
        let regexes = ChordProEditor.regexes(settings: settings)
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
                        value: NSColor(settings.argumentColor),
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
            return ChordPro.directives.contains(String(text[swiftRange]))
        }
    }
}

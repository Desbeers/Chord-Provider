//
//  ChordProEditor+Connector+Highlight.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension ChordProEditor.Connector {

    @MainActor
    /// Highlight text containing chords or directives
    /// - Parameter fullText: True if the full text must be checked, or else only the current paragraph
    func processHighlighting(fullText: Bool) {

        let regex = ChordProEditor.Regexes()

        let text = textView.string

        let fullRange = NSRange(location: 0, length: textView.string.count)

        let composeText = textView.string as NSString
        let currentParagrapRange = fullText ? fullRange : composeText.paragraphRange(for: textView.selectedRange)

        /// Make all text in the default style
        textView.attributedStorage?.setAttributes(
            [
                .paragraphStyle: ChordProEditor.paragraphStyle,
                .foregroundColor: SWIFTColor.textColor,
                .font: baseFont
            ], range: currentParagrapRange)
        /// Brackets
        let brackets = text.ranges(of: regex.bracketRegex)
        for bracket in brackets {
            let nsRange = NSRange(range: bracket, in: text)
            if checkIntersection(nsRange) {
                textView.attributedStorage?.addAttribute(
                    .foregroundColor,
                    value: SWIFTColor(settings.bracketColor),
                    range: nsRange
                )
            }
        }
        /// Chords
        let chords = text.ranges(of: regex.chordRegex)
        for chord in chords {
            let nsRange = NSRange(range: chord, in: text, leadingOffset: 1, trailingOffset: 1)
            if checkIntersection(nsRange) {
                textView.attributedStorage?.addAttribute(
                    .foregroundColor,
                    value: SWIFTColor(settings.chordColor),
                    range: nsRange
                )
            }
        }
        /// Directives
        let directives = text.matches(of: regex.directiveRegex)
        for directive in directives {
            let nsRange = NSRange(range: directive.range, in: text, leadingOffset: 1, trailingOffset: 1)
            if checkIntersection(nsRange) {
                textView.attributedStorage?.addAttributes(
                    [
                        .foregroundColor: SWIFTColor(settings.directiveColor),
                        .definition: directive.output.1 ?? .none
                    ],
                    range: nsRange)
            }
        }
        /// The definition of a directive
        let definitions = text.ranges(of: regex.definitionRegex)
        for definition in definitions {
            let nsRange = NSRange(range: definition, in: text, leadingOffset: 1, trailingOffset: 1)
            if checkIntersection(nsRange) {
                textView.attributedStorage?.addAttribute(
                    .foregroundColor,
                    value: SWIFTColor(settings.definitionColor),
                    range: nsRange
                )
            }
        }

        /// The attributes for the next typing
        textView.typingAttributes = [
            .paragraphStyle: ChordProEditor.paragraphStyle,
            .foregroundColor: SWIFTColor.textColor,
            .font: baseFont
        ]

        /// Check if the range of a regex result is within the current paragraph
        /// - Parameter nsRange: The range of the regex result
        /// - Returns: True if it is in its range, else false
        func checkIntersection(_ nsRange: NSRange) -> Bool {
            return NSIntersectionRange(currentParagrapRange, nsRange).length != 0
        }
    }
}

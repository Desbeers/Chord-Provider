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

        guard let textView
        else { return }

        let text = textView.string

        let fullRange = NSRange(location: 0, length: textView.string.count)

        let composeText = textView.string as NSString
        let currentParagraphRange = fullText ? fullRange : composeText.paragraphRange(for: textView.selectedRange)

        /// Make all text in the default style
        textView.attributedStorage?.setAttributes(
            [
                .paragraphStyle: ChordProEditor.paragraphStyle,
                .foregroundColor: SWIFTColor.textColor,
                .font: baseFont
            ], range: currentParagraphRange)
        /// Brackets
        let brackets = text.ranges(of: ChordPro.bracketRegex)
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
        let chords = text.ranges(of: ChordPro.chordRegex)
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
        let directives = text.matches(of: ChordPro.directiveRegex)
        for directive in directives {
            var nsRange = NSRange(range: directive.range, in: text, leadingOffset: 1, trailingOffset: 1)
            nsRange.length = directive.output.1.rawValue.count
            if checkIntersection(nsRange) {
                textView.attributedStorage?.addAttributes(
                    [
                        .foregroundColor: SWIFTColor(settings.directiveColor),
                        .definition: directive.output.1
                    ],
                    range: nsRange
                )
                /// Highlight the optional definition
                guard
                    let definition = directive.output.2,
                    let directiveRange = directive.output.0.description.range(of: definition)
                else {
                    continue
                }
                let directiveNSRange = NSRange(range: directiveRange, in: directive.output.0.description)
                nsRange.location += directiveNSRange.location - 1
                nsRange.length = directiveNSRange.length
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
            return NSIntersectionRange(currentParagraphRange, nsRange).length != 0
        }
    }
}

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
        let text = textView.string

        let fullRange = NSRange(location: 0, length: textView.string.count)

        let composeText = textView.string as NSString
        let currentParagrapRange = fullText ? fullRange : composeText.paragraphRange(for: textView.selectedRange)

        /// Make all text in the default style
        textView.attributedStorage?.setAttributes(
            [
                .foregroundColor: SWIFTColor.textColor,
                .font: baseFont
            ], range: currentParagrapRange)
        /// Brackets
        let brackets = text.ranges(of: ChordProEditor.bracketRegex)
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
        let chords = text.ranges(of: ChordProEditor.chordRegex)
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
        /// Simple directives
        let directives = text.ranges(of: ChordProEditor.directiveRegex)
        for directive in directives {
            let nsRange = NSRange(range: directive, in: text, leadingOffset: 1, trailingOffset: 1)
            if checkIntersection(nsRange) {
                textView.attributedStorage?.addAttribute(
                    .foregroundColor,
                    value: SWIFTColor(settings.directiveColor),
                    range: nsRange
                )
            }
        }
        /// The definition of a directive
        let definitions = text.ranges(of: ChordProEditor.definitionRegex)
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

public extension NSRange {

    /// Convert a Range to a NSRange, optional skipping leading or trailing characters
    /// - Parameters:
    ///   - range: The range
    ///   - string: The string
    ///   - leadingOffset: The leading offset
    ///   - trailingOffset: The trailing offset
    init(
        range: Range<String.Index>,
        in string: String,
        leadingOffset: Int = 0,
        trailingOffset: Int = 0
    ) {
        let utf16 = string.utf16
        guard
            let lowerBound = range.lowerBound.samePosition(in: utf16),
            let upperBound = range.upperBound.samePosition(in: utf16)
        else {
            /// This should not happen
            // swiftlint:disable:next fatal_error_message
            fatalError()
        }
        let location = utf16.distance(from: utf16.startIndex, to: lowerBound)
        let length = utf16.distance(from: lowerBound, to: upperBound)
        self.init(location: location + leadingOffset, length: length - leadingOffset - trailingOffset)
    }
}

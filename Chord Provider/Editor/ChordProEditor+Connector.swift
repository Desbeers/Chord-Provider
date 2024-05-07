//
//  ChordProEditor+Connector.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    @Observable
    /// The connector class for the editor
    class Connector {
        /// The current `NSTextView`
        var textView: SWIFTTextView = .init()

        var settings: ChordProviderSettings.Editor {
            didSet {
                baseFont = SWIFTFont.monospacedSystemFont(ofSize: CGFloat(settings.fontSize), weight: .regular)
                Task {
                    await processHighlighting(fullText: true)
                }
            }
        }

        var baseFont: SWIFTFont

        var selectedRanges: [NSValue] = []

        var selection: ChordProEditor.Selection {
            switch selectedRanges.count {
            case 1:
                return selectedRanges.first?.rangeValue.length == 0 ? .none : .single
            default:
                return .multiple
            }
        }

        init(settings: ChordProviderSettings.Editor) {
            self.settings = settings
            self.baseFont = SWIFTFont.monospacedSystemFont(ofSize: CGFloat(settings.fontSize), weight: .regular)
        }


        @MainActor
        /// Insert text at the current cursor position, removing any optional selected text
        /// - Parameter text: The text to insert
        public func insertText(text: String) {
            guard let range = selectedRanges.first?.rangeValue
            else { return }
            #if os(macOS)
            textView.insertText(text, replacementRange: range)
            #else
            textView.insertText(text)
            #endif
        }


        @MainActor
        /// Wrap text selections
        /// - Parameters:
        ///   - leading: The leading text
        ///   - trailing: The trailing text
        public func wrapTextSelections(leading: String, trailing: String) {
            /// Go to all the ranges in reverse because `insertText` will change the ranges of the text selections
            for range in selectedRanges.reversed() {
                let selectedText = textView.string[range.rangeValue]
                let replacementText = "\(leading)\(selectedText)\(trailing)"
#if os(macOS)
                textView.insertText(replacementText, replacementRange: range.rangeValue)
#else
                textView.insertText(replacementText)
#endif
            }
        }
    }
}

extension SWIFTTextView {

    /// Get the selected text from the NSTextView
    var selectedText: String {
        #if os(macOS)
        string[selectedRange()]
        #else
        string[selectedRange]
        #endif
    }
}

extension String {

    /// Get a part of a String from the subscript
    subscript(_ range: NSRange) -> Self {
        .init(self[index(startIndex, offsetBy: range.lowerBound) ..< index(startIndex, offsetBy: range.upperBound)])
    }
}

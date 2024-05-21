//
//  ChordProEditor+Connector.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    @Observable
    @MainActor
    /// The connector class for the editor
    final class Connector: Sendable {
        /// The current `NSTextView`
        var textView: TextView?

        /// The optional current directive
        var currentDirective: ChordPro.Directive?
        /// The current fragment of the cursor
        var currentFragment: NSTextLayoutFragment?
        /// The optional clicked fragment in the editor
        var clickedFragment: NSTextLayoutFragment?

        var settings: ChordProviderSettings.Editor {
            didSet {
                baseFont = SWIFTFont.monospacedSystemFont(ofSize: CGFloat(settings.fontSize), weight: .regular)
                Task { @MainActor in
                    processHighlighting(fullText: true)
                    textView?.chordProEditorDelegate?.selectionNeedsDisplay()
                }
            }
        }

        var baseFont: SWIFTFont

        var selectedRanges: [NSValue] = []

        var selection: ChordProEditor.Selection {
            switch selectedRanges.count {
            case 1:
                return selectedRanges.first?.rangeValue.length == 0 ? .noSelection : .singleSelection
            default:
                return .multipleSelections
            }
        }

        init(settings: ChordProviderSettings.Editor) {
            self.settings = settings
            self.baseFont = SWIFTFont.monospacedSystemFont(ofSize: CGFloat(settings.fontSize), weight: .regular)
        }

        /// Insert text at the current range, removing any optional selected text
        /// - Parameter text: The text to insert
        /// - Parameter range: The optional range, or else the first selected range will be used
        @MainActor
        public func insertText(text: String, range: NSRange? = nil) {
            guard let textView
            else { return }
#if os(macOS)
            guard
                let range = range == nil ? selectedRanges.first?.rangeValue : range
            else {
                return
            }
            textView.insertText(text, replacementRange: range)
#else
            /// It seems iOS does not care about ranches
            textView.insertText(text)
#endif
        }


        @MainActor
        /// Wrap text selections
        /// - Parameters:
        ///   - leading: The leading text
        ///   - trailing: The trailing text
        public func wrapTextSelections(leading: String, trailing: String) {
            guard let textView
            else { return }
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

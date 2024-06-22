//
//  ChordProEditor+Connector.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {
    // MARK: The observable `Connector` class for the editor

    /// The observable `Connector` class for the editor
    @Observable
    @MainActor
    final class Connector: Sendable {
        /// The current `NSTextView`
        var textView: TextView?
        /// The optional current directive
        var currentDirective: ChordPro.Directive?
        /// The current fragment of the cursor
        var currentFragment: NSTextLayoutFragment?
        /// The optional clicked fragment in the editor
        var clickedFragment: NSTextLayoutFragment?
        /// The settings for the editor
        var settings: ChordProEditor.Settings {
            didSet {
                font = NSFont.monospacedSystemFont(ofSize: CGFloat(settings.fontSize), weight: .regular)
                Task {
                    processHighlighting(fullHighlight: true)
                    textView?.chordProEditorDelegate?.selectionNeedsDisplay()
                }
            }
        }
        /// The current font of the editor
        var font: NSFont
        /// The selected ranges in the editor
        var selectedRanges: [NSValue] = []
        /// The current state of selection
        var selectionState: ChordProEditor.SelectionState {
            switch selectedRanges.count {
            case 1:
                return selectedRanges.first?.rangeValue.length == 0 ? .noSelection : .singleSelection
            default:
                return .multipleSelections
            }
        }

        /// Init the `Connector` class
        /// - Parameter settings: The settings for the editor
        init(settings: ChordProEditor.Settings) {
            self.settings = settings
            self.font = NSFont.monospacedSystemFont(ofSize: CGFloat(settings.fontSize), weight: .regular)
        }

        /// Set the text of the text view, replacing whole content
        /// - Parameter text: Te text
        public func setText(text: String) {
            /// Insert the content of the document into the text view
            textView?.string = text
            /// Run the highlighter
            processHighlighting(fullHighlight: true)
        }

        /// Insert text at the current range, removing any optional selected text
        /// - Parameter text: The text to insert
        /// - Parameter range: The optional range, or else the first selected range will be used
        public func insertText(text: String, range: NSRange? = nil) {
            guard let textView
            else { return }
            guard
                let range = range == nil ? selectedRanges.first?.rangeValue : range
            else {
                return
            }
            textView.insertText(text, replacementRange: range)
        }

        /// Wrap text selections
        /// - Parameters:
        ///   - leading: The leading text
        ///   - trailing: The trailing text
        /// - Note: Not used, I don't know how to get multiple selections with TextKit 2
        public func wrapTextSelections(leading: String, trailing: String) {
            guard let textView
            else { return }
            /// Go to all the ranges in reverse because `insertText` will change the ranges of the text selections
            for range in selectedRanges.reversed() {
                let selectedText = textView.string[range.rangeValue]
                let replacementText = "\(leading)\(selectedText)\(trailing)"
                textView.insertText(replacementText, replacementRange: range.rangeValue)
            }
        }
    }
}

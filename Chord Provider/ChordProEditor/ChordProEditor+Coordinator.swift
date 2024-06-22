//
//  ChordProEditor+Coordinator.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {
    // MARK: The coordinator for the editor

    /// The coordinator for the ``ChordProEditor``
    class Coordinator: NSObject, NSTextViewDelegate {
        /// The text of the editor
        var text: Binding<String>
        /// The connector class for the editor
        var connector: ChordProEditor.Connector
        /// The optional balance string, close  a`{` or `[`
        var balance: String?
        /// Bool if the whole text must be (re)highlighed or just the current fragment
        var fullHighlight: Bool = true
        /// Debouncer for the text update
        private var task: Task<Void, Never>?

        /// Init the **coordinator**
        /// - Parameter parent: The ``ChordProEditor``
        public init(text: Binding<String>, connector: ChordProEditor.Connector) {
            self.text = text
            self.connector = connector
        }

        // MARK: Protocol Functions

        /// Protocol function to check if a text should change
        /// - Parameters:
        ///   - textView: The `NSTextView`
        ///   - affectedCharRange: The character range that is affected
        ///   - replacementString: The optional replacement string
        /// - Returns: True or false
        func textView(
            _ textView: NSTextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementString: String?
        ) -> Bool {
            balance = replacementString == "[" ? "]" : replacementString == "{" ? "}" : nil
            fullHighlight = replacementString?.count ?? 0 > 1
            return true
        }

        /// Protocol function with a notification that the text has changed
        /// - Parameter notification: The notification with the `NSTextView` as object
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView, let range = textView.selectedRanges.first?.rangeValue
            else { return }
            if let balance {
                textView.insertText(balance, replacementRange: range)
                textView.selectedRanges = [NSValue(range: range)]
                self.balance = nil
            }
            connector.processHighlighting(fullHighlight: fullHighlight)
            connector.textView?.setSelectedTextLayoutFragment(selectedRange: range)
            updateTextBinding()
        }

        /// Protocol function with a notification that the text selection has changed
        /// - Parameter notification: The notification with the `NSTextView` as object
        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView, let range = textView.selectedRanges.first?.rangeValue
            else { return }
            connector.selectedRanges = textView.selectedRanges
            connector.textView?.setSelectedTextLayoutFragment(selectedRange: range)
            connector.textView?.chordProEditorDelegate?.selectionNeedsDisplay()
        }

        /// Update the text binding with the current text from the `NSTextView
        /// - Note: With a debounce of one second to prevent too many updates
        @MainActor
        func updateTextBinding() {
            guard let textView = connector.textView
            else { return }
            self.task?.cancel()
            self.task = Task {
                do {
                    try await Task.sleep(for: .seconds(1))
                    text.wrappedValue = textView.string
                } catch { }
            }
        }
    }
}

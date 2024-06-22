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
        var highlightFullText: Bool = true
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
            return swiftTextView(replacementString: replacementString ?? "")
        }

        /// Protocol function with a notification that the text has changed
        /// - Parameter notification: The notification with the `NSTextView` as object
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView
            else { return }
            if let balance, let range = textView.selectedRanges.first?.rangeValue {
                Task { @MainActor in
                    textView.insertText(balance, replacementRange: range)
                    textView.selectedRanges = [NSValue(range: range)]
                }
                self.balance = nil
            }
            connector.processHighlighting(fullText: highlightFullText)
            swiftTextViewDidChangeSelection(selectedRanges: textView.selectedRanges)
            updateTextBinding()
        }

        /// Protocol function with a notification that the text selection has changed
        /// - Parameter notification: The notification with the `NSTextView` as object
        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView
            else { return }
            swiftTextViewDidChangeSelection(selectedRanges: textView.selectedRanges)
        }

        // MARK: Wrap Platform Functions

        /// Function the handle the protocol notification that a text should change
        /// - Parameter replacementString: The optional replacement string
        /// - Returns: True or false
        func swiftTextView(replacementString: String) -> Bool {
            balance = replacementString == "[" ? "]" : replacementString == "{" ? "}" : nil
            highlightFullText = replacementString.count > 1
            return true
        }

        /// Function the handle the protocol notification that a text selection has changed
        /// - Parameter selectedRanges: The current selected range
        @MainActor
        func swiftTextViewDidChangeSelection(selectedRanges: [NSValue]) {
            guard
                let textView = connector.textView,
                let firstSelection = selectedRanges.first?.rangeValue
            else {
                return
            }
            connector.selectedRanges = selectedRanges
            textView.setSelectedTextLayoutFragment(selectedRange: firstSelection)
            textView.chordProEditorDelegate?.selectionNeedsDisplay()
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

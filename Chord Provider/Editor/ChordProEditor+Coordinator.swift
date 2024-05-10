//
//  ChordProEditor+Coordinator.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    /// The coordinator for the ``ChordProEditor``
    class Coordinator: NSObject, SWIFTTextViewDelegate {

        var text: Binding<String>

        var connector: ChordProEditor.Connector

        var balance: String?

        var highlightFullText: Bool = true

        /// Init the **coordinator**
        /// - Parameter parent: The ``ChordProEditor``
        public init(text: Binding<String>, connector: ChordProEditor.Connector) {
            self.text = text
            self.connector = connector
        }

        // MARK: Protocol Functions

#if os(macOS)

        func textView(
            _ textView: NSTextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementString: String?
        ) -> Bool {
            balance = replacementString == "[" ? "]" : replacementString == "{" ? "}" : nil
            highlightFullText = replacementString?.count ?? 0 > 1
            return true
        }

        func textDidChange(_ notification: Notification) {
            if let balance, let range = connector.textView.selectedRanges.first?.rangeValue {
                Task { @MainActor in
                    connector.textView.insertText(balance, replacementRange: range)
                    connector.textView.selectedRanges = [NSValue(range: range)]
                }
                self.balance = nil
            }
            connector.processHighlighting(fullText: highlightFullText)
            text.wrappedValue = connector.textView.string
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView
            else { return }
            connector.selectedRanges = textView.selectedRanges
        }
#else
        func textView(
            _ textView: UITextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementText replacementString: String
        ) -> Bool {
            balance = replacementString == "[" ? "]" : replacementString == "{" ? "}" : nil
            highlightFullText = replacementString.count > 1
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            if let balance {
                Task { @MainActor in
                    let range = textView.selectedRange
                    textView.insertText(balance)
                    textView.selectedRange = range
                }
                self.balance = nil
            }
            connector.processHighlighting(fullText: highlightFullText)
            text.wrappedValue = connector.textView.text
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            connector.selectedRanges = [NSValue(range: textView.selectedRange)]
        }
#endif
    }
}

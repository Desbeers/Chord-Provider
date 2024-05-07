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
        var parent: ChordProEditor

        var balance: String?

        var highlightFullText: Bool = true

        /// Init the **coordinator**
        /// - Parameter parent: The ``ChordProEditor``
        public init(_ parent: ChordProEditor) {
            self.parent = parent
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
            if let balance, let range = parent.textView.selectedRanges.first?.rangeValue {
                Task { @MainActor in
                    parent.textView.insertText(balance, replacementRange: range)
                    parent.textView.selectedRanges = [NSValue(range: range)]
                }
                self.balance = nil
            }
            parent.connector.processHighlighting(fullText: highlightFullText)
            parent.text = parent.textView.string
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView
            else { return }
            parent.connector.selectedRanges = textView.selectedRanges
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
            parent.connector.processHighlighting(fullText: highlightFullText)
            parent.text = textView.text
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            parent.connector.selectedRanges = [NSValue(range: textView.selectedRange)]
        }
#endif
    }
}

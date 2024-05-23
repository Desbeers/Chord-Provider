//
//  ChordProEditor+Coordinator.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    /// The coordinator for the ``ChordProEditor``
    class Coordinator: NSObject, SWIFTTextViewDelegate {
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

#if os(macOS)

        func textView(
            _ textView: NSTextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementString: String?
        ) -> Bool {
            return swiftTextView(replacementString: replacementString ?? "")
        }

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

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView
            else { return }
            swiftTextViewDidChangeSelection(selectedRanges: textView.selectedRanges)
        }
#else
        func textView(
            _ textView: UITextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementText replacementString: String
        ) -> Bool {
            return swiftTextView(replacementString: replacementString)
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
            swiftTextViewDidChangeSelection(selectedRanges: textView.selectedRanges)
            updateTextBinding()
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            swiftTextViewDidChangeSelection(selectedRanges: [NSValue(range: textView.selectedRange)])
        }
#endif

        // MARK: Wrap Platform Functions

        func swiftTextView(replacementString: String) -> Bool {
            balance = replacementString == "[" ? "]" : replacementString == "{" ? "}" : nil
            highlightFullText = replacementString.count > 1
            return true
        }

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

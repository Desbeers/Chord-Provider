//
//  ChordProEditor.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `NSViewRepresentable` for the ChordPro editor
struct ChordProEditor: SWIFTViewRepresentable {

    /// The text of the ChordPro file
    @Binding var text: String
    /// The connector class for the editor
    var connector: Connector

    /// Init the **ChordProEditor**
    /// - Parameters:
    ///   - text: The text of the ChordPro file
    ///   - connector: The connector class for the editor
    init(text: Binding<String>, connector: Connector) {
        self._text = text
        self.connector = connector
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, connector: connector)
    }

    // MARK: Platform Specific

#if os(macOS)

    func makeNSView(context: Context) -> Wrapper {

        let macEditor = Wrapper()

        macEditor.textView.connector = connector
        macEditor.textView.string = text
        connector.textView = macEditor.textView

        macEditor.textView.delegate = context.coordinator
        /// Wait for next cycle and set the textview as first responder
        Task { @MainActor in
            connector.processHighlighting(fullText: true)
            macEditor.textView.selectedRanges = [NSValue(range: NSRange())]
            macEditor.textView.window?.makeFirstResponder(macEditor.textView)
        }
        return macEditor
    }

    func updateNSView(_ nsView: Wrapper, context: Context) {}

#else

    func makeUIView(context: Context) -> TextView {

        let textView = TextView()

        textView.delegate = context.coordinator
        textView.text = self.text
        textView.selectedRange = .init()
        textView.textContainerInset = .zero
        connector.textView = textView
        return textView
    }

    func updateUIView(_ view: TextView, context: Context) {}

#endif
}

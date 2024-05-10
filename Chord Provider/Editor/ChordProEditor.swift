//
//  ChordProEditor.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
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

    let macEditor = MacEditor.Wrapper()

    func makeNSView(context: Context) -> MacEditor.Wrapper {
        macEditor.textView.string = text
        macEditor.textView.selectedRanges = [NSValue(range: NSRange())]
        connector.textView = macEditor.textView
        macEditor.textView.delegate = context.coordinator
        /// Wait for next cycle and set the textview as first responder
        Task {
            macEditor.textView.window?.makeFirstResponder(macEditor.textView)
        }
        return macEditor
    }

    func updateNSView(_ nsView: MacEditor.Wrapper, context: Context) {}

#else

    let textView = UITextView()

    func makeUIView(context: Context) -> UITextView {
        textView.delegate = context.coordinator
        textView.text = self.text
        textView.selectedRange = .init()
        connector.textView = textView
        return textView
    }

    func updateUIView(_ view: UITextView, context: Context) {}

#endif
}

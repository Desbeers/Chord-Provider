//
//  MacEditorView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `NSViewRepresentable` for the ChordPro editor
struct MacEditorView: NSViewRepresentable {

    /// The text of the ChordPro file
    @Binding var text: String
    /// The observable ``Connector`` class for the editor
    var connector: Connector

    /// Init the **ChordProEditor**
    /// - Parameters:
    ///   - text: The text of the ``ChordProDocument``
    ///   - connector: The ``ChordProEditor/Connector`` class for the editor
    init(text: Binding<String>, connector: Connector) {
        self._text = text
        self.connector = connector
    }

    /// Make a `coordinator` for the ``SWIFTViewRepresentable``
    /// - Returns: A `coordinator`
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, connector: connector)
    }

    func makeNSView(context: Context) -> Wrapper {
        let macEditor = Wrapper()
        macEditor.textView.connector = connector
        connector.textView = macEditor.textView

        macEditor.textView.delegate = context.coordinator
        /// Wait for next cycle and set the textview as first responder
        Task { @MainActor in
            macEditor.textView.selectedRanges = [NSValue(range: NSRange())]
            macEditor.textView.window?.makeFirstResponder(macEditor.textView)
        }
        return macEditor
    }

    func updateNSView(_ view: Wrapper, context: Context) {
        if view.textView.string != text {
            view.textView.string = text
            connector.processHighlighting(fullHighlight: true)
        }
    }
}

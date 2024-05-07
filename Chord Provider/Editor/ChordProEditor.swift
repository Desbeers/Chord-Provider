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
        Coordinator(self)
    }

    // MARK: Platform Specific

#if os(macOS)

    let scrollView = SWIFTTextView.scrollableTextView()

    var textView: SWIFTTextView {
        scrollView.documentView as? SWIFTTextView ?? SWIFTTextView()
    }

    func makeNSView(context: Context) -> some NSView {
        textView.delegate = context.coordinator
        textView.string = self.text
        textView.allowsUndo = true
        textView.textContainerInset = NSSize(width: 10, height: 10)
        connector.textView = textView
        return scrollView
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {}

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

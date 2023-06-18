//
//  EditorView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import HighlightedTextEditor

/// SwiftUI `View` for the `HighlightedTextEditor`
struct EditorView: View {
    /// The CordPro document
    @Binding var document: ChordProDocument
    /// The actuals NSTextView
    @State private var textView: NSTextView?
    /// The selected text in the editor
    @State var selection = NSRange()
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            toolbar
            editor
        }
    }
    /// The editor
    var editor: some View {
        HighlightedTextEditor(text: $document.text, highlightRules: EditorView.rules)
        /// Below selector prevents the cursor from jumping while the SongView is updated
        /// It will also be passed to 'format' buttons
            .onSelectionChange { (range: NSRange) in
                selection = range
            }
        /// Below is needed to interact with the NSTextView
            .introspect(callback: { editor in
                if self.textView == nil {
                    Task { @MainActor in
                        self.textView = editor.textView
                    }
                }
                editor.textView.textContainerInset = NSSize(width: 10, height: 10)
            })
    }
    /// The Toolbar
    var toolbar: some View {
        HStack {
            Button(action: {
                EditorView.format(&document, directive: .chorus, selection: selection, in: textView)
            }, label: {
                Label("Chorus", systemImage: "music.note.list")
            })
            Button(action: {
                EditorView.format(&document, directive: .verse, selection: selection, in: textView)
            }, label: {
                Label("Verse", systemImage: "music.mic")
            })
            Spacer()
            Menu(
                content: {
                    Button(action: {
                        EditorView.format(&document, directive: .comment, selection: selection, in: textView)
                    }, label: {
                        Label("Add a comment...", systemImage: "cloud")
                    })
                    Button(action: {
                        EditorView.format(&document, directive: .chordDefine, selection: selection, in: textView)
                    }, label: {
                        Label("Define a chord...", systemImage: "music.note.list")
                    })
            }, label: {
                Label("More...", systemImage: "gear")
            })
            .menuStyle(.borderlessButton)
            .frame(width: 100)
        }
        .buttonStyle(EditorButton())
        .labelStyle(.titleAndIcon)
        .padding(10)
        .background(Color(nsColor: .windowBackgroundColor))
        .background(Color.primary.opacity(0.1))
        .cornerRadius(5)
        .padding(.top, 5)
        .padding(.horizontal, 5)
    }
}

extension EditorView {

    /// The style for an editor button
    struct EditorButton: ButtonStyle {
        /// Hover state of the button
        @State private var hovered = false
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(4)
                .background(hovered ? Color.primary.opacity(0.1) : Color.clear)
                .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                .onHover { isHovered in
                    self.hovered = isHovered
                }
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
                .animation(.easeInOut(duration: 0.2), value: hovered)
        }
    }
}

//
//  EditorView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` for the ``ChordProEditor``
struct EditorView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// The observable state of the scene
    @Environment(SceneStateModel.self) var sceneState
    /// Show a directive sheet
    @State var showDirectiveSheet: Bool = false
    /// The optional directive to edit
    @State var editDirective: ChordPro.Directive?
    /// The body of the `View`
    var body: some View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState = sceneState
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Divider()
                HStack {
                    directiveMenus
                }
                .padding(6)
                .frame(maxWidth: .infinity)
                .background(Color(nsColor: Editor.highlightedBackgroundColor))
                editor
            }
            SplitterView()
        }
        .background(Color(nsColor: .windowBackgroundColor))
        /// Show a sheet to add or edit a directive
        .sheet(item: $editDirective) { directive in
            DirectiveSheet(directive: directive)
        }
    }
    /// The editor
    var editor: some View {
        VStack(spacing: 0) {
            Divider()
            ChordProEditor(
                text: $document.text,
                settings: appState.settings.editor,
                lines: sceneState.song.sections.flatMap(\.lines)
            )
            .introspect { editor in
                sceneState.editorInternals = editor
            }
            .onChange(of: sceneState.editorInternals.clickedDirective) {
                if sceneState.editorInternals.clickedDirective {
                    /// Show the sheet
                    switch sceneState.editorInternals.currentLine.directive {
                    case .define, .defineGuitar, .defineGuitalele, .defineUkulele:
                        if validateChordDefinition() {
                            editDirective = sceneState.editorInternals.currentLine.directive
                        }
                    default:
                        editDirective = sceneState.editorInternals.currentLine.directive
                    }
                }
            }
            Divider()
            HStack {
                Text("Line \(sceneState.editorInternals.currentLine.sourceLineNumber)")
                if let warnings = sceneState.editorInternals.currentLine.warnings {
                    Text(warnings.map(\.message).joined(separator: ", ").fromHTML(fontSize: 10))
                        .lineLimit(1)
                }
                Spacer()
                sceneState.cleanSourceButton
                    .controlSize(.small)
            }
            .font(.caption)
            .padding(.leading)
            .padding([.vertical, .trailing], 4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

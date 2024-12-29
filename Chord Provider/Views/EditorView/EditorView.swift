//
//  EditorView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

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
        VStack(spacing: 0) {
            HStack {
                directiveMenus
            }
            .padding()
            editor
        }
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
                    case .define:
                        if validateChordDefinition() {
                            editDirective = sceneState.editorInternals.currentLine.directive
                        }
                    default:
                        editDirective = sceneState.editorInternals.currentLine.directive
                    }
                }
            }
            Divider()
            HStack(spacing: 0) {
                Text("Line \(sceneState.editorInternals.currentLine.sourceLineNumber)")
                if let warning = sceneState.editorInternals.currentLine.warning {
                    Text(.init(": \(warning.joined(separator: ", "))"))
                        .lineLimit(1)
                }
                Spacer()
                WindowVisibilityToggle(windowID: AppDelegate.WindowID.debugView.rawValue)
                    .controlSize(.small)
                sceneState.cleanSourceButton
                    .controlSize(.small)
            }
            .font(.caption)
            .padding(.leading)
            .padding([.vertical], 4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

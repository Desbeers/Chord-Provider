//
//  EditorView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the ``ChordProEditor``
@MainActor struct EditorView: View {
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
    /// Show an `Alert` if we have an error
    @State var errorAlert: AlertMessage?
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
        .errorAlert(message: $errorAlert)
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
                directives: ChordPro.Directive.allCases,
                log: sceneState.song.log
            )
            .introspect { editor in
                sceneState.editorInternals = editor
            }
            .onChange(of: sceneState.editorInternals.clickedDirective) {
                if
                    sceneState.editorInternals.clickedDirective,
                    let directive = sceneState.editorInternals.directive,
                    let enumDirective = directive as? ChordPro.Directive {
                    /// Show the sheet
                    switch enumDirective {
                    case .define:
                        if validateChordDefinition() {
                            editDirective = enumDirective
                        }
                    default:
                        editDirective = enumDirective
                    }
                }
            }
            Divider()
            HStack(spacing: 0) {
                Text("Line \(sceneState.editorInternals.currentLineNumber)")
                let logMessages = sceneState.song.log
                    .filter { $0.lineNumber == sceneState.editorInternals.currentLineNumber }
                    .map(\.message)
                    .joined(separator: ", ")
                Text(.init(logMessages.isEmpty ? " " : ": \(logMessages)"))
            }
            .font(.caption)
            .padding(.leading)
            .padding([.vertical], 4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

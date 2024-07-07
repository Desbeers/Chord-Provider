//
//  EditorView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import ChordProShared
import SwiftlyChordUtilities

/// SwiftUI `View` for the ``ChordProEditor``
@MainActor struct EditorView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The app state
    @Environment(AppState.self) var appState
    /// The scene state
    @Environment(SceneState.self) var sceneState
    /// Show a directive sheet
    @State var showDirectiveSheet: Bool = false
    /// The optional directive to edit
    @State var editDirective: ChordPro.Directive?
    /// Show an `Alert` if we have an error
    @State var errorAlert: AlertMessage?
    /// The body of the `View`
    var body: some View {
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
        /// Show a sheet when we add a new song
        .sheet(
            isPresented: $sceneState.presentTemplate,
            onDismiss: {
                /// Set the text
                sceneState.editorInternals.textView?.replaceText(text: document.text)
            },
            content: {
                TemplateView(document: $document, sceneState: sceneState)
            }
        )
    }
    /// The editor
    @MainActor var editor: some View {
        VStack {
            ChordProEditor(
                text: $document.text,
                settings: appState.settings.editor,
                directives: ChordPro.Directive.allCases
            )
            .introspect { editor in
                Task { @MainActor in
                    sceneState.editorInternals = editor
                }
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
            HStack(spacing: 0) {
                Text(.init(sceneState.editorInternals.directive?.label ?? "No directive"))
                if !sceneState.editorInternals.directiveArgument.isEmpty {
                    Text(": **\(sceneState.editorInternals.directiveArgument)**")
                }
            }
            .font(.caption)
            .padding(.bottom, 4)
        }
    }
}

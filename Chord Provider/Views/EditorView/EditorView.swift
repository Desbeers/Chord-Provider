//
//  EditorView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
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
    /// The settings for the directive sheet
    @State var directiveSettings = DirectiveSettings()
    /// The connector class for the editor
    @State var connector = MacEditorView.Connector(settings: AppSettings.load(id: "Main").editor)
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
        .sheet(
            isPresented: $showDirectiveSheet,
            onDismiss: {
                if !directiveSettings.definition.isEmpty {
                    EditorView.format(
                        settings: directiveSettings,
                        in: connector
                    )
                }
                Task {
                    /// Sleep for a moment to give the sheet some time to close
                    /// - Note: Else the sheet will change during animation to its default
                    try? await Task.sleep(for: .seconds(0.4))
                    /// Clear the settings to default
                    directiveSettings = DirectiveSettings()
                    connector.clickedFragment = nil
                }
            },
            content: {
                DirectiveSheet(settings: $directiveSettings)
            }
        )
        /// Show a sheet when we add a new song
        .sheet(
            isPresented: $sceneState.presentTemplate,
            onDismiss: {
                /// Set the text
                connector.setText(text: document.text)
            },
            content: {
                TemplateView(document: $document, sceneState: sceneState)
            }
        )
    }
    /// The editor
    @MainActor var editor: some View {
        VStack {
            MacEditorView(
                text: $document.text,
                connector: connector
            )
            .onChange(of: appState.settings.editor) {
                connector.settings = appState.settings.editor
            }
            .onChange(of: connector.clickedFragment) {
                guard
                    let directive = connector.currentDirective,
                    let fragment = connector.clickedFragment,
                    let paragraph = fragment.textElement as? NSTextParagraph,
                    let match = paragraph.attributedString.string.firstMatch(of: ChordPro.directiveRegex)

                else {
                    return
                }
                directiveSettings.directive = directive
                directiveSettings.definition = String(match.output.2 ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                directiveSettings.clickedFragment = fragment
                switch directive {
                case .define:
                    showDirectiveSheet = validateChordDefinition()
                default:
                    showDirectiveSheet = true
                }
            }
            Text(.init(connector.currentDirective?.infoString ?? "No directive"))
                .font(.caption)
                .padding(.bottom, 4)
        }
    }
}

extension EditorView {

    //// Directive settings to pass to the sheet
    struct DirectiveSettings: Sendable {
        /// The directive to show in the sheet
        var directive: ChordPro.Directive = .none
        /// The definition of the directive sheet
        var definition: String = ""
        /// The optional clicked fragment range
        var clickedFragment: NSTextLayoutFragment?
    }
}

//
//  EditorView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities
import SwiftlyAlertMessage

extension EditorView {

    struct DirectiveSettings {
        /// The directive to show in the sheet
        var directive: ChordPro.Directive = .none
        /// The definition of the directive sheet
        var definition: String = ""
        /// The optional clicked fragment
        var clickedFragment: NSTextLayoutFragment?
    }
}

/// SwiftUI `View` for the ``ChordProEditor``
struct EditorView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The app state
    @Environment(AppState.self) var appState
    /// The scene state
    @Environment(SceneState.self) var sceneState
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) var chordDisplayOptions
    /// Show a directive sheet
    @State var showDirectiveSheet: Bool = false
    /// The settings for the directive sheet
    @State var directiveSettings = DirectiveSettings()
    /// The connector class for the editor
    @State var connector = ChordProEditor.Connector(settings: ChordProviderSettings.load().editor)
    /// Show an `Alert` if we have an error
    @State var errorAlert: AlertMessage?
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                directiveMenus
            }
            .padding()
            editor
        }
        .errorAlert(message: $errorAlert)
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
                    connector.textView.clickedFragment = nil
                }
            },
            content: {
                DirectiveSheet(settings: $directiveSettings)
            }
        )
    }
    /// The editor
    var editor: some View {
        VStack {
            ChordProEditor(
                text: $document.text,
                connector: connector
            )
            .task(id: appState.settings.editor) {
                connector.settings = appState.settings.editor
            }
            .task(id: connector.textView.clickedFragment) { @MainActor in
                guard
                    let directive = connector.textView.currentDirective,
                    let fragment = connector.textView.clickedFragment,
                    let paragraph = fragment.textElement as? NSTextParagraph,
                    let match = paragraph.attributedString.string.firstMatch(of: ChordProEditor.definitionRegex)

                else {
                    return
                }
                directiveSettings.directive = directive
                directiveSettings.definition = String(match.output.1).trimmingCharacters(in: .whitespacesAndNewlines)
                directiveSettings.clickedFragment = fragment
                
                switch directive {
                case .define:
                    showDirectiveSheet = validateChordDefinition()
                default:
                    showDirectiveSheet = true
                }
            }
            Text(.init(connector.textView.currentDirective?.infoString ?? "No directive"))
                .font(.caption)
                .padding(.bottom, 4)
        }
    }
}

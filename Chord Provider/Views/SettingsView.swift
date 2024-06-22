//
//  SettingsView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the settings
struct SettingsView: View {
    /// Chord Display Options
    @State private var chordDisplayOptions = ChordDisplayOptions(defaults: AppSettings.defaults)
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowser.self) private var fileBrowser
    /// The app state
    @Environment(AppState.self) var appState
    /// Dismiss
    @Environment(\.dismiss) private var dismiss
    /// The body of the `View`
    var body: some View {
        TabView {
            general
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            diagram
                .tabItem {
                    Label("Diagrams", systemImage: "guitars")
                }
            editor
                .tabItem {
                    Label("Editor", systemImage: "text.word.spacing")
                }
            folder
                .tabItem {
                    Label("Songs", systemImage: "folder")
                }
        }
        .task {
            chordDisplayOptions.displayOptions = appState.settings.chordDisplayOptions
        }
        .onChange(of: chordDisplayOptions.displayOptions) {
            appState.settings.chordDisplayOptions = chordDisplayOptions.displayOptions
        }
        .frame(width: 400, height: 480)
        .formStyle(.grouped)
    }

    /// `View` with general options
    @ViewBuilder var general: some View {
        @Bindable var appState = appState
        VStack {
            Text("General Options")
                .font(.title)
            Form {
                appState.repeatWholeChorusToggle
            }
        }
        .padding(.vertical)
    }

    /// `View` with diagram display options
    var diagram: some View {
        VStack {
            Text("Diagram Display Options")
                .font(.title)
            Form {
                Section("General") {
                    chordDisplayOptions.fingersToggle
                    chordDisplayOptions.notesToggle
                    chordDisplayOptions.mirrorToggle
                }
                Section("MIDI") {
                    chordDisplayOptions.playToggle
                    HStack {
                        Image(systemName: "guitars.fill")
                        chordDisplayOptions.midiInstrumentPicker
                    }
                    .disabled(!chordDisplayOptions.displayOptions.general.showPlayButton)
                    .padding(.leading)
                }
            }
            Button(
                action: {
                    chordDisplayOptions.displayOptions = AppSettings.defaults
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(chordDisplayOptions.displayOptions == AppSettings.defaults)
        }
        .padding(.vertical)
        .animation(.default, value: chordDisplayOptions.displayOptions)
    }

    /// `View` with editor settings
    @ViewBuilder var editor: some View {
        @Bindable var appState = appState
        VStack {
            Text("Editor Options")
                .font(.title)
            Form {
                Section("Font") {
                    HStack {
                        Text("A")
                            .font(.system(size: MacEditorView.Settings.fontSizeRange.lowerBound))
                        Slider(
                            value: $appState.settings.editor.fontSize,
                            in: MacEditorView.Settings.fontSizeRange,
                            step: 1
                        )
                        Text("A")
                            .font(.system(size: MacEditorView.Settings.fontSizeRange.upperBound))
                    }
                    .foregroundColor(.secondary)
                }
                Section("Colors") {
                    ColorPicker(
                        "The highlight color for **chords**",
                        selection: $appState.settings.editor.chordColor,
                        supportsOpacity: false
                    )
                    ColorPicker(
                        "The highlight color for **brackets**",
                        selection: $appState.settings.editor.bracketColor,
                        supportsOpacity: false
                    )
                    ColorPicker(
                        "The highlight color for **directives**",
                        selection: $appState.settings.editor.directiveColor,
                        supportsOpacity: false
                    )
                    ColorPicker(
                        "The highlight color for **definitions**",
                        selection: $appState.settings.editor.definitionColor,
                        supportsOpacity: false
                    )
                }
            }
            Button(
                action: {
                    appState.settings.editor = MacEditorView.Settings()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(appState.settings.editor == MacEditorView.Settings())
        }
        .padding(.vertical)
    }

    /// `View` with folder selector
    var folder: some View {
        VStack {
            Text("The folder with your songs")
                .font(.title)
            Form {
                Text(.init(Help.folderSelector))
                    .padding()
                Text(.init(Help.macOSbrowser))
                    .padding()
                fileBrowser.folderSelector
                    .padding()
            }
        }
        .padding(.vertical)
    }

    /// `View` with folder export
    var export: some View {
        VStack {
            Text("Export a Folder with Songs")
                .font(.title)
            ExportFolderView()
        }
        .padding(.vertical)
    }
}

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
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
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
#if !os(macOS)
            /// - Note: Export has its own window on macOS
            export
                .tabItem {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
#endif
        }
        .overlay(alignment: .topLeading) {
            close
        }
#if os(macOS)
        .frame(width: 450, height: 480)
#elseif os(visionOS)
        .frame(width: 450, height: 560)
#endif
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
                    .disabled(!chordDisplayOptions.displayOptions.showPlayButton)
                    .padding(.leading)
                }
            }
            Button(
                action: {
                    chordDisplayOptions.displayOptions = ChordProviderSettings.defaults
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(chordDisplayOptions.displayOptions == ChordProviderSettings.defaults)
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
                    Picker("The font size of the editor", selection: $appState.settings.editor.fontSize) {
                        ForEach(12...24, id: \.self) { value in
                            Text("\(value)px")
                                .tag(value)
                        }
                    }
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
                    appState.settings.editor = ChordProviderSettings.Editor()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(appState.settings.editor == ChordProviderSettings.Editor())
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
#if os(macOS)
                Text(.init(Help.macOSbrowser))
                    .padding()
#endif
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

    @ViewBuilder
    /// A close button for visionOS
    var close: some View {
#if os(visionOS)
        Button(
            action: {
                dismiss()
            },
            label: {
                Image(systemName: "xmark.circle")
            }
        )
        .foregroundStyle(.quaternary)
        .font(.title)
        .buttonStyle(.plain)
        .padding()
#endif
    }
}

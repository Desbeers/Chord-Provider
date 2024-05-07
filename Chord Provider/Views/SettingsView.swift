//
//  SettingsView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the settings
struct SettingsView: View {
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The FileBrowser model
    @Environment(FileBrowser.self) private var fileBrowser
    /// The app state
    @Environment(AppState.self) var appState
    /// Dismiss
    @Environment(\.dismiss) private var dismiss
    /// The body of the `View`
    var body: some View {
        TabView {
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
                    Label("Songs Folder", systemImage: "folder")
                }
        }
#if os(macOS)
        .frame(width: 450, height: 460)
#elseif os(visionOS)
        .frame(width: 450, height: 560)
#endif
        .formStyle(.grouped)
    }

    /// `View` with diagram display options
    var diagram: some View {
        VStack {
            Text("Diagram Display Options")
                .font(.title)
                .padding(.top)
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
            HStack {
                Button(
                    action: {
                        chordDisplayOptions.displayOptions = ChordProviderSettings.defaults
                    },
                    label: {
                        Text("Reset to defaults")
                    }
                )
                .disabled(chordDisplayOptions.displayOptions == ChordProviderSettings.defaults)
                close
            }
            .padding(.bottom)
        }
        .animation(.default, value: chordDisplayOptions.displayOptions)
        //        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// `View` with editor settings
    @ViewBuilder var editor: some View {
        @Bindable var appState = appState
        VStack {
            Text("Editor Options")
                .font(.title)
                .padding(.top)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                Button(
                    action: {
                        appState.settings.editor = ChordProviderSettings.Editor()
                    },
                    label: {
                        Text("Reset to defaults")
                    }
                )
                .disabled(appState.settings.editor == ChordProviderSettings.Editor())
                close
            }
        }
        .padding(.bottom)
    }

    /// `View` with folder selector
    var folder: some View {
        VStack {
            VStack {
                Text("The folder with your songs")
                    .font(.title)
                    .padding(.top)
                Text(.init(AudioFileStatus.help))
                    .padding()
                #if os(macOS)
                Text(.init(AudioFileStatus.macOSbrowser))
                    .padding()
                #endif
                fileBrowser.folderSelector
                    .padding()
                Spacer()
            }

            .frame(maxWidth: .infinity, maxHeight: .infinity)
            close
                .padding()
        }
    }

    @ViewBuilder
    /// A closebutton for visionOS
    var close: some View {
#if os(visionOS)
        Button(
            action: {
                dismiss()
            },
            label: {
                Text("Close")
            }
        )
#endif
    }
}

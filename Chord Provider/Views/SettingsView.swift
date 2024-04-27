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
    /// Dismiss
    @Environment(\.dismiss) private var dismiss
    /// The body of the `View`
    var body: some View {
#if os(macOS)
        TabView {
            diagram
                .tabItem {
                    Label("Diagrams", systemImage: "guitars")
                }
            folder
                .tabItem {
                    Label("Songs Folder", systemImage: "folder")
                }
        }
        .frame(width: 450, height: 420)
#elseif os(iOS)
        diagram
#else
        diagram
            .frame(width: 450, height: 560)
#endif
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
            .formStyle(.grouped)
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
            .padding(.bottom)
        }
        .animation(.default, value: chordDisplayOptions.displayOptions)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// `View` with folder selector
    var folder: some View {
        VStack {
            Text(.init(AudioFileStatus.help))
            fileBrowser.folderSelector
                .padding()
        }
        .padding()
    }
}

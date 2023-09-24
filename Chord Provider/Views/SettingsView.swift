//
//  SettingsView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct SettingsView: View {
    /// Chord Display Options
    @EnvironmentObject var options: ChordDisplayOptions
    /// The body of the `View`
    var body: some View {
#if os(macOS)
        TabView {
            diagram
                .tabItem {
                    Label("Diagrams", systemImage: "guitars")
                }
        }
        .frame(width: 450, height: 420)
#else
        diagram
#endif
    }
    var diagram: some View {
        VStack {
            Text("Diagram Display Options")
                .font(.title)
                .padding(.top)
            Form {
                Section("General") {
                    options.fingersToggle
                    options.notesToggle
                    options.mirrorToggle
                }
                Section("MIDI") {
                    options.playToggle
                    HStack {
                        Image(systemName: "guitars.fill")
                        options.midiInstrumentPicker
                    }
                    .disabled(!options.displayOptions.showPlayButton)
                    .padding(.leading)
                }
            }
            .formStyle(.grouped)
            Button(
                action: {
                    options.displayOptions = ChordProviderApp.defaults
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding(.bottom)
            .disabled(options.displayOptions == ChordProviderApp.defaults)
        }
        .animation(.default, value: options.displayOptions)
    }
}

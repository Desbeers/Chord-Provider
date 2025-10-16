//
//  SettingsView+diagram.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension SettingsView {

    /// `View` with diagram display options
    var diagram: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    appState.fingersToggle
                    appState.notesToggle
                    appState.mirrorToggle
                }
                .wrapSettingsSection(title: "General")
                VStack(alignment: .leading) {
                    appState.playToggle
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if appState.settings.midi.showPlayButton {
                        appState.midiInstrumentPicker
                            .padding(.leading)
                    }
                }
                .wrapSettingsSection(title: "MIDI")
                .padding(.bottom)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Divider()
            Button(
                action: {
                    appState.settings.midi = AppSettings.MidiPlayer()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(appState.settings.midi == AppSettings.MidiPlayer())
            .padding()
        }
        .animation(.default, value: appState.settings.midi.showPlayButton)
    }
}

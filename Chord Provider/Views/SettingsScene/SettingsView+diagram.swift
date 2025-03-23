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
        VStack {
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
                    if appState.settings.song.diagram.showPlayButton {
                        appState.midiInstrumentPicker
                            .padding([.top, .leading])
                    }
                }
                .wrapSettingsSection(title: "MIDI")
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Button(
                action: {
                    appState.settings.song.diagram = AppSettings.DiagramDisplayOptions()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(appState.settings.song.diagram == AppSettings.DiagramDisplayOptions())
            .padding(.bottom)
        }
        .animation(.default, value: appState.settings.song.diagram.showPlayButton)
    }
}

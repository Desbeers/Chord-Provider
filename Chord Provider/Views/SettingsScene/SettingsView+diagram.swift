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
                    if appState.settings.diagram.showPlayButton {
                        appState.midiInstrumentPicker
                            .padding([.top, .leading])
                    }
                }
                .wrapSettingsSection(title: "MIDI")
                .padding(.bottom)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Divider()
            Button(
                action: {
                    appState.settings.diagram = AppSettings.Diagram()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(appState.settings.diagram == AppSettings.Diagram())
            .padding()
        }
        .animation(.default, value: appState.settings.diagram.showPlayButton)
    }
}

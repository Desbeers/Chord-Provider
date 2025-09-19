//
//  TransposeView.swift
//  ChordProviderGnome
//
//  Created by Nick Berendsen on 04/09/2025.
//

import Foundation
import ChordProviderCore
import Adwaita

/// The `View` for settings
struct SettingsView: View {
    @Binding var settings: AppSettings
    var view: Body {
        ScrollView {
            Text("Display")
                .heading()
                .halign(.start)
                .padding(10, [.leading, .bottom])
            Form {
                SwitchRow()
                    .title("Show only lyrics")
                    .subtitle("Hide all the chords")
                    .active($settings.core.lyricsOnly)
                SwitchRow()
                    .title("Repeat whole chorus")
                    .subtitle("Show the whole chorus with the same label")
                    .active($settings.core.repeatWholeChorus)
            }
            Text("Chord Diagrams")
                .heading()
                .halign(.start)
                .padding(10)
            Form {
                SwitchRow()
                    .title("Show left-handed chords")
                    .subtitle("Flip the chord diagrams")
                    .active($settings.core.diagram.mirror)
            }
            Text("Editor")
                .heading()
                .halign(.start)
                .padding(10)
            Form {
                SwitchRow()
                    .title("Line Numbers")
                    .subtitle("Show the line numbers in the editor")
                    .active($settings.editor.showLineNumbers)
                SwitchRow()
                    .title("Wrap Lines")
                    .subtitle("Wrap lines when they are too long")
                    .active($settings.editor.wrapLines)
                ComboRow("Font Size", selection: $settings.editor.fontSize, values: AppSettings.EditorFont.allCases)
                    .subtitle("Select the font size for the editor")
            }
        }
        .padding(10, [.bottom, .leading, .trailing])
        .hexpand()
        .vexpand()
    }
}

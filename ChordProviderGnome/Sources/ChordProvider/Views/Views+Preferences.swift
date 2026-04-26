//
//  Views+Preferences.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CAdw

extension Views {

    /// The `View` for the preferences
    struct Preferences: View {
        @Binding var appState: AppState

        @State var tuningFrequency: String = ""
        /// The body of the `View`
        var view: Body {
            /// Just an attachment point for modifiers
            Views.Empty()
            /// The **Preference Dialog**
            .preferencesDialog(visible: $appState.scene.showPreferencesDialog)
            .preferencesPage("General", icon: .default(icon: .applicationsSystem)) { page in
                page
                    .group("Display your song") {
                        SwitchRow()
                            .title("Show only lyrics")
                            .subtitle("Hide all the chords")
                            .active($appState.editor.coreSettings.lyricsOnly)
                        SwitchRow()
                            .title("Repeat whole chorus")
                            .subtitle("Show the whole chorus with the same label")
                            .active($appState.editor.coreSettings.repeatWholeChorus)
                    }
                    .group("Appearance") {
                        ComboRow(
                            "Color Scheme",
                            selection: $appState.settings.theme.appearance.onSet { value in
                                /// Apply the appearance directly or else its one step behind
                                adw_style_manager_set_color_scheme(appState.styleManager, value.colorScheme)
                            },
                            values: AppSettings.Theme.Appearance.allCases
                        )
                            .subtitle("Preferred Color Scheme")
                        SwitchRow()
                            .title("Colorful Window")
                            .subtitle("Use a more colorful style for the window background")
                            .active($appState.settings.theme.colorfullWindow)
                        ComboRow(
                            "Color Theme",
                            selection: $appState.settings.theme.colorScheme,
                            values: AppSettings.ColorScheme.allCases
                        )
                            .subtitle("Preferred Color Theme")
                    }
                    .group("Debug") {
                        SwitchRow()
                            .title("Debug")
                            .subtitle("Show debug additions, it needs a restart")
                            .active($appState.settings.app.debug)
                    }
            }
            .preferencesPage("Editor", icon: .default(icon: .textEditor)) { page in
                page
                    .group("Options for the editor") {
                        SwitchRow()
                            .title("Line Numbers")
                            .subtitle("Show the line numbers in the editor")
                            .active($appState.settings.editor.showLineNumbers)
                        SwitchRow()
                            .title("Wrap Lines")
                            .subtitle("Wrap lines when they are too long")
                            .active($appState.settings.editor.wrapLines)
                        ActionRow("Font Size")
                            .subtitle("Set the font size for the editor")
                            .suffix {
                                HStack {
                                    Views.Spinner(
                                        start: 8,
                                        end: 20,
                                        suffix: "pt",
                                        value: $appState.settings.theme.editorFontSize
                                    )
                                }
                                .valign(.center)
                            }
                    }
            }
            .preferencesPage("Chords", icon: .default(icon: .folderMusic)) { page in
                page
                    .group("Chord Diagrams") {
                        SwitchRow()
                            .title("Show left-handed chords")
                            .subtitle("Flip the chord diagrams")
                            .active($appState.editor.coreSettings.diagram.mirror)
                        SwitchRow()
                            .title("Show notes")
                            .subtitle("Show the notes of a chord in the diagram")
                            .active($appState.editor.coreSettings.diagram.showNotes)
                    }
                    .group("Custom Chord Definitions") {
                        let instruments = appState.settings.app.instruments.filter { $0.bundle == nil }
                        if !instruments.isEmpty {
                            Form {
                                ForEach(instruments) { instrument in
                                    ActionRow(instrument.kind.description)
                                        .subtitle(instrument.label)
                                        .suffix {
                                            Button("Remove") {
                                                appState.removeDatabase(instrument: instrument, main: true)
                                            }
                                            .valign(.center)
                                        }
                                }
                            }
                            .padding(.bottom)
                        }
                        Form {
                            ActionRow("Import chord definitions")
                                .subtitle("The definitions should be in <b>ChordPro</b> format")
                                .suffix {
                                Button("Import") {
                                    appState.scene.importDatabase.signal()
                                }
                                .valign(.center)
                            }
                            .fileImporter(
                                open: appState.scene.importDatabase,
                                extensions: ["json"]
                            ) { fileURL in
                                appState.importDatabase(url: fileURL, main: true)
                            }
                        }
                    }
            }
            .preferencesPage("MIDI", icon: .default(icon: .mediaPlaybackStart)) { page in
                page
                    .group("Options for the MIDI player") {
                        ComboRow(
                            "MIDI Instrument",
                            selection: $appState.editor.coreSettings.midiPreset.onSet({ value in
                                Task {
                                    await Utils.MidiPlayer.shared.setPreset(value)
                                }
                            }
                            ),
                            values: MidiUtils.Preset.allCases
                        )
                        .subtitle("Select the instrument when playing chords with MIDI")
                        ComboRow(
                            "Chord Strum",
                            selection: $appState.editor.coreSettings.chordStrum,
                            values: Chord.Strum.options
                        )
                        .subtitle("The default strum when playing a chord")
                        SwitchRow()
                            .title("Use sound for Chord Definitions")
                            .subtitle("Play notes when editing a chord")
                            .active($appState.settings.app.soundForChordDefinitions)
                    }
                    .group("Tuning Frequency") {
                        ActionRow("Reference pitch")
                            //.subtitle("The reference frequency")
                            .suffix {
                                HStack {
                                    Views.Spinner(
                                        start: 300,
                                        end: 500,
                                        suffix: "Hz",
                                        value: $appState.editor.coreSettings.referenceFrequency.onSet({ value in
                                            Task {
                                                await Utils.MidiPlayer.shared.setReferenceFrequency(value)
                                            }
                                        })
                                    )
                                    Button("Default") {
                                        appState.editor.coreSettings.referenceFrequency = 440
                                    }
                                    .padding(.leading)
                                    .insensitive(appState.editor.coreSettings.referenceFrequency == 440)
                                }
                                .valign(.center)
                            }
                        Text("The tuning frequency sets the pitch of the A above middle C used as the reference.\nChanging it shifts all notes higher or lower and affecting the overall sound.")
                            .useMarkup()
                            .wrap()
                            .padding()
                            .style(.caption)
                  }
            }
        }
    }
}
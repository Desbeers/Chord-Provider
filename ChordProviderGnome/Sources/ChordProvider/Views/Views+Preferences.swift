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
        /// The body of the `View`
        var view: Body {
            /// Just an attachment point for modifiers
            Views.Empty()
            /// The **Preference Dialog**
            .preferencesDialog(visible: $appState.scene.showPreferencesDialog)
            .preferencesPage("General", icon: .default(icon: .folderMusic)) { page in
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
            }
            .preferencesPage("Appearance", icon: .default(icon: .applicationsGraphics)) { page in
                page
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
                        ComboRow(
                            "Font Size",
                            selection: $appState.settings.theme.editorFontSize,
                            values: AppSettings.Theme.Font.allCases
                        )
                        .subtitle("Select the font size for the editor")
                    }
            }
            .preferencesPage("Chords", icon: .default(icon: .mediaPlaybackStart)) { page in
                page
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
                    .group("Options for the MIDI player") {
                        ComboRow(
                            "Instrument",
                            selection: $appState.editor.coreSettings.midiPreset,
                            values: MidiUtils.Preset.allCases
                        )
                        .subtitle("Select the instrument for playing chord with MIDI")
                        SwitchRow()
                            .title("Sound for Chord Definitions")
                            .subtitle("Use sound when defining a Chord")
                            .active($appState.settings.app.soundForChordDefinitions)
                    }
            }
        }
    }
}
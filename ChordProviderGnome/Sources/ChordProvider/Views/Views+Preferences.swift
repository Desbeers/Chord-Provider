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
                            .active($appState.editor.song.settings.lyricsOnly)
                        SwitchRow()
                            .title("Repeat whole chorus")
                            .subtitle("Show the whole chorus with the same label")
                            .active($appState.editor.song.settings.repeatWholeChorus)
                    }
                    .group("Chord Diagrams") {
                        SwitchRow()
                            .title("Show left-handed chords")
                            .subtitle("Flip the chord diagrams")
                            .active($appState.editor.song.settings.diagram.mirror)
                        SwitchRow()
                            .title("Show notes")
                            .subtitle("Show the notes of a chord in the diagram")
                            .active($appState.editor.song.settings.diagram.showNotes)
                    }
            }
            .preferencesPage("Style", icon: .default(icon: .applicationsGraphics)) { page in
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
                        ComboRow("Font Size", selection: $appState.settings.theme.editorFontSize, values: AppSettings.Theme.Font.allCases)
                            .subtitle("Select the font size for the editor")
                    }
            }
            .preferencesPage("Midi", icon: .default(icon: .mediaPlaybackStart)) { page in
                page
                    .group("Options for the MIDI player") {
                        ComboRow("Instrument", selection: $appState.settings.core.midiPreset, values: MidiUtils.Preset.allCases)
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
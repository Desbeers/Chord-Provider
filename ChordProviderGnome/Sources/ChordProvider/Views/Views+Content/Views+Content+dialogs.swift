//
//  Views+Content+dialogs.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CAdw

extension Views.Content {

    /// The dialogs for he *Content view*
    var dialogs: AnyView {

        /// Just an attachment point for modifiers
        Views.Empty()

        // MARK: About Dialog

        /// The **About dialog**
        ///
        /// - Note: It would be nice if we could add some more stuff to this dialog
        /// - Credits
        /// - Troubleshooting
            .aboutDialog(
                visible: $appState.scene.showAboutDialog,
                app: "Chord Provider",
                developer: "Nick Berendsen",
                version: "1.0",
                icon: .custom(name: "nl.desbeers.chordprovider"),
                // swiftlint:disable:next force_unwrapping
                website: URL(string: "https://github.com/Desbeers/Chord-Provider")!,
                // swiftlint:disable:next force_unwrapping
                issues: URL(string: "https://github.com/Desbeers/Chord-Provider/issues")!
            )

        // MARK: Transpose Song Dialog

        /// The dialog to ** Transpose Song**
            .dialog(
                visible: $appState.scene.showTransposeDialog,
                title: "Transpose the song",
                width: 260,
                height: 180
            ) {
                Views.Transpose(appState: $appState)
            }

        // MARK: Save Song dialog

        /// The **Alert dialog** when a song is changed but not yet saved
            .alertDialog(
                visible: $appState.scene.showCloseDialog,
                heading: "Save Changes?",
                //body: "Changes which are not saved will be permanently lost.",
                id: "dirty-dialog",
                /// - Note: Use `extraChild` instead of `body` so I can use markup
                extraChild:  {
                    VStack {
                        Text("<b>\(appState.editor.song.metadata.title)</b> is modified.")
                            .useMarkup()
                            .style(.subtitle)
                            .padding(.bottom)
                        Text("Changes which are not saved will be permanently lost.")
                    }
                    /// - Note: Dirty trick to show all three buttons vertical
                    .frame(minWidth: 380)
                }
            )
            .response("Cancel", role: .close) {
                /// Do nothing
            }
            .response("Discard", appearance: .destructive, role: .none) {
                /// Make the source 'clean' so we can close the window
                appState.scene.originalContent = appState.editor.song.content
                switch appState.scene.saveDoneAction {
                case .closeWindow:
                    /// Close the window
                    window.close()
                case .showWelcomeView:
                    appState.scene.showWelcomeView = true
                case .noAction:
                    return
                }
            }
            .response("Save", appearance: .suggested, role: .default) {
                if let fileURL = appState.editor.song.settings.fileURL {
                    appState.saveSong()
                    /// Add it to the recent songs list
                    recentSongs.addRecentSong(
                        content: appState.scene.originalContent,
                        settings: appState.editor.song.settings
                    )
                    switch appState.scene.saveDoneAction {
                    case .closeWindow:
                        window.close()
                    case .showWelcomeView:
                        appState.scene.showWelcomeView = true
                    case .noAction:
                        /// Set the toast
                        appState.scene.toastMessage = "Saved \(fileURL.deletingPathExtension().lastPathComponent)"
                        appState.scene.showToast.signal()
                    }
                } else {
                    /// The song has not yet been saved; show the *Save As* dialog
                    appState.editor.song.settings.export.format = .chordPro
                    appState.scene.saveSongAs.signal()
                }
            }

        // MARK: Preference dialog

        /// The **Preference Dialog**
        ///
        /// - Note: It would be nice if the pages can be added in an overload
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

        // MARK: Shortcuts Dialog

            .shortcutsDialog(visible: $appState.scene.showShortcutsDialog)
            .shortcutsSection("Song") { section in
                section
                    .shortcutsItem("Open", accelerator: "o".ctrl())
                    .shortcutsItem("Save", accelerator: " s".ctrl())
                    .shortcutsItem("Save As", accelerator: " s".ctrl().shift())
            }
            .shortcutsSection("Zoom") { section in
                section
                    .shortcutsItem("Zoom In", accelerator: "plus".ctrl())
                    .shortcutsItem("Zoom Out", accelerator: " minus".ctrl())
                    .shortcutsItem("Reset Zoom", accelerator: " 0".ctrl())
            }
            .shortcutsSection("General") { section in
                section
                    .shortcutsItem("Show preferences", accelerator: "comma".ctrl())
                    .shortcutsItem("Show keyboard shortcuts", accelerator: "question".ctrl())
            }
            .shortcutsSection { $0.shortcutsItem("Quit Chord Provider", accelerator: "q".ctrl()) }
    }
}

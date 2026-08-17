//
//  Views+Main+dialogs.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Main {

    /// The dialogs for the *Content view*
    var dialogs: AnyView {

        // MARK: Preferences Dialog

        /// The `View` for the preferences
        Preferences(appState: $appState)

        // MARK: About Dialog

        /// The **About dialog**
        .aboutDialog(
            visible: $appState.scene.showAboutDialog,
            app: "Chord Provider",
            developer: "Nick Berendsen",
            version: "1.0",
            icon: .custom(name: "nl.desbeers.chordprovider"),
            details: [
                .comment("A <a href=\"https://www.chordpro.org/\">ChordPro</a> file parser and editor for GNOME.\n\nShow the song with the chords for guitar, guitalele or ukulele."),
                .developers(["Nick Berendsen"]),
                .copyright("© 2026 Nick Berendsen"),
                .licenseType(.gpl3),
                .creditSection(
                    [
                        "Adwaita for Swift https://adwaita-swift.aparoksha.dev/",
                        "Swift https://swift.org",
                        "FluidSynth https://www.fluidsynth.org/"
                    ],
                    label: "Built with"
                ),
                .acknowledgementSection(
                    [
                        "ChordPro Community https://www.chordpro.org/",
                        "Swift Community https://www.swift.org/community/"
                    ],
                    label: "Thanks to"
                ),
            ],
            links: [
                .website(URL(string: "https://github.com/Desbeers/Chord-Provider")),
                .issues(URL(string: "https://github.com/Desbeers/Chord-Provider/issues"))
            ]
        )

        // MARK: Transpose Song Dialog

        /// The dialog for **Transpose Song**
        .dialog(
            visible: $appState.scene.showTransposeDialog,
            title: "Transpose the song",
            width: 260,
            height: 180
        ) {
            Transpose(appState: $appState)
        }

        // MARK: Error Dialog

        /// The **Alert dialog** for an error
        .alertDialog(
            visible: $appState.scene.showMainErrorDialog,
            heading: appState.scene.error?.description ?? "Error",
            id: "error-dialog"
        ) {
            /// - Note: I use `etraChild` instead of `body` so I can use markup
            Views.ErrorMessage(error: appState.scene.error)
        }
        .response("OK", role: .default) {
            /// Do nothing
        }

        // MARK: Save Song dialog

        /// The **Alert dialog** when a song is changed but not yet saved
        .alertDialog(
            visible: $appState.scene.showCloseDialog,
            heading: "Save Changes?",
            id: "dirty-dialog"
        ) {
            /// - Note: I use `extraChild` instead of `body` so I can use markup
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
        .response("Cancel", role: .close) {
            // Do nothing
        }
        .response("Discard", appearance: .destructive, role: .none) {
            /// Make the source 'clean' so we can close the window
            appState.scene.originalContent = appState.editor.song.content
            switch appState.scene.saveDoneAction {
            case .closeWindow:
                window.close()
            case .showHomeView:
                appState.scene.showHomeView = true
            case .openURL(let url):
                appState.openSong(fileURL: url)
            case .noAction:
                return
            }
        }
        .response("Save", appearance: .suggested, role: .default) {
            if let fileURL = appState.editor.coreSettings.fileURL {
                appState.saveSong()
                /// Add it to the recent songs list
                recentSongs.addRecentSong(
                    content: appState.scene.originalContent,
                    coreSettings: appState.editor.coreSettings
                )
                switch appState.scene.saveDoneAction {
                case .closeWindow:
                    window.close()
                case .showHomeView:
                    appState.scene.showHomeView = true
                case .openURL(let url):
                    appState.openSong(fileURL: url)
                case .noAction:
                    /// Set the toast
                    appState.scene.toastMessage = "Saved \(fileURL.deletingPathExtension().lastPathComponent)"
                    appState.scene.showToast.signal()
                }
            } else {
                /// The song has not yet been saved; show the *Save As* dialog
                appState.editor.coreSettings.export.format = .chordPro
                appState.scene.saveSongAs.signal()
            }
        }

        // MARK: Shortcuts Dialog

        .shortcutsDialog(visible: $appState.scene.showShortcutsDialog)
        .shortcutsSection("Song") { section in
            section
                .shortcutsItem("Open", accelerator: "o".ctrl())
                .shortcutsItem("Save", accelerator: "s".ctrl())
                .shortcutsItem("Find/Replace", accelerator: "f".ctrl())
        }
        .shortcutsSection("Zoom") { section in
            section
                .shortcutsItem("Zoom In", accelerator: "plus".ctrl())
                .shortcutsItem("Zoom Out", accelerator: "minus".ctrl())
                .shortcutsItem("Reset Zoom", accelerator: "0".ctrl())
        }
        .shortcutsSection("General") { section in
            section
                .shortcutsItem("Show preferences", accelerator: "comma".ctrl())
                .shortcutsItem("Show keyboard shortcuts", accelerator: "question".ctrl())
        }
        .shortcutsSection { section in
            section
                .shortcutsItem("Quit Chord Provider", accelerator: "q".ctrl())
        }
    }
}

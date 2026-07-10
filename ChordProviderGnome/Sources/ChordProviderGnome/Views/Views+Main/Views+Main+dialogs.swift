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
                website: URL(string: "https://github.com/Desbeers/Chord-Provider"),
                issues: URL(string: "https://github.com/Desbeers/Chord-Provider/issues")
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
                /// Do nothing
            }
            .response("Discard", appearance: .destructive, role: .none) {
                /// Make the source 'clean' so we can close the window
                appState.scene.originalContent = appState.editor.song.content
                switch appState.scene.saveDoneAction {
                case .closeWindow:
                    /// Close the window
                    window.close()
                case .showHomeView:
                    appState.scene.showHomeView = true
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
            .shortcutsSection { $0.shortcutsItem("Quit Chord Provider", accelerator: "q".ctrl()) }
    }
}

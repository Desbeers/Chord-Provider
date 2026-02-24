//
//  Views+Content+dialogs.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Content {

    /// The dialogs for the *Content view*
    var dialogs: AnyView {

        /// The `View` for the preferences
        Views.Preferences(appState: $appState)

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

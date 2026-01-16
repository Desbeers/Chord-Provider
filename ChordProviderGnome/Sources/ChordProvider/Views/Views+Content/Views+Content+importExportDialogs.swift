//
//  Views+Content+importExportDialogs.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Content {

    /// The dialogs for the *Content view* for file import and export
    var importExportDialogs: AnyView {

        /// Just an attachment point for modifiers
        Views.Empty()

        // MARK: File Importer

        /// The **File Importer**
            .fileImporter(
                open: appState.scene.openSong,
                extensions: ChordPro.fileExtensions
            ) { fileURL in
                appState.openSong(fileURL: fileURL)
                appState.scene.showToast.signal()
            }

        // MARK: File Exporter

        /// The **File Exporter**
            .fileExporter(
                open: appState.scene.saveSongAs,
                initialName: appState.editor.song.initialName(format: appState.editor.song.settings.export.format)
            ) { fileURL in
                switch appState.editor.song.settings.export.format {
                case .chordPro:
                    appState.editor.song.settings.fileURL = fileURL
                    appState.saveSong(appState.editor.song)
                    /// Set the toast
                    appState.scene.toastMessage = "Saved as '\(fileURL.deletingPathExtension().lastPathComponent)'"
                default:
                    break
                }
                switch appState.scene.saveDoneAction {
                case .closeWindow:
                    window.close()
                case .showWelcomeView:
                    appState.scene.showToast.signal()
                    appState.scene.showWelcomeView = true
                case .noAction:
                    appState.scene.showToast.signal()
                }
            }
    }
}

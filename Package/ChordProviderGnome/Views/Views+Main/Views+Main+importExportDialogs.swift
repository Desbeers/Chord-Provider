//
//  Views+Main+importExportDialogs.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Main {

    /// The dialogs for the *Main view* for file import and export
    var importExportDialogs: AnyView {

        /// Just an attachment point for modifiers
        Views.Empty()

        // MARK: File Importer

        /// The **File Importer**
            .fileImporter(
                open: $appState.scene.openSong,
                filters: [
                    .mimeType("application/x-chordpro", name: "ChordPro songs"),
                    .extensions(["*"], name: "All Files")
                ]
            ) { fileURL in
                appState.openSong(fileURL: fileURL)
            }

        // MARK: File Exporter

        /// The **File Exporter**
            .fileExporter(
                open: $appState.scene.saveSongAs,
                initialName: appState.song.initialName(format: ChordProviderSettings.Export.Format.chordPro)
            ) { fileURL in
                appState.controller.command(.save(as: fileURL))
                /// Set the toast
                appState.scene.toastMessage = "Saved as '\(fileURL.deletingPathExtension().lastPathComponent)'"
                switch appState.scene.saveDoneAction {
                case .closeWindow:
                    window.close()
                case .showHomeView:
                    appState.scene.showToast.signal()
                    appState.scene.viewStatus = .showHomeView
                case .openURL(let url):
                    appState.scene.showToast.signal()
                    appState.openSong(fileURL: url)
                case .noAction:
                    appState.scene.showToast.signal()
                }
            }
    }
}

//
//  UserFileButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers
import OSLog

/// SwiftUI `View` with a button to select a file
/// - Note: A file can be a *normal* file but also a folder
struct UserFileButton: View {
    /// The file to bookmark
    let userFile: UserFile
    /// Bool to show the selection as label
    var showSelection: Bool = true
    /// The action when a file is selected
    let action: () -> Void
    /// The label of the button
    @State private var label: String?

    /// Present an import dialog
    @State private var presentImportDialog: Bool = false
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                presentImportDialog = true
            },
            label: {
                Label(label ?? "Select", systemImage: userFile.icon)
            }
        )
        .help(userFile.message)
        .task {
            if showSelection {
                label = userFile.label
            }
        }
        .fileImporter(
            isPresented: $presentImportDialog,
            allowedContentTypes: userFile.utTypes,
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let files):
                files.forEach { url in
                    userFile.setBookmarkURL(url)
                    Logger.application.info("Bookmark set for '\(url.lastPathComponent, privacy: .public)'")
                    if showSelection {
                        label = userFile.label
                    }
                    action()
                }
            case .failure(let error):
                Logger.application.error("Import dialog error: '\(error, privacy: .public)'")
            }
        } onCancellation: {
            Logger.application.info("Import canceled")
        }
        .fileDialogMessage(Text(userFile.message))
        .fileDialogCustomizationID(userFile.id)
        .fileDialogConfirmationLabel(Text("Select"))
    }
}

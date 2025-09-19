//
//  UserFileButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers
import ChordProviderCore

/// SwiftUI `View` with a button to select a file
/// - Note: A file can be a *normal* file but also a folder
struct UserFileButton: View {
    /// The file to bookmark
    let userFile: UserFileUtils.Selection
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
                    if showSelection {
                        label = userFile.label
                    }
                    action()
                }
            case .failure(let error):
                LogUtils.shared.setLog(
                    level: .error,
                    category: .fileAccess,
                    message: "Import dialog error: '\(error.localizedDescription)'"
                )
            }
        } onCancellation: {
            LogUtils.shared.setLog(
                level: .info,
                category: .fileAccess,
                message: "Import canceled"
            )
        }
        .fileDialogMessage(Text(userFile.message))
        .fileDialogCustomizationID(userFile.id)
        .fileDialogConfirmationLabel(Text("Select"))
    }
}

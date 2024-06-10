//
//  FileButtonView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View`to select a file
/// - Note: A file can be a *normal* file but also a folder
struct FileButtonView: View {
    /// The file to bookmark
    let bookmark: CustomFile
    /// The action when a file is selected
    let action: () -> Void
    /// Bool to show the file importer sheet
    @State private var isPresented: Bool = false
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                isPresented.toggle()
            },
            label: {
                Label(bookmark.label ?? "Select", systemImage: bookmark.icon)
            }
        )
        .selectFileSheet(
            isPresented: $isPresented,
            bookmark: bookmark,
            action: action
        )
    }
}

extension FileButtonView {

    /// SwiftUI `Modifier` to add a `FileImporter` sheet
    struct SelectFileSheet: ViewModifier {
        /// Bool to show the sheet
        @Binding var isPresented: Bool
        /// The ``CustomFile`` to select
        let bookmark: CustomFile
        /// The action when a file is selected
        let action: () -> Void
        /// The body of the `ViewModifier`
        func body(content: Content) -> some View {
            content
                .fileImporter(
                    isPresented: $isPresented,
                    allowedContentTypes: [bookmark.utType]
                ) { result in
                    switch result {
                    case .success(let url):
                        FileBookmark.setBookmarkURL(bookmark, url)
                        action()
                    case .failure(let error):
                        Logger.fileAccess.error("\(error.localizedDescription, privacy: .public)")
                    }
                }
                .fileDialogMessage(bookmark.message)
                .fileDialogConfirmationLabel("Select")
                .fileDialogCustomizationID(bookmark.rawValue)
        }
    }
}

extension View {

    /// SwiftUI `Modifier` to add a `FileImporter` sheet
    /// - Parameters:
    ///   - isPresented: Bool to show the sheet
    ///   - bookmark: The ``CustomFile`` to select
    ///   - action: The action when a file is selected
    /// - Returns: A modified `View`
    func selectFileSheet(
        isPresented: Binding<Bool>,
        bookmark: CustomFile,
        action: @escaping () -> Void
    ) -> some View {
        modifier(
            FileButtonView.SelectFileSheet(
                isPresented: isPresented,
                bookmark: bookmark,
                action: action
            )
        )
    }
}

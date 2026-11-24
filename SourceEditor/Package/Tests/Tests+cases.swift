//
//  Tests+cases.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//


import Testing
import Foundation
import Adwaita
import CGtkSourceView
@testable import SourceEditor

enum TestCase: String {

    // MARK: Errors

    case deletedFileErrorNamesTheFile = "The error text for a deleted file names that file"

    // MARK: Opening

    case openNoneExistingFileWhileEmpty = "Opening a non-existing file with no file open leaves the file URL none"
    case openNoneExistingFileWhileLoaded = "Opening a non-existing file keeps the file that is already open"
    case openExistingFile = "Opening an existing file succeeds and sets the file URL"

    // MARK: Saving

    case saveOpenedFile = "Saving an untouched opened file should succeed."
    case saveDeletedFile = "Saving an opened file that was deleted or moved should fail."
    case saveModifiedFile = "Saving an opened file that was changed by another program should fail."
    case saveNewFileWithURL = "Saving a new file to a given URL should succeed."
    case saveNewFileWithoutURL = "Saving a new file without a URL should fail."
    case saveAfterFailedOpenWithNoFileOpen = "Saving after a failed open with no file open fails with no URL"
    case saveAfterFailedOpenKeepsOriginal = "Saving after a failed open still saves the original file"

    // MARK: Modification state

    case newFileIsUnmodified = "A new file with default text is unmodified"
    case newChangedFileIsModified = "A new file that is changed is modified"
    case openedFileIsUnmodified = "A just opened file is unmodified"
    case openedFileChangedIsModified = "An opened file that is changed is modified"
    case savedFileIsUnmodified = "A just saved file should be unmodified"
    case savedFileAsIsUnmodified = "A just 'saved as...' file should be unmodified"

    /// Extra explanation, shown below the title.
    var details: String? {
        switch self {

        // Errors
        case .deletedFileErrorNamesTheFile:
            """
            - The error is `SourceEditorError.fileDeleted`.
            - The description must contain the name of the file.
            """

        // Opening
        case .openNoneExistingFileWhileEmpty:
            """
            - No file is open.
            - The file that the user tries to open does not exist.
            - The file URL of the bridge must stay nil.
            """
        case .openNoneExistingFileWhileLoaded:
            """
            - The file that the user tries to open does not exist.
            - Another file is already open.
            - The file URL of the bridge must be the previous file.
            """
        case .openExistingFile:
            """
            - The file that the user tries to open exists.
            - The file URL of the bridge must be set to the new file.
            """

        // Saving
        case .saveOpenedFile:
            """
            - An existing file is opened and not touched by another program.
            - A plain save must succeed.
            """
        case .saveDeletedFile:
            """
            - An existing file is opened and then deleted on disk.
            - A plain save must fail with `.fileDeleted`.
            - GTK sees a moved file the same way, so it has no test of its own.
            """
        case .saveModifiedFile:
            """
            - An existing file is opened and then changed on disk.
            - A plain save must fail with `.externallyModified`.
            """
        case .saveNewFileWithURL:
            """
            - Open a new file, never saved.
            - A save to a given URL must succeed.
            - The saved file must contain the text of the buffer.
            """
        case .saveNewFileWithoutURL:
            """
            - A new file, never saved.
            - A plain save has nowhere to write and must fail with `.noURL`.
            """
        case .saveAfterFailedOpenWithNoFileOpen:
            """
            - No file is open and the user opens a non-existing file.
            - A failed open must not leave a location behind.
            - A plain save must fail with `.noURL`.
            """
        case .saveAfterFailedOpenKeepsOriginal:
            """
            - A file is open and the user opens a non-existing file.
            - A plain save must still write the original file.
            - The non-existing file must not be created.
            """

        // Modification state
        case .newFileIsUnmodified:
            """
            - Create a new file with a default text.
            - The bridge must report unmodified.
            """
        case .newChangedFileIsModified:
            """
            - Create a new file with a default text.
            - Modify the content.
            - The bridge must report the content as modified.
            """
        case .openedFileIsUnmodified:
            """
            - Open an existing file.
            - The bridge must report unmodified.
            """
        case .openedFileChangedIsModified:
            """
            - Open an existing file.
            - Modify the content.
            - The bridge must report the file as modified.
            """
        case .savedFileIsUnmodified:
            """
            - Open an existing file.
            - Modify the content.
            - The bridge must report the file as modified.
            - Save the modified file.
            - The bridge must report the file unmodified.
            """
        case .savedFileAsIsUnmodified:
            """
            - Open an existing file.
            - Save the existing file to a new file URL.
            - The bridge must report the file as unmodified.
            """
        }
    }
}

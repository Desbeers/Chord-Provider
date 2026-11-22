//
//  SourceEditorError.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation

/// Source Editor errors.
public enum SourceEditorError: Error, LocalizedError {

    /// The editor has no URL.
    /// - Note: This should not happen; the GUI should block a straight save
    ///         button if the file is new. There is an `.enabled` modifier
    ///         for that for a `MenuButton`.
    case noURL
    /// The file is renamed or deleted.
    case fileDeleted( _: URL)
    /// The file is externally modified.
    case externallyModified( _: URL)
    /// Failure.
    case failed(_: String)
    /// The description of the error.
    public var errorDescription: String? {
        switch self {
        case .noURL:
            "The editor has no file location."
        case .fileDeleted(let url):
            "The file \(url.lastPathComponent) has been renamed or deleted."
        case .externallyModified(let url):
            "The file \(url.lastPathComponent) was modified by another program."
        case .failed(let message):
            message
        }
    }
}

//
//  SourceEditorError.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView

/// Source Editor errors.
public enum SourceEditorError: Error, LocalizedError {
    /// The editor has no URL.
    case noURL
    /// Failure
    case failed(_: String)
}

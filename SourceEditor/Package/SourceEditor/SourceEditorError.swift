//
//  SourceEditorError.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView

public enum SourceEditorError: Error, LocalizedError {
    case noURL
    case failed(String)
}

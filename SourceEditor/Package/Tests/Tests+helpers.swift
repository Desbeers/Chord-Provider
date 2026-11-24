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


/// Create a new file in the editor.
/// - Parameter controller: The editor controller.
@MainActor
func newFile(controller: Editor.Controller) {
    controller.new(Static.newText)
    record("New file with '\(Static.newText)'", controller.text == Static.newText)
}


/// Open a file in the controller and require that it worked.
/// - Parameters:
///   - url: The URL to open.
///   - controller: The editor controller
/// - Throws: SourceEditor error.
@MainActor
func openFile(_ url: URL, controller: Editor.Controller) throws {
    let result = try #require(
        waitForCompletion {
            controller.open(url, completion: $0)
        },
        "The open action never completed."
    )
    switch result {
    case .success:
        record("Opened test file '\(url.lastPathComponent)'", true)
    case .failure:
        throw SourceEditorError.failed("Could not open required test file '\(url.lastPathComponent)'")
    }
}

//
//  Tests+open.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//


import Testing
import Foundation
import CGtkSourceView
@testable import SourceEditor

@MainActor
@Suite("File opening", .serialized)
struct OpenTests {

    /// A fresh controller for every test.
    let editor: TestEditor

    init() throws {
        // GTK has to be initialized before any GTK object is created.
        try #require(Static.gtkReady, "GTK could not be initialized; is there a display?")
        editor = TestEditor()
    }

    @Test
    func openNoneExistingFileWhileEmpty() throws {
        header(.openNoneExistingFileWhileEmpty)
        record(
            "No file is open.",
            editor.bridge.fileURL == nil
        )
        let url = URL(fileURLWithPath: "/tmp/\(UUID().uuidString).txt")
        let result = try #require(
            waitForCompletion {
                editor.controller.open(url, completion: $0)
            },
            "The open action never completed."
        )
        record(
            "'\(url.lastPathComponent)' failed to open.",
            result.failed
        )
        let bridgeFile = editor.bridge.fileURL
        record(
            "bridge.fileURL: \(bridgeFile?.lastPathComponent ?? "None").",
            bridgeFile == nil
        )
    }

    @Test
    func openNoneExistingFileWhileLoaded() throws {
        header(.openNoneExistingFileWhileLoaded)
        let currentURL = try #require(
            Bundle.module.url(forResource: "testfile", withExtension: "md"),
            "Test resource testfile.md is missing from the bundle."
        )
        try openFile(currentURL, controller: editor.controller)
        let nonExistingURL = URL(fileURLWithPath: "/tmp/\(UUID().uuidString).txt")
        let result = try #require(
            waitForCompletion {
                editor.controller.open(nonExistingURL, completion: $0)
            },
            "The open action never completed."
        )
        record(
            "The non-existing '\(nonExistingURL.lastPathComponent)' failed to open.",
            result.failed
        )
        let compare = editor.bridge.fileURL?.path == currentURL.path
        record(
            "The previous URL '\(currentURL.lastPathComponent)' is still in place.",
            compare
        )
    }

    @Test
    func openExistingFile() throws {
        header(.openExistingFile)
        let url = try #require(
            Bundle.module.url(forResource: "testfile", withExtension: "md"),
            "Test resource testfile.md is missing from the bundle."
        )
        let result = try #require(
            waitForCompletion { editor.controller.open(url, completion: $0) },
            "The open action never completed."
        )
        record(
            "'\(url.lastPathComponent)' opened.",
            result.success
        )
        // Compare paths: the controller builds its URL from a C string, so the
        // URL objects can differ in form while pointing at the same file.
        let compare = editor.bridge.fileURL?.path == url.path
        record(
            "bridge.fileURL is '\(editor.bridge.fileURL?.lastPathComponent ?? "None")'.",
            compare
        )
    }
}

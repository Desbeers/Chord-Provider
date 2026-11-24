//
//  Tests+save.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//


import Testing
import Foundation
import CGtkSourceView
@testable import SourceEditor

@MainActor
@Suite("File saving", .serialized)
final class SaveTests {

    /// A fresh controller for every test.
    let editor: TestEditor
    /// A private folder for the files of one test.
    let directory: URL

    init() throws {
        // GTK has to be initialized before any GTK object is created.
        try #require(Static.gtkReady, "GTK could not be initialized; is there a display?")
        editor = TestEditor()
        directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    deinit {
        try? FileManager.default.removeItem(at: directory)
    }

    // MARK: Helpers

    /// Copy the bundle test file to the temporary folder, so the bundle is never modified.
    func makeTestFile() throws -> URL {
        let source = try #require(
            Bundle.module.url(forResource: "testfile", withExtension: "md"),
            "Test resource testfile.md is missing from the bundle."
        )
        let url = directory.appendingPathComponent("testfile.md")
        try FileManager.default.copyItem(at: source, to: url)
        return url
    }

    /// Expect a failed result with a specific error.
    func expectFailure(_ result: Result<Void, Error>, _ expected: SourceEditorError) {
        guard case .failure(let error) = result else {
            fail("There was no error, expected '\(expected.localizedDescription)'.")
            return
        }
        let expectedError = error as? SourceEditorError == expected
        record("Expected error: \(expected.localizedDescription)", expectedError)
    }

    // MARK: Tests

    @Test
    func saveOpenedFile() throws {
        header(.saveOpenedFile)
        let url = try makeTestFile()
        try openFile(url, controller: editor.controller)

        let result = try #require(
            waitForCompletion {
                editor.controller.save(completion: $0)
            },
            "The save action never completed."
        )
        record("'\(url.lastPathComponent)' saved.", result.success)
    }

    @Test
    func saveDeletedFile() throws {
        header(.saveDeletedFile)
        let url = try makeTestFile()
        try openFile(url, controller: editor.controller)
        try FileManager.default.removeItem(at: url)

        let result = try #require(
            waitForCompletion {
                editor.controller.save(completion: $0)
            }
        )
        expectFailure(result, .fileDeleted(url))
    }

    @Test
    func saveModifiedFile() throws {
        header(.saveModifiedFile)
        let url = try makeTestFile()
        try openFile(url, controller: editor.controller)

        // Change the modification date explicitly, so the test does not depend
        // on the timestamp resolution of the file system.
        try FileManager.default.setAttributes(
            [.modificationDate: Date().addingTimeInterval(60)],
            ofItemAtPath: url.path
        )

        let result = try #require(waitForCompletion { editor.controller.save(completion: $0) })
        expectFailure(result, .externallyModified(url))
    }

    @Test
    func saveNewFileWithURL() throws {
        header(.saveNewFileWithURL)
        let url = directory.appendingPathComponent("new.txt")
        newFile(controller: editor.controller)
        let result = try #require(
            waitForCompletion {
                editor.controller.save(
                    to: url,
                    completion: $0
                )
            },
            "The save action never completed."
        )
        record("'\(url.lastPathComponent)' saved.", result.success)
        let saved = try String(contentsOf: url, encoding: .utf8).trimmingCharacters(in: .newlines)
        record("'\(url.lastPathComponent)' contains '\(saved)'; expected '\(Static.newText)'.", saved == Static.newText)
    }

    @Test
    func saveNewFileWithoutURL() throws {
        header(.saveNewFileWithoutURL)
        newFile(controller: editor.controller)
        let result = try #require(
            waitForCompletion {
                editor.controller.save(completion: $0)
            }
        )
        expectFailure(result, .noURL)
    }
}

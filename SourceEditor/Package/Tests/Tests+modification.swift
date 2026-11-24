//
//  Tests+modifications.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//


import Testing
import Foundation
import Adwaita
import CGtkSourceView
@testable import SourceEditor

@MainActor
@Suite("Modification state")
final class ModifiedTests {

    let editor: TestEditor
    let directory: URL

    init() throws {
        try #require(Static.gtkReady, "GTK could not be initialized; is there a display?")
        editor = TestEditor()
        directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    deinit {
        try? FileManager.default.removeItem(at: directory)
    }

    /// Copy the bundle test file to the temporary folder.
    func makeTestFile() throws -> URL {
        let source = try #require(
            Bundle.module.url(forResource: "testfile", withExtension: "md"),
            "Test resource testfile.md is missing from the bundle."
        )
        let url = directory.appendingPathComponent("test.md")
        try FileManager.default.copyItem(at: source, to: url)
        return url
    }

    @Test
    func newIsUnmodified() {
        header(.newFileIsUnmodified)
        newFile(controller: editor.controller)
        record("The new file is \(editor.bridge.modified ? "modified" : "unmodified").", !editor.bridge.modified)
    }

    @Test
    func newChangedFileIsModified() {
        header(.newChangedFileIsModified)
        newFile(controller: editor.controller)
        editor.controller.command(.replaceAllText(Static.alteredText))
        record("Alter text to '\(Static.alteredText)'", editor.controller.text == Static.alteredText)
        record("The new file is \(editor.bridge.modified ? "modified" : "unmodified").", editor.bridge.modified)
    }

    @Test
    func openedFileIsUnmodified() throws {
        header(.openedFileIsUnmodified)
        let file = try makeTestFile()
        try openFile(file, controller: editor.controller)
        record("The file is \(editor.bridge.modified ? "modified" : "unmodified").", !editor.bridge.modified)
    }

    @Test
    func openedFileChangedIsModified() throws {
        header(.openedFileChangedIsModified)
        try openFile(try makeTestFile(), controller: editor.controller)
        editor.controller.command(.replaceAllText(Static.alteredText))
        record("Alter text to '\(Static.alteredText)'", editor.controller.text == Static.alteredText)
        record("The file is \(editor.bridge.modified ? "modified" : "unmodified").", editor.bridge.modified)
    }

    @Test
    func savedFileIsUnmodified() throws {
        header(.savedFileIsUnmodified)
        try openFile(try makeTestFile(), controller: editor.controller)
        editor.controller.command(.replaceAllText(Static.alteredText))
        record("Alter text to '\(Static.alteredText)'", editor.controller.text == Static.alteredText)
        record("The file is \(editor.bridge.modified ? "modified" : "unmodified").", editor.bridge.modified)
        let result = try #require(
            waitForCompletion {
                editor.controller.save(completion: $0)
            },
            "The save action never completed."
        )
        record("The file is saved.", result.success)
        record("The file is \(editor.bridge.modified ? "modified" : "unmodified").", !editor.bridge.modified)
    }

    @Test
    func savedFileAsIsUnmodified() throws {
        header(.savedFileAsIsUnmodified)
        try openFile(try makeTestFile(), controller: editor.controller)
        let url = directory.appendingPathComponent("saved-as.md")
        let result = try #require(
            waitForCompletion {
                editor.controller.save(to: url, completion: $0)
            },
            "The save action never completed."
        )
        record("The file is saved as '\(url.lastPathComponent)'.", result.success)
        record("The file is \(editor.bridge.modified ? "modified" : "unmodified").", !editor.bridge.modified)
    }
}

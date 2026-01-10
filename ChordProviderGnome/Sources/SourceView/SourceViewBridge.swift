//
//  SourceViewBridge.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

public struct SourceViewBridge: Equatable {
    /// Confirm to `Equatable`
    public static func ==(lhs: SourceViewBridge, rhs: SourceViewBridge) -> Bool {
        lhs.currentLine == rhs.currentLine && lhs.song.content == rhs.song.content
    }

    /// The song
    public var song: Song

    /// One-shot command for the editor
    public var command: SourceViewCommand?

    /// The current cursor line
    public var currentLine: Int

    /// Bool if the editor is at the start of a line
    /// - Note: Used to check if 'insert' commands are available
    public var isAtBeginningOfLine: Bool = false

    /// Bool if the editor has a selction
    public var hasSelection: Bool = false

    public init(
        song: Song,
        command: SourceViewCommand? = nil,
        currentLine: Int = 1
    ) {
        self.song = song
        self.command = command
        self.currentLine = currentLine
    }
}

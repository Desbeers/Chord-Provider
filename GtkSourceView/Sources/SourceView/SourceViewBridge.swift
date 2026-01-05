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

    /// 1-based current cursor line
    public var currentLine: Int

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

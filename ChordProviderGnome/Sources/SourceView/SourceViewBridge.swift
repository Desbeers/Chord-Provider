//
//  SourceViewBridge.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

public struct SourceViewBridge: Equatable {

    /// Equatable protocol
    public static func == (lhs: SourceViewBridge, rhs: SourceViewBridge) -> Bool {
        lhs.currentLine == rhs.currentLine && lhs.song.content == rhs.song.content
    }

    /// The song
    public var song = Song(id: UUID(), content: "")

    /// The core settings
    public var coreSettings = ChordProviderSettings()

    /// One-shot command for the editor
    public var command: SourceViewCommand?

    /// The current cursor line
    public var currentLine = Song.Section.Line()

    /// Bool if the editor is at the start of a line
    /// - Note: Used to check if 'insert' commands are available
    public var isAtBeginningOfLine: Bool = false

    /// All the lines in the song
    public var songLines = [Song.Section.Line]()

    /// Bool if the editor has a selection
    public var hasSelection: Bool = false

    /// Show the *Edit directive* dialog
    public var showEditDirectiveDialog: Bool = false

    /// The directive to handle in the *Edit directive* dialog
    public var handleDirective: ChordPro.Directive?

    /// Init the bridge
    public init() {}
}

extension SourceViewBridge: Codable {

    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the settings
        case coreSettings
    }
}

//
//  Extensions.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension ChordProviderSettings {

    var transposeTooltip: String {
        var text = "Transpose"
        if self.transpose == 0 {
            text += " the song"
        } else {
            text += " by \(self.transpose) semitones"
        }
        return text
    }
}

extension Song {

    /// The intentional name of the song file
    public func initialName(format: ChordProviderSettings.Export.Format) -> String {
        var name = settings.fileURL?.deletingPathExtension().lastPathComponent ?? "\(metadata.artist) - \(metadata.title)"
        /// Add the extension
        name.append(".\(format.rawValue)")
        return name
    }
}

extension String {

    func contains(_ strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }
}

extension String {

    func escapeHTML() -> String {
        if self.contains(["<", ">"]) {
            /// The string contains Pango markup; don't escape
            return self
        } else {
            /// Escape special markup characters
            var escapedString = self.replacingOccurrences(of: "&", with: "&amp;")
            escapedString = escapedString.replacingOccurrences(of: "\"", with: "&quot;")
            escapedString = escapedString.replacingOccurrences(of: "'", with: "&#39;")
            return escapedString
        }
    }
}

/// Make a String identifiable
struct ElementWrapper: Identifiable, Equatable {

    var id = UUID()
    var content: String

}

extension String {
    
    /// Wrap text into separate lines and make it identifiable
    /// - Parameter length: The maximum length
    /// - Returns: The wrapped text in an array
    func wrap(by length: Int) -> [ElementWrapper] {
        self.split(by: length).map { ElementWrapper(content: $0) }
    }
}

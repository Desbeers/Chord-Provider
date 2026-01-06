//
//  Extensions.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita
import CAdw

extension Song {

    var transposeTooltip: String {
        var text = "Transpose"
        if self.transposing == 0 {
            text += " the song"
        } else {
            text += " by \(self.transposing) semitones"
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
            var escaped = self
            escaped = escaped.replacingOccurrences(of: "&", with: "&amp;")
            escaped = escaped.replacingOccurrences(of: "<", with: "&lt;")
            escaped = escaped.replacingOccurrences(of: ">", with: "&gt;")
            escaped = escaped.replacingOccurrences(of: "\"", with: "&quot;")
            escaped = escaped.replacingOccurrences(of: "'", with: "&apos;")
            return escaped
        }
    }
}

extension String {

    /// Wrap text into separate lines and make it identifiable
    /// - Parameter length: The maximum length
    /// - Returns: The wrapped text in an array
    func wrap(by length: Int) -> [ElementWrapper] {
        self.split(by: length).map { ElementWrapper(content: $0) }
    }

    /// Make a String identifiable
    struct ElementWrapper: Identifiable, Equatable {
        var id = UUID()
        var content: String
    }
}

extension String {

    func toUnsafeMutablePointer() -> UnsafeMutablePointer<Int8>? {
        return strdup(self)
    }
}

extension Chord.Instrument: @retroactive ViewSwitcherOption {
    public var title: String {
        self.description
    }

    public var icon: Adwaita.Icon {
        .default(icon: .folderMusic)
    }
}

extension Chord.Root: @retroactive ToggleGroupItem {
    public var icon: Adwaita.Icon? {
        nil
    }

    public var showLabel: Bool {
        true
    }
}

extension ChordProviderSettings {
    var settingsLabel: String {
        var label: [String] = [self.instrument.description]
        if self.lyricsOnly {
            label.append("Lyrics only")
        }
        if self.repeatWholeChorus {
            label.append("Repeat whole chorus")
        }
        return label.joined(separator: ", ")
    }
}

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
            var escapedString = self.replacing("&", with: "&amp;")
            escapedString = escapedString.replacing("\"", with: "&quot;")
            escapedString = escapedString.replacing("'", with: "&#39;")
            return escapedString
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

    func toUnsafePointer() -> UnsafePointer<UInt8>? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        let stream = OutputStream(toBuffer: buffer, capacity: data.count)
        stream.open()
        let value = data.withUnsafeBytes {
            $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
        }
        guard let val = value else {
            return nil
        }
        stream.write(val, maxLength: data.count)
        stream.close()

        return UnsafePointer<UInt8>(buffer)
    }

    func toUnsafeMutablePointer() -> UnsafeMutablePointer<Int8>? {
        return strdup(self)
    }
}

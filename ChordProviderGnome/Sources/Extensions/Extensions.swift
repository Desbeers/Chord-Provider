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
        _ = stream.write(val, maxLength: data.count)
        stream.close()

        return UnsafePointer<UInt8>(buffer)
    }

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

extension LogUtils.Level {

    var style: Markup.Class {
        switch self {
        case .info:
            Markup.Class.logInfo
        case .warning:
            Markup.Class.logWarning
        case .error:
            Markup.Class.logError
        case .debug:
            Markup.Class.logDebug
        case .notice:
            Markup.Class.logNotice
        case .fault:
            Markup.Class.logFault
        }
    }
}

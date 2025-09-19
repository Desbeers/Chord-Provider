//
//  ChordProParser+helpers.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Get the full URL of an image
    /// - Parameters:
    ///   - source: The image source as defined in the song
    ///   - fileURL: The optional URL of the song file
    /// - Returns: An optional URL of the image
    public static func getImageURL( _ source: String, fileURL: URL?) -> URL? {
        var source = source
        if source.starts(with: "http") {
            /// Internet image
        } else if source.starts(with: "/") {
            /// Full local path
            source = "file:\(source)"
        } else {
            /// Image next to a song
            if let fileURL {
                let path = fileURL.deletingLastPathComponent().appending(path: source).path()
                source = "file:\(path)"
            }
        }
        return URL(string: source)
    }

    /// Get the offset of a **ChordPro** directive
    /// - Parameter arguments: The arguments of the directive in the song
    /// - Returns: The offset as `CGSize`
    public static func getOffset(_ arguments: ChordProParser.DirectiveArguments?) -> CGSize {
        var offset = CGSize(width: 0, height: 0)
        if let x = arguments?[.x], let value = Double(x) {
            offset.width = value
        }
        if let y = arguments?[.y], let value = Double(y) {
            offset.height = value
        }
        return offset
    }

    /// Remember the longest label for an environment
    /// - Note: Used in PDF output to calculate label offset
    static func setLongestLabel(label: String, song: inout Song) {
        if label.count > song.metadata.longestLabel.count {
            song.metadata.longestLabel = label
        }
    }

//    static func calculateSource(line: Song.Section.Line) -> String {
//        /// Check for arguments
//        if let arguments = ChordProParser.lineArgumentsToString(line) {
//            return "{\(line.directive.rawValue.long) \(arguments)}"
//        }
//        /// Only a directive
//        return "{\(line.directive.rawValue.long)}"
//    }
}

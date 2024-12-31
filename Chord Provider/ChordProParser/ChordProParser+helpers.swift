//
//  ChordProParser+helpers.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension ChordProParser {

    /// Get the full URL of an image
    /// - Parameters:
    ///   - source: The image source as defined in the song
    ///   - fileURL: The optional URL of the song file
    /// - Returns: An optional URL of the image
    static func getImageURL( _ source: String, fileURL: URL?) -> URL? {
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

    /// Get the size of an image
    /// - Parameters:
    ///   - image: The `NSImage`
    ///   - arguments: The arguments of the image in the song
    /// - Returns: The `CGSize` of the image
    static func getImageSize(image: NSImage, arguments: Arguments?) -> CGSize {
        var scale: Double = 1
        if let scaleArgument = arguments?[.scale], let value = Double(scaleArgument.replacingOccurrences(of: "%", with: "")) {
            /// - Note: Never let is be zero or else it will disappear from the SwiftUI View
            scale = max(value / 100, 0.1)
        }

        var size = CGSize(width: image.size.width, height: image.size.height)
        if let widthArgument = arguments?[.width], let value = Double(widthArgument) {
            /// Keep aspect ratio
            size.height *= (value / size.width)
            size.width = value
        }
        if let heightArgument = arguments?[.height], let value = Double(heightArgument) {
            /// Keep aspect ratio
            size.width *= (value / size.height)
            size.height = value
        }
        let scaled = CGSize(width: size.width * scale, height: size.height * scale)
        return scaled
    }

    /// Get the offset of a **ChordPro** directive
    /// - Parameter arguments: The arguments of the directive in the song
    /// - Returns: The offset as `CGSize`
    static func getOffset(_ arguments: ChordProParser.Arguments?) -> CGSize {
        var offset = CGSize(width: 0, height: 0)
        if let x = arguments?[.x], let value = Double(x) {
            offset.width = value
        }
        if let y = arguments?[.y], let value = Double(y) {
            offset.height = value
        }
        return offset
    }
}

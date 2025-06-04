//
//  ImageUtils.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

/// Utilities to deal with images
enum ImageUtils {
    // Just a placeholder
}

extension ImageUtils {

    /// Get the size of an image
    /// - Parameters:
    ///   - image: The `NSImage`
    ///   - arguments: The arguments of the image in the song
    /// - Returns: The `CGSize` of the image
    static func getImageSize(image: NSImage, arguments: ChordProParser.DirectiveArguments?) -> CGSize {
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
}

//
//  SongExport+images.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import ChordProviderCore

extension SongExport {

    /// Load an image from the cache if found or else from an URL
    /// - Parameters:
    ///   - source: The image source as defined in the song
    ///   - fileURL: The optional URL of the song file
    /// - Returns: An image
    static func loadImage(source: String, fileURL: URL?) async -> NSImage? {
        guard let imageURL = ChordProParser.getImageURL(source, fileURL: fileURL) else { return nil }
        var image: NSImage?
        if let imageFromCache = ImageCache.shared.getImageFromCache(from: imageURL) {
            image = imageFromCache
        } else {
            let task = Task.detached {
                try? Data(contentsOf: imageURL)
            }
            guard let data = await task.value, let nsImage = NSImage(data: data) else {
                LogUtils.shared.setLog(
                    type: .error,
                    category: .fileAccess,
                    message: "Missing image for **\(imageURL.lastPathComponent)**"
                )
                return nil
            }
            image = nsImage
        }
        return image
    }
}

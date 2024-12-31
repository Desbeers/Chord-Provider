//
//  SongExport+images.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import OSLog

extension SongExport {

    /// Load an image from the cache if found or else from an URL
    /// - Parameters:
    ///   - source: The image source as defined in the song
    ///   - fileURL: The optional URL of the song file
    /// - Returns: <#description#>
    static func loadImage(source: String, fileURL: URL?) async -> NSImage? {
        guard let imageURL = ChordProParser.getImageURL(source, fileURL: fileURL) else { return nil }
        var image: NSImage?
        if let imageFromCache = ImageCache.shared.getImageFromCache(from: imageURL) {
            image = imageFromCache
            Logger.pdfBuild.notice("Image from cache: \(imageURL.lastPathComponent, privacy: .public)")
        } else {
            let task = Task.detached {
                try? Data(contentsOf: imageURL)
            }
            guard let data = await task.value, let nsImage = NSImage(data: data) else {
                Logger.pdfBuild.error("Missing image for **\(imageURL.lastPathComponent, privacy: .public)**")
                return nil
            }
            Logger.pdfBuild.notice("Loading image: \(imageURL.lastPathComponent, privacy: .public)")
            image = nsImage
        }
        return image
    }
}

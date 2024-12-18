//
//  SongExport+images.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit
import OSLog

extension SongExport {

    static func loadImage(source: String, fileURL: URL?) async -> NSImage? {
        guard let imageURL = ChordProParser.getImageSource(source, fileURL: fileURL) else { return nil }
        var image: NSImage?
        if let imageFromCache = AppStateModel.shared.getImageFromCache(from: imageURL) {
            image = imageFromCache
            Logger.application.notice("Image from cache: \(imageURL.lastPathComponent, privacy: .public)")
        } else {
            Logger.application.notice("Loading image: \(imageURL.lastPathComponent, privacy: .public)")
            let task = Task.detached {
                try? Data(contentsOf: imageURL)
            }
            guard let data = await task.value, let nsImage = NSImage(data: data) else {
                Logger.application.error("Error loading image: \(imageURL.lastPathComponent, privacy: .public)")
                return nil
            }
            image = nsImage
        }
        return image
    }
}

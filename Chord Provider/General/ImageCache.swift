//
//  ImageCache.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

final class ImageCache {

    nonisolated(unsafe) static let shared = ImageCache()

    var imageCache: NSCache<NSURL, NSImage> = .init()

    func setImageCache(image: NSImage, key: URL) {
        imageCache.setObject(image, forKey: key as NSURL)
    }

    func getImageFromCache(from key: URL) -> NSImage? {
        imageCache.object(forKey: key as NSURL)
    }

    private init() {}
}

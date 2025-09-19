//
//  ImageCache.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

/// Shared class with a memory cache of images from songs
final class ImageCache {
    /// The shared instance of the class
    nonisolated(unsafe) static let shared = ImageCache()
    /// The image cache
    var imageCache: NSCache<NSURL, NSImage> = .init()
    /// Set an image to the cache
    func setImageCache(image: NSImage, key: URL) {
        imageCache.setObject(image, forKey: key as NSURL)
    }
    /// Get a image from the cache
    func getImageFromCache(from key: URL) -> NSImage? {
        imageCache.object(forKey: key as NSURL)
    }
    /// Private init to make sure only the *shared* instance is used
    private init() {}
}

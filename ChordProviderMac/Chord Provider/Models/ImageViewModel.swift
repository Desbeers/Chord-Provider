//
//  ImageViewModel.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import ChordProviderCore

/// The observable state for an image in a **ChordPro** song
@Observable @MainActor final class ImageViewModel {
    /// The `NSImage`
    var image = NSImage()
    /// The size of the image
    var size = CGSize(width: 100, height: 80)
    /// The arguments of the image from the song source
    var arguments: ChordProParser.DirectiveArguments?
    /// The optional URL of the song file
    var fileURL: URL?
    /// Init the model
    init(arguments: ChordProParser.DirectiveArguments?, fileURL: URL?) {
        self.arguments = arguments
        self.fileURL = fileURL
    }

    /// Update the arguments of the image
    /// - Parameter arguments: The new directive arguments
    func updateArguments(_ arguments: ChordProParser.DirectiveArguments?) async {
        self.arguments = arguments
        let url = ChordProParser.getImageURL(arguments?[.src] ?? "", fileURL: fileURL)
        await loadImage(url: url)
    }

    /// Load an image from the cache if found or else from an URL
    /// - Parameter url: The URL of the image
    private func loadImage(url: URL?) async {
        guard let url else { return }
        if let imageFromCache = ImageCache.shared.getImageFromCache(from: url) {
            self.image = imageFromCache
            self.size = ImageUtils.getImageSize(image: imageFromCache, arguments: arguments)
            return
        }

        await loadImageFromURL(url: url)
    }

    /// Load an image from an URL
    /// - Parameter url: The URL of the image
    private func loadImageFromURL(url: URL) async {
        let task = Task.detached {
            try? Data(contentsOf: url)
        }
        guard let data = await task.value, let loadedImage = NSImage(data: data) else {
            self.fallbackImage(url: url)
            return
        }
        self.image = loadedImage
        self.size = ImageUtils.getImageSize(image: loadedImage, arguments: self.arguments)
        ImageCache.shared.setImageCache(image: loadedImage, key: url)
    }

    /// Create a fallback image
    /// - Parameter url: The URL of the original image
    private func fallbackImage(url: URL) {
        LogUtils.shared.setLog(
            level: .error,
            category: .fileAccess,
            message: "Missing image for **\(url.lastPathComponent)**"
        )
        // swiftlint:disable:next force_unwrapping
        let fallbackImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)!
        self.size = CGSize(width: 100, height: 80)
        self.image = fallbackImage
    }
}

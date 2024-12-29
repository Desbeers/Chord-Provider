//
//  ImageViewModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit
import OSLog

@Observable @MainActor final class ImageViewModel {
    var image = NSImage()
    var size = CGSize(width: 100, height: 80)
    var arguments: ChordProParser.Arguments?
    var fileURL: URL?
    let scale: Double

    init(arguments: ChordProParser.Arguments?, fileURL: URL?, scale: Double) {
        self.arguments = arguments
        self.fileURL = fileURL
        self.scale = scale
    }

    func updateArguments(_ arguments: ChordProParser.Arguments?) async {
        self.arguments = arguments
        let url = ChordProParser.getImageSource(arguments?[.src] ?? "", fileURL: fileURL)
        await loadImage(url: url)
    }

    private func loadImage(url: URL?) async {
        guard let url else { return }
        if let imageFromCache = ImageCache.shared.getImageFromCache(from: url) {
            Logger.viewBuild.notice("Image from cache: \(url.lastPathComponent, privacy: .public)")
            self.image = imageFromCache
            self.size = ChordProParser.getImageSize(image: imageFromCache, arguments: arguments)
            return
        }

        await loadImageFromURL(url: url)
    }

    private func loadImageFromURL(url: URL) async {
        let task = Task.detached {
            try? Data(contentsOf: url)
        }
        guard let data = await task.value, let loadedImage = NSImage(data: data) else {
            self.fallbackImage(url: url)
            return
        }
        Logger.viewBuild.notice("Loading image: \(url.lastPathComponent, privacy: .public)")
        self.image = loadedImage
        self.size = ChordProParser.getImageSize(image: loadedImage, arguments: self.arguments)
        ImageCache.shared.setImageCache(image: loadedImage, key: url)
    }

    private func fallbackImage(url: URL) {
        Logger.viewBuild.error("Missing image for **\(url.lastPathComponent, privacy: .public)**")
        // swiftlint:disable:next force_unwrapping
        let fallbackImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)!
        self.size = CGSize(width: 100, height: 80)
        self.image = fallbackImage
    }
}

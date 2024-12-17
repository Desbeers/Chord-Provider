//
//  ImageViewModel.swift
//  Chord Provider
//
//  //  © 2024 Nick Berendsen
//

import AppKit
import OSLog

@Observable @MainActor class ImageViewModel {
    // swiftlint:disable:next force_unwrapping
    var image = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)!
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
        if let imageFromCache = AppStateModel.shared.getImageFromCache(from: url) {
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
            self.fallbackImage()
            return
        }
        self.image = loadedImage
        self.size = ChordProParser.getImageSize(image: loadedImage, arguments: self.arguments)
        AppStateModel.shared.setImageCache(image: loadedImage, key: url)

//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard error == nil else {
//                Logger.application.error("Error loading image: \(error, privacy: .public)")
//                self.fallbackImage()
//                return
//            }
//            DispatchQueue.main.async { [weak self] in
//                guard let data = data, let loadedImage = NSImage(data: data) else {
//                    Logger.application.error("Error loading image: No data found")
//                    self?.fallbackImage()
//                    return
//                }
//                self?.image = loadedImage
//                self?.size = ChordProParser.getImageSize(image: loadedImage, arguments: self?.arguments)
//                AppStateModel.shared.setImageCache(image: loadedImage, key: url)
//            }
//        }
//        .resume()
    }

    private func fallbackImage() {
        // swiftlint:disable:next force_unwrapping
        let fallbackImage = NSImage(systemSymbolName: "photo", accessibilityDescription: nil)!
        self.size = CGSize(width: 100, height: 80)
        self.image = fallbackImage
    }
}

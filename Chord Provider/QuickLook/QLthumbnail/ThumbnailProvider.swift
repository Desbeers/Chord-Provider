//
//  ThumbnailProvider.swift
//  Chord Provider - QLthumbnail
//
//  © 2024 Nick Berendsen
//

import AppKit
import OSLog
import QuickLookThumbnailing

/// Create a simple icon for a **ChordPro** file
class ThumbnailProvider: QLThumbnailProvider {

    override func provideThumbnail(
        for request: QLFileThumbnailRequest,
        _ handler: @escaping (QLThumbnailReply?, Error?) -> Void
    ) {
        if let icon = Bundle.main.url(forResource: "FileIcon", withExtension: "png") {
            let qlThumbnailReply = QLThumbnailReply(imageFileURL: icon)
            qlThumbnailReply.extensionBadge = "ChordPro"

            handler(qlThumbnailReply, nil)
        }
        Logger.thumbnailProvider.log(
            "Make thumbnail for \(request.fileURL.lastPathComponent, privacy: .public) failed"
        )
        handler(nil, nil)
    }
}

/// Messages for the Logger
extension Logger {

    /// The name of the subsystem
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""

    /// Log thumbnail provider messages
    static var thumbnailProvider: Logger {
        Logger(subsystem: subsystem, category: "Thumbnail Provider")
    }
}

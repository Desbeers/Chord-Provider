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

        guard let nsImage = NSImage(named: "FileIcon"), let fileContents = try? String(contentsOf: request.fileURL, encoding: .utf8) else {
            Logger.application.error(
                "Resources not found"
            )
            return handler(nil, nil)
        }
        var extensionBadge = "ChordPro"
        let title = /{title(.+?)}/
        if let result = try? title.firstMatch(in: fileContents) {
            extensionBadge = String(result.1).replacingOccurrences(of: ":", with: "").trimmingCharacters(in: .whitespaces)
        }

        var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: nsImage.size)
        let cgImage = nsImage.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)

        /// Set the icon content size in a 4:3 ratio
        let contextSize = CGSize(width: request.maximumSize.width * 0.66, height: request.maximumSize.height)
        /// The frame for the image in a 4: 3 ratio and adjusted for scale (retina or not)
        let scaleFrame = CGRect(
            x: 0,
            y: 0,
            width: request.maximumSize.width * 0.66 * request.scale,
            height: request.maximumSize.height * request.scale
        )
        /// Draw icon if all is well
        if let cgImage {
            Logger.application.info(
                "Make thumbnail for \(request.fileURL.lastPathComponent, privacy: .public)"
            )
            let qlThumbnailReply = QLThumbnailReply(contextSize: contextSize) { context -> Bool in
                /// Draw the thumbnail in the provided context
                context.draw(cgImage, in: scaleFrame, byTiling: false)
                return true
            }
            /// Set the proper extension type
            qlThumbnailReply.extensionBadge = extensionBadge
            handler(qlThumbnailReply, nil)
        } else {
            Logger.application.error(
                "Make thumbnail for \(request.fileURL.lastPathComponent, privacy: .public) failed"
            )
        }
    }
}

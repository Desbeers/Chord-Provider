//
//  ThumbnailProvider.swift
//  Chord Provider - QLthumbnail
//
//  © 2023 Nick Berendsen
//

import AppKit
import OSLog
import QuickLookThumbnailing

class ThumbnailProvider: QLThumbnailProvider {

    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
        do {
            let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
            let song = ChordPro.parse(
                id: UUID(),
                text: fileContents,
                transpose: 0,
                instrument: .guitarStandardETuning,
                fileURL: request.fileURL
            )
            let data = try SongExport.export(
                song: song,
                generalOptions: .init(),
                chordDisplayOptions: .init()
            )
            /// Create image for data
            let nsImage = NSImage(data: data.pdf)
            var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: nsImage?.size ?? .zero)
            let cgImage = nsImage?.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)
            /// Set the icon content size in a 4:3 ratio
            let contextSize = CGSize(width: request.maximumSize.width * 0.75, height: request.maximumSize.height)
            /// The frame for the image in a 4: 3 ratio and adjusted for scale (retina or not)
            let scaleFrame = CGRect(
                x: 0,
                y: 0,
                width: request.maximumSize.width * 0.75 * request.scale,
                height: request.maximumSize.height * request.scale
            )
            /// Draw icon if all is well
            if let cgImage {
                Logger.thumbnailProvider.log("Make thumbnail for \(request.fileURL.lastPathComponent, privacy: .public)")
                let qlThumbnailReply = QLThumbnailReply(contextSize: contextSize) { context -> Bool in
                    /// Draw the thumbnail in the provided context
                    context.draw(cgImage, in: scaleFrame, byTiling: false)
                    return true
                }
                /// Set the proper extension type
                qlThumbnailReply.extensionBadge = "ChordPro"
                handler(qlThumbnailReply, nil)
            } else {
                Logger.thumbnailProvider.log("Make thumbnail for \(request.fileURL.lastPathComponent, privacy: .public) failed")
            }
        } catch {
            Logger.thumbnailProvider.log("Make thumbnail error: \(error.localizedDescription, privacy: .public) failed")
        }
    }
}

//
//  ThumbnailProvider.swift
//  Chord Provider - QLthumbnail
//
//  © 2023 Nick Berendsen
//

import QuickLookThumbnailing
import OSLog
import SwiftUI


extension Logger {
    /// Try to use the bundle indentifier
    private static var subsystem = Bundle.main.bundleIdentifier ?? "chordprovider"
    /// Set debug log
    static let debug = Logger(subsystem: subsystem, category: "debug")
}

class ThumbnailProvider: QLThumbnailProvider {

    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
        Task { @MainActor in
            /// Create ethe image with SwiftUI `ImageRenderer`
            /// - Note: Run on the MainActor or else you get a silent fatal error
            let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
            let song = ChordPro.parse(text: fileContents, transpose: 0, instrument: .guitarStandardETuning)
            let renderer = ImageRenderer(content: SongExportView(song: song))
            /// Set the icon content size in a 4:3 ratio
            let contextSize = CGSize(width: request.maximumSize.width * 0.75, height: request.maximumSize.height)
            /// The frame for the image in a 4: 3 ratio and adjusted for scale (retina or not)
            let scaleFrame = CGRect(
                x: 0,
                y: 0,
                width: request.maximumSize.width * 0.75 * request.scale,
                height: request.maximumSize.height * request.scale
            )
            if let image = renderer.cgImage {
                Logger.debug.log("Make thumbnail for \(request.fileURL.lastPathComponent, privacy: .public)")
                let qlThumbnailReply = QLThumbnailReply(contextSize: contextSize) { context -> Bool in
                    /// Draw the thumbnail in the provided context
                    context.draw(image, in: scaleFrame, byTiling: false)
                    return true
                }
                /// Set the proper extension type
                qlThumbnailReply.extensionBadge = "ChordPro"
                handler(qlThumbnailReply, nil)
            } else {
                Logger.debug.log("Make thumbnail for \(request.fileURL.lastPathComponent, privacy: .public) failed")
            }
        }
    }

    /// SwiftUI `View` of the song rendered by the SwiftUI `ImageRenderer`
    /// - Note: Make sure there are no `ScrollView`s anywhere in the final View or else the result will be an empty page
    struct SongExportView: View {
        /// The ``Song``
        let song: Song
        /// The body of the `View`
        var body: some View {
            VStack {
                Text(song.title ?? "Title")
                    .font(.title)
                Text(song.artist ?? "Artist")
                    .font(.title2)
                Song.Render(song: song, options: Song.DisplayOptions(label: .grid, scale: 1, chords: .asName))
            }
            .padding()
            .frame(width: 900, height: 1200, alignment: .topLeading)
            .preferredColorScheme(.light)
            .background(.white)
            .accentColor(Color.gray)
        }
    }
}

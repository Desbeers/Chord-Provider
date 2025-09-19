//
//  Song+transferable.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CoreTransferable
import ChordProviderCore

extension Song: @retroactive Transferable {

    /// Transfer protocol
    public static var transferRepresentation: some TransferRepresentation {

        /// Export the source of the song as file
        /// - Works fine in Finder
        /// - When dropped into a Pages document, nothing happen; needs the proxy below to work
        /// - When dropped on the Pages icon, a new document is created with the content of the song
        /// - Mail is empty
        /// - Messages is showing the content, not the file
        /// - Notes is empty
        FileRepresentation(exportedContentType: .chordProSong) { song in
            SentTransferredFile(song.metadata.sourceURL, allowAccessingOriginalFile: false)
        }
        .suggestedFileName { song in
            "\(song.metadata.exportName).chordpro"
        }

        /// Just export the content
        /// - When dropped into a Page document, the content is insert
        /// - When dropped into a Textmate document, the content is insert
        ProxyRepresentation(exporting: \.content)
    }
}

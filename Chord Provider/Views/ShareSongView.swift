//
//  ShareSongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View for the Share Button`
struct ShareSongView: View {
    /// The export URL
    let exportURL: URL
    /// The body of the `View`
    var body: some View {
        ShareLink(item: exportURL)
            .labelStyle(.iconOnly)
    }
}

//
//  Views+Welcome+recentSongsView.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension Views.Welcome {

    // MARK: Recent Songs View

    /// The `View` with **Recent** songs
    @ViewBuilder var recentSongsView: Body {
        VStack(spacing: 20) {
            ScrollView {
                if recentSongs.getRecentSongs().isEmpty {
                    StatusPage(
                        "No recent songs",
                        icon: .default(icon: .folderMusic),
                        description: "You have no recent songs."
                    )
                    .frame(minWidth: 350)
                } else {
                    VStack(spacing: 10) {
                        ForEach(recentSongs.getRecentSongs()) { recent in
                            openButton(fileURL: recent.url, metadata: recent.metadata)
                        }
                    }
                    .halign(.center)
                    .padding()
                }
            }
            .card()
            .vexpand()
        }
    }
}

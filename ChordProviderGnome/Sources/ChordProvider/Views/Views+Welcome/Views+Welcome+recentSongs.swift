//
//  Views+Welcome+recentSongs.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension Views.Welcome {

    // MARK: Recent Songs View

    /// The `View` with **Recent** songs
    @ViewBuilder var recentSongs: Body {
        VStack(spacing: 20) {
            ScrollView {
                if appState.getRecentSongs().isEmpty {
                    StatusPage(
                        "No recent songs",
                        icon: .default(icon: .folderMusic),
                        description: "You have no recent songs."
                    )
                    .frame(minWidth: 350)
                } else {
                    VStack(spacing: 10) {
                        ForEach(appState.getRecentSongs()) { recent in
                            openButton(fileURL: recent.url, song: recent.song)
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

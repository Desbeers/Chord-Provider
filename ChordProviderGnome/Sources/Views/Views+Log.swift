//
//  Views+Log.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for showing log messages
    struct Log: View {
        /// The body of the `View`
        var view: Body {
            HStack {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(LogUtils.shared.fetchLog()) { line in
                            HStack {
                                Text(line.level.rawValue.capitalized)
                                    .frame(minWidth: 100)
                                    .halign(.start)
                                if let line = line.lineNumber {
                                    Text("Line \(line): ")
                                }
                                Text(line.message)
                                    .useMarkup()
                                    .halign(.start)
                            }
                            .levelStyle(line.level)
                        }
                    }
                    .padding()
                }
                .hexpand()
            }
            .vexpand()
        }
    }
}

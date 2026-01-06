//
//  Views+Debug+log.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Debug {
    
    // MARK: Log View
    
    /// The `Body` for the log messages
    @ViewBuilder var log: Body {
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
                    .logLevelStyle(line.level)
                }
            }
            .padding()
        }
        .hexpand()
        .vexpand()
    }
}

//
//  DebugView+logView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension DebugView {

    /// The log tab of the `View`
    @ViewBuilder var logView: some View {
        ScrollView {
            ScrollViewReader { value in
                LazyVStack(spacing: 0) {
                    /// - Note: This *must* be a LazyVStack or else memory usage will go nuts
                    ForEach(logs) { log in
                        VStack(alignment: .leading, spacing: 0) {
                            Divider()
                            HStack(alignment: .top, spacing: 0) {
                                Image(systemName: "exclamationmark.bubble")
                                    .foregroundStyle(log.level.color)
                                    .padding(.trailing, 4)
                                Text(log.time.formatted(date: .omitted, time: .standard))
                                Text(": ")
                                Text(log.category.rawValue)
                                Text(": ")
                                if let lineNumber = log.lineNumber {
                                    Text("**Line \(lineNumber)**: ")
                                }
                                Text(log.message.fromHTML())
                            }
                            .padding(8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(log.level.color.opacity(0.2))
                    }
                    /// Just use this as anchor point to keep the scrollview at the bottom
                    Divider()
                        .id(1)
                        .task {
                            value.scrollTo(1)
                        }
                        .onChange(of: logs) {
                            value.scrollTo(1)
                        }
                }
            }
        }
        Divider()
        Button("Clear Log Messages") {
            LogUtils.shared.clearLog()
            logs = []
        }
        .frame(height: 50, alignment: .center)
    }
}

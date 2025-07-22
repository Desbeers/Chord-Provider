//
//  DebugView+log.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension DebugView {

    /// The log tab of the `View`
    @ViewBuilder var log: some View {
        ScrollView {
            ScrollViewReader { value in
                LazyVStack(spacing: 0) {
                    /// - Note: This *must* be a LazyVStack or else memory usage will go nuts
                    ForEach(osLogMessages) { log in
                        VStack(alignment: .leading, spacing: 0) {
                            Divider()
                            HStack(alignment: .top, spacing: 0) {
                                Image(systemName: "exclamationmark.bubble")
                                    .foregroundStyle(log.type.color)
                                    .padding(.trailing, 4)
                                Text(log.time.formatted(date: .omitted, time: .standard))
                                Text(": ")
                                Text(log.category)
                                Text(": ")
                                if let lineNumber = log.lineNumber {
                                    Text("**Line \(lineNumber)**: ")
                                }
                                Text(.init(log.message))
                            }
                            .padding(8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(log.type.color.opacity(0.2))
                    }
                    /// Just use this as anchor point to keep the scrollview at the bottom
                    Divider()
                        .id(1)
                        .task {
                            value.scrollTo(1)
                        }
                        .onChange(of: osLogMessages) {
                            value.scrollTo(1)
                        }
                }
            }
        }
        Divider()
        Button("Clear Log Messages") {
            osLogMessages = []
        }
        .frame(height: 50, alignment: .center)
    }
}

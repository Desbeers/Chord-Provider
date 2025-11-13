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
        /// Init the `View`
        init() {
            let messages = LogUtils.shared.fetchLog().map {message in
                var line = "<span foreground='\(message.level.hexColor)'>\(message.level.rawValue)" + ": " + message.category.rawValue + ": "
                if let lineNumber = message.lineNumber {
                    line += "line \(lineNumber): "
                }
                return Message(id: message.id, message: line + message.message + "</span>")
            }
            self.messages = messages
        }
        /// The log messages
        let messages: [Message]
        /// The body of the `View`
        var view: Body {
            Separator()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(messages) { line in
                        Text(line.message)
                            .useMarkup()
                            .halign(.start)
                    }
                }
                .padding(4)
            }
            .hexpand()
        }

        struct Message: Identifiable {
            let id: UUID
            let message: String
        }
    }
}

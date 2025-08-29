//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore


struct LogView: View {
    init() {
        let messages = LogUtils.shared.fetchLog().map {message in
            var line = "<span foreground='\(message.type.hexColor)'>\(message.type.rawValue)" + ": " + message.category.rawValue + ": "
            if let lineNumber = message.lineNumber {
                line += "line \(lineNumber): "
            }
            return Message(id: message.id, message: line + message.message + "</span>")
        }
        self.messages = messages
    }

    let messages: [Message]

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

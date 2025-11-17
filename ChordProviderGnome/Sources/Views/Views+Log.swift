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
        init(main: Bool = true, app: AdwaitaApp) {
            let messages = LogUtils.shared.fetchLog().map { message in
                let text = Utils.convertMarkdown(message.message)
                return Message(
                    id: message.id,
                    line: message.lineNumber,
                    level: message.level,
                    message: text
                )
            }
            self.messages = messages
            self.main = main
            self.app = app
        }
        let main: Bool
        /// The app
        let app: AdwaitaApp
        /// The log messages
        let messages: [Message]
        /// The body of the `View`
        var view: Body {
            Separator()
            HStack {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(messages) { line in
                            HStack {
                                if let line = line.line {
                                    Text("Line \(line): ")
                                }
                                Text(line.message)
                                    .useMarkup()
                                    .style(line.level.style)
                                    .halign(.start)
                            }
                        }
                    }
                    .padding()
                }
                .hexpand()
                if main {
                    Button("Parser Info") {
                        app.showWindow("debug")
                    }
                    .tooltip("See how your song is parsed")
                    .padding()
                    .valign(.start)
                    .halign(.end)
                }
            }
            .vexpand(!main)
        }

        struct Message: Identifiable {
            let id: UUID
            let line: Int?
            let level: LogUtils.Level
            let message: String
        }
    }
}
